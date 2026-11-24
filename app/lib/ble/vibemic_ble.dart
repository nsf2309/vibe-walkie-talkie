import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../audio/ima_adpcm.dart';
import '../audio/virtual_mic.dart';
import '../input/key_injector.dart';
import '../macros/macro_models.dart';
import '../protocol/vibemic_protocol.dart';

class VibeMicBle {
  VibeMicBle({
    required this.mic,
    required this.injector,
    required this.macros,
    this.mappingEnabled = true,
    this.autoReconnect = true,
  });

  final VirtualMic mic;
  final KeyInjector injector;
  final MacroStore macros;
  bool mappingEnabled;
  bool autoReconnect;

  final ImaAdpcmDecoder _adpcm = ImaAdpcmDecoder();
  final ValueNotifier<String> status = ValueNotifier('空闲');
  final ValueNotifier<bool> connected = ValueNotifier(false);
  final ValueNotifier<bool> ptt = ValueNotifier(false);
  final ValueNotifier<DeviceCaps?> caps = ValueNotifier(null);
  final ValueNotifier<double> level = ValueNotifier(0);
  final ValueNotifier<int> frames = ValueNotifier(0);
  final ValueNotifier<String> lastButton = ValueNotifier('—');
  /// Live scan debug lines for the UI / console.
  final ValueNotifier<List<String>> scanDebug = ValueNotifier(const []);

  BluetoothDevice? _device;
  BluetoothCharacteristic? _cmd;
  BluetoothCharacteristic? _audio;
  BluetoothCharacteristic? _ctrl;
  StreamSubscription<List<int>>? _audioSub;
  StreamSubscription<List<int>>? _ctrlSub;
  StreamSubscription<BluetoothConnectionState>? _connSub;
  Timer? _reconnectTimer;
  bool _busy = false;
  bool _userDisconnect = false;

  static bool _nameMatch(String? name) {
    if (name == null || name.isEmpty) return false;
    final n = name.trim();
    return n == kVibeMicName || n.startsWith(kVibeMicName);
  }

  static bool _hasVmMfg(AdvertisementData adv) {
    // company 0xFFFF, payload starts with 'V','M'
    for (final e in adv.manufacturerData.entries) {
      if (e.key == 0xFFFF && e.value.length >= 2 && e.value[0] == 0x56 && e.value[1] == 0x4D) {
        return true;
      }
    }
    return false;
  }

  static bool _scanMatch(ScanResult r) {
    final adv = r.advertisementData.advName;
    final platform = r.device.platformName;
    final hasSvc = r.advertisementData.serviceUuids.any((u) => u == Guid(kUuidService));
    return _nameMatch(adv) || _nameMatch(platform) || hasSvc || _hasVmMfg(r.advertisementData);
  }

  void _log(String msg) {
    debugPrint('[VibeMicBle] $msg');
    status.value = msg;
  }

  Future<BluetoothDevice?> _findAlreadyKnown() async {
    for (final d in FlutterBluePlus.connectedDevices) {
      debugPrint('[VibeMicBle] connectedDevices: ${d.platformName} ${d.remoteId}');
      if (_nameMatch(d.platformName) || _nameMatch(d.advName)) return d;
    }
    try {
      final bonded = await FlutterBluePlus.bondedDevices;
      for (final d in bonded) {
        debugPrint('[VibeMicBle] bonded: ${d.platformName} ${d.remoteId}');
        if (_nameMatch(d.platformName) || _nameMatch(d.advName)) return d;
      }
    } catch (e) {
      debugPrint('[VibeMicBle] bondedDevices err: $e');
    }
    try {
      final sys = await FlutterBluePlus.systemDevices([
        Guid(kUuidService),
        Guid('00001812-0000-1000-8000-00805f9b34fb'),
      ]);
      for (final d in sys) {
        debugPrint('[VibeMicBle] system: ${d.platformName} ${d.remoteId}');
        if (_nameMatch(d.platformName) || _nameMatch(d.advName)) return d;
      }
    } catch (e) {
      debugPrint('[VibeMicBle] systemDevices err: $e');
    }
    return null;
  }

