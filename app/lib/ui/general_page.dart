import 'package:material_ui/material_ui.dart';

import '../ble/vibemic_ble.dart';
import '../l10n/l10n_ext.dart';
import '../settings/app_settings.dart';

class GeneralPage extends StatefulWidget {
  const GeneralPage({
    super.key,
    required this.ble,
    required this.settings,
  });

  final VibeMicBle ble;
  final AppSettings settings;

  @override
  State<GeneralPage> createState() => _GeneralPageState();
}

class _GeneralPageState extends State<GeneralPage> {
  @override
  Widget build(BuildContext context) {
    final s = widget.settings;
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 40),
      children: [
        Text(l10n.generalTitle, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 6),
        Text(
          l10n.generalHint,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 16),
        Text(l10n.language, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        DropdownMenu<AppLanguage>(
          initialSelection: s.language,
          dropdownMenuEntries: AppLanguage.all
              .map((lang) => DropdownMenuEntry(value: lang, label: lang.displayName(l10n)))
              .toList(),
          onSelected: (lang) async {
            if (lang == null) return;
            await s.setLanguage(lang);
            setState(() {});
          },
          width: double.infinity,
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.autoScan),
          subtitle: Text(l10n.autoScanSub),
          value: s.autoScanOnLaunch,
          onChanged: (v) async {
            setState(() => s.autoScanOnLaunch = v);
            await s.save();
          },
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.autoReconnect),
          subtitle: Text(l10n.autoReconnectSub),
          value: s.autoReconnect,
          onChanged: (v) async {
            setState(() {
              s.autoReconnect = v;
              widget.ble.autoReconnect = v;
            });
            await s.save();
          },
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.showScanDebug),
          subtitle: Text(l10n.showScanDebugSub),
          value: s.showScanDebug,
          onChanged: (v) async {
            setState(() => s.showScanDebug = v);
            await s.save();
          },
        ),
        const Divider(height: 32),
        Text(l10n.tipsTitle, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(l10n.tip1),
        const SizedBox(height: 6),
        Text(l10n.tip2),
        const SizedBox(height: 6),
        Text(l10n.tip3),
        const SizedBox(height: 6),
        Text(l10n.tip4),
        const SizedBox(height: 6),
        Text(l10n.tip5),
        const SizedBox(height: 6),
        Text(l10n.tip6),
        const Divider(height: 32),
        Text(l10n.aboutTitle, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(l10n.aboutBody),
      ],
    );
  }
}
