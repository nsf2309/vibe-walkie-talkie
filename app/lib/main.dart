import 'package:material_ui/material_ui.dart';

import 'audio/virtual_mic.dart';
import 'ble/vibemic_ble.dart';
import 'input/key_injector.dart';
import 'l10n/l10n_ext.dart';
import 'macros/macro_models.dart';
import 'settings/app_settings.dart';
import 'ui/app_shell.dart';
import 'window/window_placement.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final placement = WindowPlacement();
  try {
    await placement.initAndShow();
  } catch (_) {
    // Mobile/web or missing desktop embedding.
  }

  final macros = MacroStore();
  final settings = AppSettings(macros);
  await settings.load();

  final mic = VirtualMic()..gain = settings.gain;
  if (settings.audioDeviceId != null) {
    await mic.selectDevice(settings.audioDeviceId!);
  }
  final injector = KeyInjector()..voiceModifier = settings.voiceModifier;
  final ble = VibeMicBle(
    mic: mic,
    injector: injector,
    macros: macros,
    mappingEnabled: settings.mappingEnabled,
    autoReconnect: settings.autoReconnect,
  );

  runApp(VibeMicApp(ble: ble, settings: settings, injector: injector));
}

class VibeMicApp extends StatelessWidget {
  const VibeMicApp({
    super.key,
    required this.ble,
    required this.settings,
    required this.injector,
  });

  final VibeMicBle ble;
  final AppSettings settings;
  final KeyInjector injector;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: settings.localeEpoch,
      builder: (_, __, ___) {
        final lang = settings.language;
        return MaterialApp(
          onGenerateTitle: (ctx) => AppLocalizations.of(ctx).appTitle,
          locale: lang.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          localeResolutionCallback: (device, supported) {
            if (lang.locale != null) return lang.locale;
            if (device == null) return const Locale('en');
            for (final l in supported) {
              if (l.languageCode == device.languageCode &&
                  (l.countryCode == null ||
                      l.countryCode!.isEmpty ||
                      l.countryCode == device.countryCode)) {
                return l;
              }
            }
            for (final l in supported) {
              if (l.languageCode == device.languageCode) return l;
            }
            return const Locale('en');
          },
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1F6F5B), brightness: Brightness.light),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1F6F5B), brightness: Brightness.dark),
            useMaterial3: true,
          ),
          home: AppShell(ble: ble, settings: settings, injector: injector),
        );
      },
    );
  }
}
