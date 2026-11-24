import 'package:shared_preferences/shared_preferences.dart';

import '../input/key_injector.dart';
import '../macros/macro_models.dart';

class AppSettings {
  AppSettings(this.macros);

  final MacroStore macros;
  String? audioDeviceId;
  double gain = 1.0;
  VoiceModifier voiceModifier = VoiceModifier.ctrlWin;
  bool autoScanOnLaunch = true;
  bool autoReconnect = true;
  bool showScanDebug = false;
  bool mappingEnabled = true;

  static const _kDevice = 'audio_device_id';
  static const _kGain = 'gain';
  static const _kMod = 'voice_modifier';
  static const _kMacros = 'macros_json';
  static const _kAutoScan = 'auto_scan';
  static const _kAutoReconnect = 'auto_reconnect';
  static const _kShowDebug = 'show_scan_debug';
  static const _kMappingEnabled = 'mapping_enabled';

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    audioDeviceId = p.getString(_kDevice);
    gain = p.getDouble(_kGain) ?? 1.0;
    final mod = p.getString(_kMod);
    if (mod != null) {
      voiceModifier = VoiceModifier.values.firstWhere(
        (e) => e.name == mod,
        orElse: () => voiceModifier,
      );
    }
    final m = p.getString(_kMacros);
    if (m != null) macros.decode(m);
    autoScanOnLaunch = p.getBool(_kAutoScan) ?? true;
    autoReconnect = p.getBool(_kAutoReconnect) ?? true;
    showScanDebug = p.getBool(_kShowDebug) ?? false;
    mappingEnabled = p.getBool(_kMappingEnabled) ?? true;
  }

  Future<void> save() async {
    final p = await SharedPreferences.getInstance();
    if (audioDeviceId != null) await p.setString(_kDevice, audioDeviceId!);
    await p.setDouble(_kGain, gain);
    await p.setString(_kMod, voiceModifier.name);
    await p.setString(_kMacros, macros.encode());
    await p.setBool(_kAutoScan, autoScanOnLaunch);
    await p.setBool(_kAutoReconnect, autoReconnect);
    await p.setBool(_kShowDebug, showScanDebug);
    await p.setBool(_kMappingEnabled, mappingEnabled);
  }
}
