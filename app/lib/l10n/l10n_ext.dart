import 'package:flutter/widgets.dart';

import '../ble/ble_ui_status.dart';
import '../input/key_injector.dart';
import '../macros/macro_models.dart';
import '../protocol/vibemic_buttons.dart';
import '../protocol/vibemic_protocol.dart';
import 'app_localizations.dart';

export 'app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

String formatBleStatus(AppLocalizations l10n, BleUiStatus s) {
  switch (s.code) {
    case BleStatusCode.idle:
      return l10n.statusIdle;
    case BleStatusCode.checkingBluetooth:
      return l10n.statusCheckingBluetooth;
    case BleStatusCode.unsupported:
      return l10n.statusUnsupported;
    case BleStatusCode.knownConnecting:
      return l10n.statusKnownConnecting;
    case BleStatusCode.scanning:
      return l10n.statusScanning(s.n ?? 0);
    case BleStatusCode.scanningSeen:
      return l10n.statusScanningSeen(s.n ?? 0);
    case BleStatusCode.noDevices:
      return l10n.statusNoDevices;
    case BleStatusCode.notFound:
      return l10n.statusNotFound(s.n ?? 0, s.s ?? '');
    case BleStatusCode.foundConnecting:
      return l10n.statusFoundConnecting;
    case BleStatusCode.adapterTimeout:
      return l10n.statusAdapterTimeout;
    case BleStatusCode.scanFailed:
      return l10n.statusScanFailed(s.s ?? '');
    case BleStatusCode.connecting:
      return l10n.statusConnecting(s.s ?? '');
    case BleStatusCode.connectFailed:
      return l10n.statusConnectFailed(s.s ?? '');
    case BleStatusCode.disconnected:
      return l10n.statusDisconnected;
    case BleStatusCode.missingGatt:
      return l10n.statusMissingGatt;
    case BleStatusCode.connectedReady:
      return l10n.statusConnectedReady;
    case BleStatusCode.reconnecting:
      return l10n.statusReconnecting;
    case BleStatusCode.notConnected:
      return l10n.statusNotConnected;
    case BleStatusCode.testTone:
      return l10n.statusTestTone(s.n ?? 0);
    case BleStatusCode.deviceNack:
      return l10n.statusDeviceNack;
    case BleStatusCode.pttStreaming:
      return l10n.statusPttStreaming;
  }
}

String formatButtonEvent(AppLocalizations l10n, int event) {
  switch (event) {
    case btnUp:
      return l10n.btnEventUp;
    case btnDown:
      return l10n.btnEventDown;
    case btnClick:
      return l10n.btnEventClick;
    case btnDouble:
      return l10n.btnEventDouble;
    case btnLong:
      return l10n.btnEventLong;
    default:
      return '$event';
  }
}

String formatLastButton(AppLocalizations l10n, LastButtonEvent? ev) {
  if (ev == null) return '—';
  return l10n.lastKeyDetail(ev.id, formatButtonEvent(l10n, ev.event));
}

