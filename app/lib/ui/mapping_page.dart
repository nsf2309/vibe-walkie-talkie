import 'package:material_ui/material_ui.dart';

import '../ble/vibemic_ble.dart';
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

  Widget _key(int id, {double w = 56, double h = 44}) {
    final info = remoteKeyById(id)!;
    final selectedHere = selected == id;
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: w,
      height: h,
      child: Material(
        color: selectedHere ? cs.primaryContainer : cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => setState(() => selected = id),
          child: Center(
            child: Text(
              info.shortLabel,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final b = macros.bindings[selected]!;
    final info = remoteKeyById(selected)!;
    final cs = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 40),
      children: [
        Text('按键映射', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 6),
        Text(
          '方向键可按住连发；菜单默认打开多任务视图，再用左右切换、OK 确认。'
          'F1/F2/F3 默认 Agent 接受 / 拒绝 / 新建会话。',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('启用按键映射'),
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
            // Remote face
            Container(
              width: 260,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Column(
                children: [
                  Material(
                    color: cs.tertiaryContainer,
                    borderRadius: BorderRadius.circular(10),
                    child: const SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: Center(child: Text('PTT 语音')),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _key(keyUp),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _key(keyLeft),
                      const SizedBox(width: 6),
                      _key(keyOk, w: 64, h: 52),
                      const SizedBox(width: 6),
                      _key(keyRight),
                    ],
                  ),
                  const SizedBox(height: 6),
                  _key(keyDown),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _key(keyVolDown, w: 48),
                      _key(keyVolUp, w: 48),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _key(keyBack, w: 70),
                      _key(keyHome, w: 70),
                      _key(keyMenu, w: 70),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    alignment: WrapAlignment.center,
                    children: [
                      for (final id in [keyF1, keyF2, keyF3, keyF4, keyF5, keyF6])
                        _key(id, w: 48, h: 36),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ValueListenableBuilder(
                    valueListenable: widget.ble.lastButton,
                    builder: (_, ev, __) => Text('实时：$ev', style: Theme.of(context).textTheme.bodySmall),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('${info.label}（ID ${info.id}）',
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      _ActionTile(
                        title: '按住（方向键推荐）',
                        action: b.onHold,
                        onEdit: () => _edit('${info.label} · 按住', b.onHold, (a) => b.onHold = a),
                      ),
                      _ActionTile(
                        title: '单击',
                        action: b.onClick,
                        onEdit: () => _edit('${info.label} · 单击', b.onClick, (a) => b.onClick = a),
                      ),
                      _ActionTile(
                        title: '双击',
                        action: b.onDouble,
                        onEdit: () => _edit('${info.label} · 双击', b.onDouble, (a) => b.onDouble = a),
                      ),
                      _ActionTile(
                        title: '长按',
                        action: b.onLong,
                        onEdit: () => _edit('${info.label} · 长按', b.onLong, (a) => b.onLong = a),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () async {
                          macros.resetDefaults();
                          await widget.settings.save();
                          setState(() {});
                        },
                        child: const Text('恢复默认映射'),
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
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(action.describe()),
      trailing: const Icon(Icons.edit_outlined),
      onTap: onEdit,
    );
  }
}