  Future<void> startScanAndConnect({Duration timeout = const Duration(seconds: 20)}) async {
    if (_busy) return;
    _busy = true;
    _userDisconnect = false;
    _reconnectTimer?.cancel();
    scanDebug.value = const [];
    try {
      _log('检查蓝牙…');
      if (!await FlutterBluePlus.isSupported) {
        _log('本机不支持蓝牙');
        return;
      }

      await FlutterBluePlus.adapterState
          .where((s) => s == BluetoothAdapterState.on)
          .first
          .timeout(const Duration(seconds: 10));
      debugPrint('[VibeMicBle] adapter ON');

      final known = await _findAlreadyKnown();
      if (known != null) {
        _log('发现已知设备，连接中…');
        await connect(known);
        return;
      }

      // Ensure previous watcher fully stopped (WinRT bug if restarted too fast).
      try {
        await FlutterBluePlus.stopScan();
        await Future<void>.delayed(const Duration(milliseconds: 400));
      } catch (_) {}

      _log('扫描中 ${timeout.inSeconds}s…');
      final seen = <String, String>{}; // id -> label
      final logged = <String>{};
      final match = Completer<BluetoothDevice>();

      final sub = FlutterBluePlus.scanResults.listen((results) {
        for (final r in results) {
          final id = r.device.remoteId.str;
          final name = r.advertisementData.advName.isNotEmpty
              ? r.advertisementData.advName
              : (r.device.platformName.isNotEmpty ? r.device.platformName : '(no name)');
          final mfg = r.advertisementData.manufacturerData.keys.map((k) => k.toRadixString(16)).join(',');
          final line = '$name  rssi=${r.rssi}  id=$id  mfg=$mfg  conn=${r.advertisementData.connectable}';
          seen[id] = line;
          if (logged.add(id)) {
            debugPrint('[VibeMicBle] ADV $line');
          }
          if (!match.isCompleted && _scanMatch(r)) {
            debugPrint('[VibeMicBle] matched $line');
            match.complete(r.device);
          }
        }
        final lines = seen.values.toList()..sort();
        scanDebug.value = lines;
        if (status.value.startsWith('扫描')) {
          status.value = '扫描中… 已见 ${seen.length} 台设备';
        }
      }, onError: (e) {
        debugPrint('[VibeMicBle] scanResults error: $e');
      });

      await FlutterBluePlus.startScan(
        timeout: timeout,
        continuousUpdates: true,
        androidUsesFineLocation: true,
      );

      BluetoothDevice? found;
      try {
        // WinRT often never flips isScanning=false; stop as soon as we match or time out.
        found = await match.future.timeout(timeout);
      } on TimeoutException {
        found = null;
        for (final r in FlutterBluePlus.lastScanResults) {
          if (_scanMatch(r)) {
            found = r.device;
            break;
          }
        }
      } finally {
        try {
          await FlutterBluePlus.stopScan();
        } catch (_) {}
        await sub.cancel();
        await Future<void>.delayed(const Duration(milliseconds: 300));
      }

      if (found == null) {
        final knownAfter = await _findAlreadyKnown();
        if (knownAfter != null) {
          await connect(knownAfter);
          return;
        }
        final sample = seen.values.take(8).join(' | ');
        _log(
          seen.isEmpty
              ? '扫描到 0 台设备。请检查 Windows 蓝牙，或用手机 nRF Connect 确认板子在广播。'
              : '在 ${seen.length} 条广播中未找到 VibeMic。样例: $sample',
        );
        return;
      }

      _log('找到 VibeMic，连接中…');
      await connect(found);
    } on TimeoutException {
      _log('蓝牙适配器超时');
    } catch (e, st) {
      debugPrint('[VibeMicBle] scan failed: $e\n$st');
      _log('扫描失败: $e');
    } finally {
      _busy = false;
    }
  }

