import 'package:material_ui/material_ui.dart';

import '../ble/vibemic_ble.dart';
import '../input/key_injector.dart';
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
                  Text('VibeMic', style: Theme.of(context).textTheme.labelLarge),
                ],
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.bluetooth_outlined),
                selectedIcon: Icon(Icons.bluetooth_connected),
                label: Text('连接与语音'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.keyboard_alt_outlined),
                selectedIcon: Icon(Icons.keyboard_alt),
                label: Text('按键映射'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.tune_outlined),
                selectedIcon: Icon(Icons.tune),
                label: Text('通用'),
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
