import 'package:material_ui/material_ui.dart';

import '../l10n/l10n_ext.dart';
import '../macros/macro_models.dart';

Future<MacroAction?> showActionEditSheet(
  BuildContext context, {
  required MacroAction initial,
  required String title,
}) {
  return showModalBottomSheet<MacroAction>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => _ActionEditBody(initial: initial, title: title),
  );
}

class _ActionEditBody extends StatefulWidget {
  const _ActionEditBody({required this.initial, required this.title});
  final MacroAction initial;
  final String title;

  @override
  State<_ActionEditBody> createState() => _ActionEditBodyState();
}

class _ActionEditBodyState extends State<_ActionEditBody> {
  late MacroActionType type;
  late TextEditingController keys;
  late TextEditingController app;
  MacroActionCategory category = MacroActionCategory.media;

  @override
  void initState() {
    super.initState();
    type = widget.initial.type;
    category = type == MacroActionType.none ? MacroActionCategory.media : type.category;
    keys = TextEditingController(text: widget.initial.keys.join('+'));
    app = TextEditingController(text: widget.initial.appId);
  }

  @override
  void dispose() {
    keys.dispose();
    app.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final types = MacroActionType.values.where((t) => t.category == category || t == MacroActionType.none).toList();
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 520),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.title.isEmpty ? l10n.editAction : widget.title,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in MacroActionCategory.values)
                  ChoiceChip(
                    label: Text(categoryLabel(l10n, c)),
                    selected: category == c,
                    onSelected: (_) => setState(() {
                      category = c;
                      final first = MacroActionType.values.firstWhere(
                        (t) => t.category == c,
                        orElse: () => MacroActionType.none,
                      );
                      type = first;
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  for (final t in types)
                    ListTile(
                      title: Text(actionLabel(l10n, t)),
                      leading: Icon(
                        type == t ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: type == t ? Theme.of(context).colorScheme.primary : null,
                      ),
                      selected: type == t,
                      onTap: () => setState(() => type = t),
                    ),
                  if (type == MacroActionType.keyShortcut || type == MacroActionType.holdShortcut)
                    TextField(
                      controller: keys,
                      decoration: InputDecoration(labelText: l10n.customShortcutHint),
                    ),
                  if (type == MacroActionType.openApp)
                    TextField(
                      controller: app,
                      decoration: InputDecoration(labelText: l10n.customAppHint),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, MacroAction()),
                  child: Text(l10n.clear),
                ),
                const Spacer(),
                TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      MacroAction(
                        type: type,
                        keys: keys.text
                            .split(RegExp(r'[+\s]+'))
                            .where((s) => s.isNotEmpty)
                            .toList(),
                        appId: app.text.trim(),
                        steps: widget.initial.steps,
                      ),
                    );
                  },
                  child: Text(l10n.save),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