  Future<void> connect(BluetoothDevice device) async {
    final label = device.platformName.isEmpty ? device.remoteId.str : device.platformName;
    _log('正在连接 $label…');
    await _audioSub?.cancel();
    await _ctrlSub?.cancel();
    await _connSub?.cancel();
    _cmd = _audio = _ctrl = null;
    _device = device;

    try {
      await device.connect(license: License.nonprofit, autoConnect: false, timeout: const Duration(seconds: 25));
    } catch (e) {
      _log('连接失败: $e — 请在 Windows 取消配对，按 RST 后重试');
      rethrow;
    }

    connected.value = true;
    _connSub = device.connectionState.listen((s) {
      connected.value = s == BluetoothConnectionState.connected;
      if (!connected.value) {
        _log('已断开');
        unawaited(_teardownSession());
        _scheduleReconnect();
      }
    });

    try {
      await device.requestMtu(247);
    } catch (_) {}

    final services = await device.discoverServices();
    debugPrint('[VibeMicBle] services=${services.map((s) => s.uuid).join(", ")}');
    for (final s in services) {
      if (s.uuid == Guid(kUuidService)) {
        for (final c in s.characteristics) {
          if (c.uuid == Guid(kUuidCmd)) _cmd = c;
          if (c.uuid == Guid(kUuidAudio)) _audio = c;
          if (c.uuid == Guid(kUuidCtrl)) _ctrl = c;
        }
      }
    }
    if (_cmd == null || _audio == null || _ctrl == null) {
      _log('缺少 VibeMic GATT 特征');
      return;
    }

    await _ctrl!.setNotifyValue(true);
    await _audio!.setNotifyValue(true);
    _ctrlSub = _ctrl!.lastValueStream.listen(_onCtrl);
    _audioSub = _audio!.lastValueStream.listen(_onAudio);

    await _cmd!.write([cmdGetCaps], withoutResponse: false);
    await _cmd!.write([cmdSetMode, modeLive], withoutResponse: false);
    await _cmd!.write([cmdSetTouchpad, tpAudioPriority], withoutResponse: false);
    _log('已连接 — 按住 PTT 说话');
  }

  Future<void> disconnect() async {
    _userDisconnect = true;
    _reconnectTimer?.cancel();
    await _teardownSession();
    await _audioSub?.cancel();
    await _ctrlSub?.cancel();
    await _connSub?.cancel();
    try {
      await _device?.disconnect();
    } catch (_) {}
    connected.value = false;
    _log('空闲');
  }

