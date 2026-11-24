import 'package:material_ui/material_ui.dart';

import '../ble/vibemic_ble.dart';
import '../l10n/l10n_ext.dart';
import '../macros/macro_models.dart';
import '../protocol/vibemic_buttons.dart';
import '../settings/app_settings.dart';
import 'action_edit_sheet.dart';

class MappingPage extends StatefulWidget {
  const MappingPage({
    super.key,
    required this.ble,
    required this.settings,
  });

  final VibeMicBle ble;
  final AppSettings settings;

  @override
  State<MappingPage> createState() => _MappingPageState();
}

class _MappingPageState extends State<MappingPage> {
  int selected = keyOk;

  MacroStore get macros => widget.settings.macros;

  Future<void> _edit(String label, MacroAction action, void Function(MacroAction) apply) async {
    final next = await showActionEditSheet(context, initial: action, title: label);
    if (next == null) return;
    apply(next);
    await widget.settings.save();
    setState(() {});
  }

  Widget _key(int id, {double w = 52, double h = 40}) {
    final l10n = context.l10n;
    final selectedHere = selected == id;
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: w,
      height: h,
      child: Material(
        color: selectedHere ? cs.primaryContainer : cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => setState(() => selected = id),
          child: Center(
            child: Text(
              remoteKeyShortLabel(l10n, id),
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ),
      ),
    );
  }

  Widget _sideChip(int id, String text) {
    final selectedHere = selected == id;
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: selectedHere ? cs.secondaryContainer : cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => setState(() => selected = id),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 18),
          // Always rotate for physical left/right edges (LTR layout of the remote).
          child: RotatedBox(
            quarterTurns: 3,
            child: Text(text, style: Theme.of(context).textTheme.labelMedium),
          ),
        ),
      ),
    );
  }

  /// Physical remote face — never mirrored for RTL languages.
  Widget _remotePad(AppLocalizations l10n, ColorScheme cs) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const SizedBox(height: 48),
              Material(
                color: cs.tertiaryContainer,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 28),
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Text(l10n.pttVoice, style: Theme.of(context).textTheme.labelMedium),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(l10n.leftSide, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const SizedBox(width: 8),
          Container(
            width: 240,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _key(keyF4, w: 48, h: 48),
                    _key(keyF5, w: 48, h: 48),
                    _key(keyF6, w: 48, h: 48),
                  ],
                ),
                const SizedBox(height: 14),
                _key(keyUp, w: 48),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _key(keyLeft, w: 48),
                    const SizedBox(width: 6),
                    _key(keyOk, w: 56, h: 56),
                    const SizedBox(width: 6),
                    _key(keyRight, w: 48),
                  ],
                ),
                const SizedBox(height: 6),
                _key(keyDown, w: 48),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _key(keyHome, w: 56, h: 44),
                    _key(keyBack, w: 56, h: 44),
                    _key(keyMenu, w: 56, h: 44),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _key(keyF1, w: 48, h: 48),
                    _key(keyF2, w: 48, h: 48),
                    _key(keyF3, w: 48, h: 48),
                  ],
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder(
                  valueListenable: widget.ble.lastButton,
                  builder: (_, ev, __) => Text(
                    l10n.liveEvent(formatLastButton(l10n, ev)),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              const SizedBox(height: 40),
              _sideChip(keyVolUp, l10n.keyShortVolUp),
              const SizedBox(height: 6),
              _sideChip(keyVolDown, l10n.keyShortVolDown),
              const SizedBox(height: 10),
              _sideChip(keySqueezeVolUp, l10n.keyShortSqueezeVolUp),
              const SizedBox(height: 6),
              _sideChip(keySqueezeVolDown, l10n.keyShortSqueezeVolDown),
              const SizedBox(height: 8),
              Text(l10n.rightSide, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final b = macros.bindings[selected]!;
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;
    final isSqueeze = selected == keySqueezeVolDown || selected == keySqueezeVolUp;
    final title = remoteKeyLabel(l10n, selected);

    return ListView(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 40),
      children: [
        Text(l10n.mappingTitle, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 6),
        Text(
          l10n.mappingHint,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.enableMapping),
          value: widget.settings.mappingEnabled,
          onChanged: (v) async {
            setState(() {
              widget.settings.mappingEnabled = v;
              widget.ble.mappingEnabled = v;
            });
            await widget.settings.save();
          },
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _remotePad(l10n, cs),
            const SizedBox(width: 20),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.titleLarge),
                      Text(l10n.keyId(selected), style: Theme.of(context).textTheme.bodySmall),
                      if (isSqueeze) ...[
                        const SizedBox(height: 8),
                        Text(
                          l10n.squeezeHint,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                        ),
                      ],
                      const SizedBox(height: 8),
                      if (!isSqueeze)
                        _ActionTile(
                          title: l10n.actionHold,
                          action: b.onHold,
                          onEdit: () => _edit('$title · ${l10n.actionHold}', b.onHold, (a) => b.onHold = a),
                        ),
                      _ActionTile(
                        title: isSqueeze ? l10n.actionSqueezeShort : l10n.actionClick,
                        action: b.onClick,
                        onEdit: () => _edit(
                          '$title · ${isSqueeze ? l10n.actionSqueezeShort : l10n.actionClick}',
                          b.onClick,
                          (a) => b.onClick = a,
                        ),
                      ),
                      if (!isSqueeze)
                        _ActionTile(
                          title: l10n.actionDouble,
                          action: b.onDouble,
                          onEdit: () => _edit('$title · ${l10n.actionDouble}', b.onDouble, (a) => b.onDouble = a),
                        ),
                      _ActionTile(
                        title: isSqueeze ? l10n.actionSqueezeLong : l10n.actionLong,
                        action: b.onLong,
                        onEdit: () => _edit(
                          '$title · ${isSqueeze ? l10n.actionSqueezeLong : l10n.actionLong}',
                          b.onLong,
                          (a) => b.onLong = a,
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () async {
                          macros.resetDefaults();
                          await widget.settings.save();
                          setState(() {});
                        },
                        child: Text(l10n.resetDefaults),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.title,
    required this.action,
    required this.onEdit,
  });

  final String title;
  final MacroAction action;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(describeAction(l10n, action)),
      trailing: const Icon(Icons.edit_outlined),
      onTap: onEdit,
    );
  }
}
