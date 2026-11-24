import 'package:material_ui/material_ui.dart';

import '../ble/vibemic_ble.dart';
import '../input/key_injector.dart';
import '../l10n/l10n_ext.dart';
import '../settings/app_settings.dart';
import 'connection_page.dart';
import 'general_page.dart';
import 'mapping_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.ble,
    required this.settings,
    required this.injector,
  });

  final VibeMicBle ble;
  final AppSettings settings;
  final KeyInjector injector;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.settings.autoScanOnLaunch) {
        widget.ble.startScanAndConnect();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final pages = [
      ConnectionPage(ble: widget.ble, settings: widget.settings, injector: widget.injector),
      MappingPage(ble: widget.ble, settings: widget.settings),
      GeneralPage(ble: widget.ble, settings: widget.settings),
    ];

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: index,
            onDestinationSelected: (i) => setState(() => index = i),
            labelType: NavigationRailLabelType.all,
            leading: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Column(
                children: [
                  Icon(Icons.mic_external_on, color: Theme.of(context).colorScheme.primary, size: 28),
                  const SizedBox(height: 4),
                  Text(l10n.appTitle, style: Theme.of(context).textTheme.labelLarge),
                ],
              ),
            ),
            destinations: [
              NavigationRailDestination(
                icon: const Icon(Icons.bluetooth_outlined),
                selectedIcon: const Icon(Icons.bluetooth_connected),
                label: Text(l10n.navConnection),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.keyboard_alt_outlined),
                selectedIcon: const Icon(Icons.keyboard_alt),
                label: Text(l10n.navMapping),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.tune_outlined),
                selectedIcon: const Icon(Icons.tune),
                label: Text(l10n.navGeneral),
              ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: pages[index]),
        ],
      ),
    );
  }
}
