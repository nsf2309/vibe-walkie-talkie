import 'package:material_ui/material_ui.dart';

import '../audio/virtual_mic.dart';
import '../ble/vibemic_ble.dart';
import '../input/key_injector.dart';
import '../l10n/l10n_ext.dart';
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
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 40),
      children: [
        Text(l10n.connectionTitle, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 6),
        Text(
          l10n.connectionHint,
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
                              Text(on ? l10n.connected : l10n.notConnected,
                                  style: Theme.of(context).textTheme.titleMedium),
                              Text(formatBleStatus(l10n, status),
                                  style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: ble.ptt,
                        builder: (_, down, __) => Chip(
                          avatar: Icon(Icons.mic, size: 16, color: down ? Colors.red : null),
                          label: Text(down ? l10n.streaming : l10n.idle),
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
                  builder: (_, n, __) => Text(l10n.audioFrames(n), style: Theme.of(context).textTheme.bodySmall),
                ),
                const SizedBox(height: 4),
                ValueListenableBuilder(
                  valueListenable: ble.lastButton,
                  builder: (_, ev, __) =>
                      Text(l10n.lastKey(formatLastButton(l10n, ev)), style: Theme.of(context).textTheme.bodySmall),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    FilledButton.icon(
                      onPressed: () => ble.startScanAndConnect(),
                      icon: const Icon(Icons.search),
                      label: Text(l10n.scanConnect),
                    ),
                    OutlinedButton(onPressed: () => ble.disconnect(), child: Text(l10n.disconnect)),
                    OutlinedButton(onPressed: () => ble.requestTestTone(), child: Text(l10n.testTone)),
                    _SoftPtt(ble: ble),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(l10n.virtualMic, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(
          l10n.virtualMicHint,
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
                      hintText: l10n.selectLoopback,
                      width: double.infinity,
                    ),
            ),
            IconButton(
              tooltip: l10n.refreshDevices,
              onPressed: _refreshDevices,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(l10n.voiceModifier, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        Text(
          l10n.voiceModifierHint,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: 8),
        DropdownMenu<VoiceModifier>(
          initialSelection: widget.injector.voiceModifier,
          dropdownMenuEntries: VoiceModifier.values
              .map((m) => DropdownMenuEntry(value: m, label: voiceModifierLabel(l10n, m)))
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
          l10n.gain(widget.settings.gain.toStringAsFixed(1)),
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
              l10n.deviceCaps(
                c.version,
                c.sampleRateHz,
                c.buttonCount,
                c.hasTouchpad ? l10n.yes : l10n.no,
              ),
              style: Theme.of(context).textTheme.bodySmall,
            );
          },
        ),
        if (widget.settings.showScanDebug) ...[
          const SizedBox(height: 16),
          Text(l10n.scanDebug, style: Theme.of(context).textTheme.titleSmall),
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
                lines.isEmpty ? l10n.empty : lines.take(16).join('\n'),
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
    final l10n = context.l10n;
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
            child: Text(down ? l10n.softPttActive : l10n.softPtt),
          ),
        ),
      ),
    );
  }
}
