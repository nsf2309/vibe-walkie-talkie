import 'package:material_ui/material_ui.dart';

import '../macros/macro_models.dart';

class MacrosPage extends StatefulWidget {
  const MacrosPage({super.key, required this.macros, required this.onChanged});

  final MacroStore macros;
  final VoidCallback onChanged;

  @override
  State<MacrosPage> createState() => _MacrosPageState();
}

class _MacrosPageState extends State<MacrosPage> {
  @override
  Widget build(BuildContext context) {
    final ids = widget.macros.bindings.keys.toList()..sort();
    return Scaffold(
      appBar: AppBar(title: const Text('Button macros')),
      body: ListView(
        children: [
          for (final id in ids) _bindingTile(widget.macros.bindings[id]!),
        ],
      ),
    );
  }

  Widget _bindingTile(ButtonBinding b) {
    return ExpansionTile(
      title: Text('Key ${b.buttonId}'),
      children: [
        _actionRow('Click', b.onClick),
        _actionRow('Double', b.onDouble),
        _actionRow('Long', b.onLong),
      ],
    );
  }

  Widget _actionRow(String label, MacroAction action) {
    return ListTile(
      title: Text(label),
      subtitle: Text(_describe(action)),
      trailing: const Icon(Icons.edit),
      onTap: () async {
        final next = await showDialog<MacroAction>(
          context: context,
          builder: (_) => _EditActionDialog(initial: action),
        );
        if (next != null) {
          action.type = next.type;
          action.keys = next.keys;
          action.appId = next.appId;
          widget.onChanged();
          setState(() {});
        }
      },
    );
  }

  String _describe(MacroAction a) {
    switch (a.type) {
      case MacroActionType.none:
        return 'None';
      case MacroActionType.keyShortcut:
        return 'Keys: ${a.keys.join("+")}';
      case MacroActionType.openApp:
        return 'Open: ${a.appId}';
      default:
        return a.type.name;
    }
  }
}

class _EditActionDialog extends StatefulWidget {
  const _EditActionDialog({required this.initial});
  final MacroAction initial;

  @override
  State<_EditActionDialog> createState() => _EditActionDialogState();
}

class _EditActionDialogState extends State<_EditActionDialog> {
  late MacroActionType type;
  late TextEditingController keys;
  late TextEditingController app;

  @override
  void initState() {
    super.initState();
    type = widget.initial.type;
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
    return AlertDialog(
      title: const Text('Edit action'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownMenu<MacroActionType>(
            initialSelection: type,
            dropdownMenuEntries: MacroActionType.values
                .map((t) => DropdownMenuEntry(value: t, label: t.name))
                .toList(),
            onSelected: (v) => setState(() => type = v ?? type),
          ),
          if (type == MacroActionType.keyShortcut)
            TextField(
              controller: keys,
              decoration: const InputDecoration(
                labelText: 'Keys (e.g. control+c)',
              ),
            ),
          if (type == MacroActionType.openApp)
            TextField(
              controller: app,
              decoration: const InputDecoration(
                labelText: 'App id (e.g. cursor, chrome, wechat)',
              ),
            ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
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
              ),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}