String actionLabel(AppLocalizations l10n, MacroActionType type) {
  switch (type) {
    case MacroActionType.none:
      return l10n.actionNone;
    case MacroActionType.keyShortcut:
      return l10n.actionKeyShortcut;
    case MacroActionType.holdShortcut:
      return l10n.actionHoldShortcut;
    case MacroActionType.openApp:
      return l10n.actionOpenApp;
    case MacroActionType.combination:
      return l10n.actionCombination;
    case MacroActionType.mediaPlayPause:
      return l10n.actionMediaPlayPause;
    case MacroActionType.volumeUp:
      return l10n.actionVolumeUp;
    case MacroActionType.volumeDown:
      return l10n.actionVolumeDown;
    case MacroActionType.mute:
      return l10n.actionMute;
    case MacroActionType.mediaNext:
      return l10n.actionMediaNext;
    case MacroActionType.mediaPrev:
      return l10n.actionMediaPrev;
    case MacroActionType.taskView:
      return l10n.actionTaskView;
    case MacroActionType.screenshotFull:
      return l10n.actionScreenshotFull;
    case MacroActionType.screenshotWindow:
      return l10n.actionScreenshotWindow;
    case MacroActionType.screenshotWechat:
      return l10n.actionScreenshotWechat;
    case MacroActionType.screenshotSnip:
      return l10n.actionScreenshotSnip;
    case MacroActionType.escape:
      return l10n.actionEscape;
    case MacroActionType.enter:
      return l10n.actionEnter;
    case MacroActionType.copy:
      return l10n.actionCopy;
    case MacroActionType.paste:
      return l10n.actionPaste;
    case MacroActionType.cut:
      return l10n.actionCut;
    case MacroActionType.selectAll:
      return l10n.actionSelectAll;
    case MacroActionType.undo:
      return l10n.actionUndo;
    case MacroActionType.redo:
      return l10n.actionRedo;
    case MacroActionType.find:
      return l10n.actionFind;
    case MacroActionType.save:
      return l10n.actionSave;
    case MacroActionType.closeWindow:
      return l10n.actionCloseWindow;
    case MacroActionType.newTab:
      return l10n.actionNewTab;
    case MacroActionType.prevTab:
      return l10n.actionPrevTab;
    case MacroActionType.nextTab:
      return l10n.actionNextTab;
    case MacroActionType.arrowUp:
      return l10n.actionArrowUp;
    case MacroActionType.arrowDown:
      return l10n.actionArrowDown;
    case MacroActionType.arrowLeft:
      return l10n.actionArrowLeft;
    case MacroActionType.arrowRight:
      return l10n.actionArrowRight;
    case MacroActionType.pageUp:
      return l10n.actionPageUp;
    case MacroActionType.pageDown:
      return l10n.actionPageDown;
    case MacroActionType.home:
      return l10n.actionHome;
    case MacroActionType.end:
      return l10n.actionEnd;
    case MacroActionType.delete:
      return l10n.actionDelete;
    case MacroActionType.backspace:
      return l10n.actionBackspace;
    case MacroActionType.agentAccept:
      return l10n.actionAgentAccept;
    case MacroActionType.agentReject:
      return l10n.actionAgentReject;
    case MacroActionType.agentNewSession:
      return l10n.actionAgentNewSession;
    case MacroActionType.openWeChat:
      return l10n.actionOpenWeChat;
    case MacroActionType.openCursor:
      return l10n.actionOpenCursor;
    case MacroActionType.openCodex:
      return l10n.actionOpenCodex;
    case MacroActionType.openChrome:
      return l10n.actionOpenChrome;
    case MacroActionType.openEdge:
      return l10n.actionOpenEdge;
    case MacroActionType.openNotepad:
      return l10n.actionOpenNotepad;
    case MacroActionType.openExplorer:
      return l10n.actionOpenExplorer;
  }
}

String categoryLabel(AppLocalizations l10n, MacroActionCategory c) {
  switch (c) {
    case MacroActionCategory.basic:
      return l10n.catBasic;
    case MacroActionCategory.editing:
      return l10n.catEditing;
    case MacroActionCategory.media:
      return l10n.catMedia;
    case MacroActionCategory.agent:
      return l10n.catAgent;
    case MacroActionCategory.apps:
      return l10n.catApps;
    case MacroActionCategory.custom:
      return l10n.catCustom;
  }
}

String describeAction(AppLocalizations l10n, MacroAction a) {
  switch (a.type) {
    case MacroActionType.none:
      return l10n.actionNone;
    case MacroActionType.keyShortcut:
      return l10n.descShortcut(a.keys.join('+'));
    case MacroActionType.holdShortcut:
      return l10n.descHold(a.keys.join('+'));
    case MacroActionType.openApp:
      return l10n.descOpen(a.appId);
    case MacroActionType.combination:
      if (a.steps.isEmpty) return l10n.descCombinationEmpty;
      return l10n.descCombination(a.steps.map((s) => describeAction(l10n, s)).join(' → '));
    default:
      return actionLabel(l10n, a.type);
  }
}