  void _scheduleReconnect() {
    if (_userDisconnect || !autoReconnect || _busy) return;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 3), () {
      if (_userDisconnect || connected.value || _busy) return;
      _log('自动重连中…');
      unawaited(startScanAndConnect());
    });
  }

  Future<void> requestTestTone([int ms = 1000]) async {
    if (_cmd == null) {
      _log('未连接');
      return;
    }
    await mic.beginSession();
    await _cmd!.write([cmdTestTone, ms & 0xff, (ms >> 8) & 0xff], withoutResponse: false);
    _log('测试音 ${ms}ms…');
    Future<void>.delayed(Duration(milliseconds: ms + 200), () async {
      if (!ptt.value) {
        await mic.endSession();
        if (connected.value) _log('已连接 — 按住 PTT 说话');
      }
    });
  }

  void _onCtrl(List<int> value) {
    if (value.isEmpty) return;
    switch (value[0]) {
      case ctrlCaps:
        caps.value = DeviceCaps.tryParse(value);
        break;
      case ctrlPttState:
        unawaited(_onPtt(value.length > 1 && value[1] == 1));
        break;
      case ctrlButton:
        if (value.length >= 3) unawaited(_onButton(value[1], value[2]));
        break;
      case ctrlSync:
        _adpcm.reset();
        break;
      case ctrlNack:
        _log('设备 NACK');
        break;
    }
  }

  Future<void> _onPtt(bool down) async {
    ptt.value = down;
    if (down) {
      _adpcm.reset();
      frames.value = 0;
      await mic.beginSession();
      await injector.voiceSessionBegin();
      _log('PTT 推流中…');
    } else {
      await mic.endSession();
      await injector.voiceSessionEnd();
      level.value = 0;
      if (connected.value) _log('已连接 — 按住 PTT 说话');
    }
  }

  Future<void> softPtt(bool down) => _onPtt(down);

  Future<void> _onButton(int id, int event) async {
    const names = {
      btnUp: '抬起',
      btnDown: '按下',
      btnClick: '单击',
      btnDouble: '双击',
      btnLong: '长按',
    };
    lastButton.value = '按键 $id · ${names[event] ?? event}';
    debugPrint('[VibeMicBle] button $id event $event');

    if (!mappingEnabled) return;
    final b = macros.bindings[id];
    if (b == null) return;

    // Holdable: key-down on press, key-up on release (arrows / holdShortcut).
    if (event == btnDown) {
      final hold = b.onHold.type != MacroActionType.none ? b.onHold : b.onClick;
      if (hold.type.isHoldable) {
        final keys = hold.resolveKeys();
        if (keys.isNotEmpty) await injector.keyDown(keys);
      }
      return;
    }
    if (event == btnUp) {
      final hold = b.onHold.type != MacroActionType.none ? b.onHold : b.onClick;
      if (hold.type.isHoldable) {
        final keys = hold.resolveKeys();
        if (keys.isNotEmpty) await injector.keyUp(keys);
      }
      return;
    }

    MacroAction? action;
    switch (event) {
      case btnClick:
        // Skip click fire when this binding is hold-only (already handled).
        if (b.onHold.type.isHoldable && b.onClick.type == MacroActionType.none) {
          return;
        }
        if (b.onClick.type.isHoldable) return;
        action = b.onClick;
        break;
      case btnDouble:
        action = b.onDouble;
        break;
      case btnLong:
        action = b.onLong;
        break;
    }
    if (action == null || action.type == MacroActionType.none) return;
    await _runAction(action);
  }

  Future<void> _runAction(MacroAction a) async {
    switch (a.type) {
      case MacroActionType.none:
        break;
      case MacroActionType.keyShortcut:
        await injector.tapShortcut(a.keys);
        break;
      case MacroActionType.holdShortcut:
        // Fired only via down/up path.
        break;
      case MacroActionType.openApp:
        if (a.appId.isNotEmpty) await injector.openApp(a.appId);
        break;
      case MacroActionType.combination:
        for (final step in a.steps) {
          await _runAction(step);
          await Future<void>.delayed(const Duration(milliseconds: 80));
        }
        break;
      default:
        final app = a.type.presetAppId;
        if (app != null) {
          await injector.openApp(app);
          break;
        }
        final keys = a.type.presetKeys;
        if (keys != null) {
          await injector.tapShortcut(keys);
        }
        break;
    }
  }

  void _onAudio(List<int> value) {
    if (value.length < kAudioHdrSize + 1) return;
    final flags = value[1];
    if ((flags & aflagSync) != 0 || (flags & aflagSessionStart) != 0) {
      _adpcm.reset();
    }
    final pcm = _adpcm.decode(value.sublist(kAudioHdrSize));
    var peak = 0;
    for (final s in pcm) {
      final a = s.abs();
      if (a > peak) peak = a;
    }
    level.value = peak / 32768.0;
    frames.value = frames.value + 1;
    if (!mic.sessionOpen) unawaited(mic.beginSession());
    unawaited(mic.writePcm16(pcm));
  }

  Future<void> _teardownSession() async {
    if (ptt.value) {
      ptt.value = false;
      await injector.voiceSessionEnd();
    }
    await mic.endSession();
    level.value = 0;
  }
}
