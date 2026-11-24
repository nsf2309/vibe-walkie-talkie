import 'package:material_ui/material_ui.dart';

import '../ble/vibemic_ble.dart';
import '../input/key_injector.dart';
import '../l10n/l10n_ext.dart';
import '../settings/app_settings.dart';
import 'macros_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.ble,
    required this.settings,
    required this.injector,
  });

  final VibeMicBle ble;
  final AppSettings settings;
  final KeyInjector injector;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Auto-scan once so bring-up can be observed from console logs.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.ble.startScanAndConnect();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ble = widget.ble;
    return Scaffold(
      appBar: AppBar(
        title: const Text('VibeMic'),
        actions: [
          IconButton(
            tooltip: 'Macros',
            icon: const Icon(Icons.keyboard_alt_outlined),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MacrosPage(
                    macros: widget.settings.macros,
                    onChanged: () => widget.settings.save(),
                  ),
                ),
              );
              setState(() {});
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ValueListenableBuilder(
            valueListenable: ble.status,
            builder: (_, status, __) => Text(
              formatBleStatus(context.l10n, status),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 8),
          ValueListenableBuilder(
            valueListenable: ble.connected,
            builder: (_, on, __) => Text(on ? 'Device linked' : 'Not connected'),
          ),
          const SizedBox(height: 8),
          ValueListenableBuilder(
            valueListenable: ble.scanDebug,
            builder: (_, lines, __) {
              if (lines.isEmpty) return const SizedBox.shrink();
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  lines.take(12).join('\n'),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'Consolas'),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              FilledButton(
                onPressed: () => ble.startScanAndConnect(),
                child: const Text('Scan & connect'),
              ),
              OutlinedButton(
                onPressed: () => ble.disconnect(),
                child: const Text('Disconnect'),
              ),
              OutlinedButton(
                onPressed: () => ble.requestTestTone(),
                child: const Text('1s test tone'),
              ),
              ValueListenableBuilder(
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
                      child: Text(down ? 'Soft PTT…' : 'Hold Soft PTT'),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ValueListenableBuilder(
            valueListenable: ble.ptt,
            builder: (_, down, __) => Row(
              children: [
                Icon(Icons.mic, color: down ? Colors.red : Colors.grey),
                const SizedBox(width: 8),
                Text(down ? 'PTT streaming' : 'PTT idle'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ValueListenableBuilder(
            valueListenable: ble.lastButton,
            builder: (_, ev, __) => Text(
              context.l10n.lastKey(formatLastButton(context.l10n, ev)),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 8),
          ValueListenableBuilder(
            valueListenable: ble.level,
            builder: (_, lv, __) => LinearProgressIndicator(value: lv.clamp(0.0, 1.0)),
          ),
          const SizedBox(height: 4),
          ValueListenableBuilder(
            valueListenable: ble.frames,
            builder: (_, n, __) => Text('Audio frames: $n', style: Theme.of(context).textTheme.bodySmall),
          ),
          const SizedBox(height: 24),
          Text('Virtual mic', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          FutureBuilder(
            future: ble.mic.listDevices(),
            builder: (context, snap) {
              final devices = snap.data ?? [];
              final selected = widget.settings.audioDeviceId ??
                  (devices.isNotEmpty ? devices.first.id : null);
              return DropdownMenu<String>(
                initialSelection: selected,
                dropdownMenuEntries: devices
                    .map((d) => DropdownMenuEntry(value: d.id, label: d.name))
                    .toList(),
                onSelected: (id) async {
                  if (id == null) return;
                  widget.settings.audioDeviceId = id;
                  await ble.mic.selectDevice(id);
                  await widget.settings.save();
                  setState(() {});
                },
                hintText: 'Loopback device',
                width: double.infinity,
              );
            },
          ),
          const SizedBox(height: 16),
          Text('Voice modifier: ${widget.injector.voiceModifier.name}'),
          DropdownMenu<VoiceModifier>(
            initialSelection: widget.injector.voiceModifier,
            dropdownMenuEntries: VoiceModifier.values
                .map((m) => DropdownMenuEntry(value: m, label: m.name))
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
          const SizedBox(height: 16),
          Slider(
            value: widget.settings.gain.clamp(0.1, 4.0),
            min: 0.1,
            max: 4.0,
            label: 'Gain ${widget.settings.gain.toStringAsFixed(1)}x',
            onChanged: (v) {
              setState(() {
                widget.settings.gain = v;
                ble.mic.gain = v;
              });
            },
            onChangeEnd: (_) => widget.settings.save(),
          ),
          const SizedBox(height: 12),
          ValueListenableBuilder(
            valueListenable: ble.caps,
            builder: (_, c, __) {
              if (c == null) return const Text('Caps: —');
              return Text(
                'Caps v${c.version}  ${c.sampleRateHz} Hz  '
                'buttons=${c.buttonCount}  touchpad=${c.hasTouchpad}',
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Windows: Do NOT connect/pair VibeMic in system Bluetooth settings. '
            'If already paired, remove it, press RST on the board, then Scan here. '
            'The board only allows one BLE link — system pairing blocks this app.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Tip: After connected, pick VB-Cable as virtual mic, hold PTT, watch the level bar.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}