String voiceModifierLabel(AppLocalizations l10n, VoiceModifier m) {
  switch (m) {
    case VoiceModifier.none:
      return l10n.modNone;
    case VoiceModifier.fn:
      return l10n.modFn;
    case VoiceModifier.leftControl:
      return l10n.modLeftControl;
    case VoiceModifier.rightControl:
      return l10n.modRightControl;
    case VoiceModifier.leftAlt:
      return l10n.modLeftAlt;
    case VoiceModifier.rightAlt:
      return l10n.modRightAlt;
    case VoiceModifier.leftMeta:
      return l10n.modLeftMeta;
    case VoiceModifier.rightMeta:
      return l10n.modRightMeta;
    case VoiceModifier.ctrlWin:
      return l10n.modCtrlWin;
  }
}

String remoteKeyLabel(AppLocalizations l10n, int id) {
  switch (id) {
    case keyUp:
      return l10n.keyUp;
    case keyDown:
      return l10n.keyDown;
    case keyLeft:
      return l10n.keyLeft;
    case keyRight:
      return l10n.keyRight;
    case keyOk:
      return l10n.keyOk;
    case keyVolUp:
      return l10n.keyVolUp;
    case keyVolDown:
      return l10n.keyVolDown;
    case keyBack:
      return l10n.keyBack;
    case keyHome:
      return l10n.keyHome;
    case keyMenu:
      return l10n.keyMenu;
    case keyF1:
      return l10n.keyF1;
    case keyF2:
      return l10n.keyF2;
    case keyF3:
      return l10n.keyF3;
    case keyF4:
      return l10n.keyF4;
    case keyF5:
      return l10n.keyF5;
    case keyF6:
      return l10n.keyF6;
    case keySqueezeVolDown:
      return l10n.keySqueezeVolDown;
    case keySqueezeVolUp:
      return l10n.keySqueezeVolUp;
    default:
      return 'Key $id';
  }
}

/// Compact pad labels — keep physical layout language-neutral where possible.
String remoteKeyShortLabel(AppLocalizations l10n, int id) {
  switch (id) {
    case keyUp:
      return '↑';
    case keyDown:
      return '↓';
    case keyLeft:
      return '←';
    case keyRight:
      return '→';
    case keyOk:
      return 'OK';
    case keyVolUp:
      return l10n.keyShortVolUp;
    case keyVolDown:
      return l10n.keyShortVolDown;
    case keyBack:
      return 'Back';
    case keyHome:
      return 'Home';
    case keyMenu:
      return 'Menu';
    case keyF1:
      return 'F1';
    case keyF2:
      return 'F2';
    case keyF3:
      return 'F3';
    case keyF4:
      return 'F4';
    case keyF5:
      return 'F5';
    case keyF6:
      return 'F6';
    case keySqueezeVolDown:
      return l10n.keyShortSqueezeVolDown;
    case keySqueezeVolUp:
      return l10n.keyShortSqueezeVolUp;
    default:
      return remoteKeyLabel(l10n, id);
  }
}

/// Supported app locales. Null code = follow system.
class AppLanguage {
  const AppLanguage(this.code, this.locale);

  final String? code;
  final Locale? locale;

  static const system = AppLanguage(null, null);
  static const en = AppLanguage('en', Locale('en'));
  static const zh = AppLanguage('zh', Locale('zh'));
  static const zhTw = AppLanguage('zh_TW', Locale('zh', 'TW'));
  static const ja = AppLanguage('ja', Locale('ja'));
  static const fr = AppLanguage('fr', Locale('fr'));
  static const es = AppLanguage('es', Locale('es'));
  static const ar = AppLanguage('ar', Locale('ar'));

  static const all = [system, en, zh, zhTw, ja, fr, es, ar];

  static AppLanguage fromCode(String? code) {
    if (code == null || code.isEmpty || code == 'system') return system;
    return all.firstWhere((e) => e.code == code, orElse: () => system);
  }

  String displayName(AppLocalizations l10n) {
    switch (code) {
      case null:
        return l10n.languageSystem;
      case 'en':
        return l10n.langEnglish;
      case 'zh':
        return l10n.langSimplifiedChinese;
      case 'zh_TW':
        return l10n.langTraditionalChinese;
      case 'ja':
        return l10n.langJapanese;
      case 'fr':
        return l10n.langFrench;
      case 'es':
        return l10n.langSpanish;
      case 'ar':
        return l10n.langArabic;
      default:
        return code ?? l10n.languageSystem;
    }
  }
}
