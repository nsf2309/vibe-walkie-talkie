import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../input/key_injector.dart';
import '../l10n/l10n_ext.dart';
import '../macros/macro_models.dart';

class AppSettings {
  AppSettings(this.macros);

  final MacroStore macros;
  String? audioDeviceId;
  double gain = 1.0;
  VoiceModifier voiceModifier = VoiceModifier.ctrlWin;
  bool autoScanOnLaunch = true;
  bool autoReconnect = true;
  bool showScanDebug = false;
  bool mappingEnabled = true;
  /// null / empty = follow OS locale.
  String? localeCode;

  /// Bumped when language changes so MaterialApp rebuilds.
  final ValueNotifier<int> localeEpoch = ValueNotifier(0);

  AppLanguage get language => AppLanguage.fromCode(localeCode);

  static const _kDevice = 'audio_device_id';
  static const _kGain = 'gain';
  static const _kMod = 'voice_modifier';
  static const _kMacros = 'macros_json';
  static const _kAutoScan = 'auto_scan';
  static const _kAutoReconnect = 'auto_reconnect';
  static const _kShowDebug = 'show_scan_debug';
  static const _kMappingEnabled = 'mapping_enabled';
  static const _kLocale = 'locale_code';

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    audioDeviceId = p.getString(_kDevice);
    gain = p.getDouble(_kGain) ?? 1.0;
    final mod = p.getString(_kMod);
    if (mod != null) {
      voiceModifier = VoiceModifier.values.firstWhere(
        (e) => e.name == mod,
        orElse: () => voiceModifier,
      );
    }
    final m = p.getString(_kMacros);
    if (m != null) macros.decode(m);
    autoScanOnLaunch = p.getBool(_kAutoScan) ?? true;
    autoReconnect = p.getBool(_kAutoReconnect) ?? true;
    showScanDebug = p.getBool(_kShowDebug) ?? false;
    mappingEnabled = p.getBool(_kMappingEnabled) ?? true;
    localeCode = p.getString(_kLocale);
    if (localeCode == 'system') localeCode = null;
  }

  Future<void> save() async {
    final p = await SharedPreferences.getInstance();
    if (audioDeviceId != null) await p.setString(_kDevice, audioDeviceId!);
    await p.setDouble(_kGain, gain);
    await p.setString(_kMod, voiceModifier.name);
    await p.setString(_kMacros, macros.encode());
    await p.setBool(_kAutoScan, autoScanOnLaunch);
    await p.setBool(_kAutoReconnect, autoReconnect);
    await p.setBool(_kShowDebug, showScanDebug);
    await p.setBool(_kMappingEnabled, mappingEnabled);
    if (localeCode == null) {
      await p.remove(_kLocale);
    } else {
      await p.setString(_kLocale, localeCode!);
    }
  }

  Future<void> setLanguage(AppLanguage lang) async {
    localeCode = lang.code;
    localeEpoch.value++;
    await save();
  }
}
