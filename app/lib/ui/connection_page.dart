import 'package:material_ui/material_ui.dart';

import '../audio/virtual_mic.dart';
import '../ble/vibemic_ble.dart';
import '../input/key_injector.dart';
import '../settings/app_settings.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({
    super.key,
    required this.ble,
    required this.settings,
    required this.injector,
  });

  final VibeMicBle ble;
  final AppSettings settings;
  final KeyInjector injector;

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  List<AudioDeviceInfo> _devices = const [];
  bool _loadingDevices = true;

  @override
  void initState() {
    super.initState();
    _refreshDevices();
  }

  Future<void> _refreshDevices() async {
    setState(() => _loadingDevices = true);
    final list = await widget.ble.mic.listDevices();
    if (!mounted) return;
    setState(() {
      _devices = list;
      _loadingDevices = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ble = widget.ble;
    final cs = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 40),
      children: [
        Text('连接与语音', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 6),
        Text(
          '按住板上 PTT 说话；松开停止。不要在 Windows 系统蓝牙里配对 VibeMic。',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder(
                  valueListenable: ble.connected,
                  builder: (_, on, __) => Row(
                    children: [
                      Icon(on ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                          color: on ? cs.primary : cs.outline),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ValueListenableBuilder(
                          valueListenable: ble.status,
                          builder: (_, status, __) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(on ? '已连接 VibeMic' : '未连接',
                                  style: Theme.of(context).textTheme.titleMedium),
                              Text(status, style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: ble.ptt,
                        builder: (_, down, __) => Chip(
                          avatar: Icon(Icons.mic, size: 16, color: down ? Colors.red : null),
                          label: Text(down ? '推流中' : '待机'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder(
                  valueListenable: ble.level,
                  builder: (_, lv, __) => LinearProgressIndicator(value: lv.clamp(0.0, 1.0)),
                ),
                const SizedBox(height: 4),
                ValueListenableBuilder(
                  valueListenable: ble.frames,
                  builder: (_, n, __) => Text('音频帧 $n', style: Theme.of(context).textTheme.bodySmall),
                ),
                const SizedBox(height: 4),
                ValueListenableBuilder(
                  valueListenable: ble.lastButton,
                  builder: (_, ev, __) => Text('最近按键：$ev', style: Theme.of(context).textTheme.bodySmall),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    FilledButton.icon(
                      onPressed: () => ble.startScanAndConnect(),
                      icon: const Icon(Icons.search),
                      label: const Text('扫描并连接'),
                    ),
                    OutlinedButton(onPressed: () => ble.disconnect(), child: const Text('断开')),
                    OutlinedButton(onPressed: () => ble.requestTestTone(), child: const Text('1 秒测试音')),
                    _SoftPtt(ble: ble),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text('虚拟麦克风', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(
          '伴侣写入下方「播放设备」；微信/输入法请选择对应的 CABLE Output 作为麦克风。',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _loadingDevices
                  ? const LinearProgressIndicator()
                  : DropdownMenu<String>(
                      initialSelection: widget.settings.audioDeviceId ??
                          (_devices.isNotEmpty ? _devices.first.id : null),
                      dropdownMenuEntries: _devices
                          .map((d) => DropdownMenuEntry(value: d.id, label: d.name))
                          .toList(),
                      onSelected: (id) async {
                        if (id == null) return;
                        widget.settings.audioDeviceId = id;
                        await ble.mic.selectDevice(id);
                        await widget.settings.save();
                        setState(() {});
                      },
                      hintText: '选择 CABLE Input / 回环设备',
                      width: double.infinity,
                    ),
            ),
            IconButton(
              tooltip: '刷新设备',
              onPressed: _refreshDevices,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text('语音修饰键', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        Text(
          'PTT 按下时注入，用于触发输入法语音（Windows 微信输入法默认 Ctrl+Win）。',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: 8),
        DropdownMenu<VoiceModifier>(
          initialSelection: widget.injector.voiceModifier,
          dropdownMenuEntries: VoiceModifier.values
              .map((m) => DropdownMenuEntry(value: m, label: m.labelZh))
              .toList(),
          onSelected: (m) async {
            if (m == null) return;
            setState(() {
              widget.injector.voiceModifier = m;
              widget.settings.voiceModifier = m;
            });
            await widget.settings.save();
          },
          width: double.infinity,
        ),
        const SizedBox(height: 20),
        Text(
          '增益 ${widget.settings.gain.toStringAsFixed(1)}×',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Slider(
          value: widget.settings.gain.clamp(0.1, 4.0),
          min: 0.1,
          max: 4.0,
          divisions: 39,
          label: '${widget.settings.gain.toStringAsFixed(1)}×',
          onChanged: (v) {
            setState(() {
              widget.settings.gain = v;
              ble.mic.gain = v;
            });
          },
          onChangeEnd: (_) => widget.settings.save(),
        ),
        ValueListenableBuilder(
          valueListenable: ble.caps,
          builder: (_, c, __) {
            if (c == null) return const SizedBox.shrink();
            return Text(
              '设备能力：协议 v${c.version} · ${c.sampleRateHz} Hz · '
              '${c.buttonCount} 键 · 触控板=${c.hasTouchpad ? "有" : "无"}',
              style: Theme.of(context).textTheme.bodySmall,
            );
          },
        ),
        if (widget.settings.showScanDebug) ...[
          const SizedBox(height: 16),
          Text('扫描调试', style: Theme.of(context).textTheme.titleSmall),
          ValueListenableBuilder(
            valueListenable: ble.scanDebug,
            builder: (_, lines, __) => Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                lines.isEmpty ? '（无）' : lines.take(16).join('\n'),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'Consolas'),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _SoftPtt extends StatelessWidget {
  const _SoftPtt({required this.ble});
  final VibeMicBle ble;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ble.ptt,
      builder: (_, down, __) => Material(
        color: down
            ? Theme.of(context).colorScheme.errorContainer
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTapDown: (_) => ble.softPtt(true),
          onTapUp: (_) => ble.softPtt(false),
          onTapCancel: () => ble.softPtt(false),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(down ? '软件 PTT…' : '按住软件 PTT'),
          ),
        ),
      ),
    );
  }
}
