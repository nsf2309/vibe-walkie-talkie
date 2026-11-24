import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
    Locale('zh'),
    Locale('zh', 'TW')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'VibeMic'**
  String get appTitle;

  /// No description provided for @navConnection.
  ///
  /// In en, this message translates to:
  /// **'Connection & Voice'**
  String get navConnection;

  /// No description provided for @navMapping.
  ///
  /// In en, this message translates to:
  /// **'Button Mapping'**
  String get navMapping;

  /// No description provided for @navGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get navGeneral;

  /// No description provided for @connectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection & Voice'**
  String get connectionTitle;

  /// No description provided for @connectionHint.
  ///
  /// In en, this message translates to:
  /// **'Hold the side PTT to talk; release to stop. Do not pair VibeMic in Windows Bluetooth settings.'**
  String get connectionHint;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected to VibeMic'**
  String get connected;

  /// No description provided for @notConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get notConnected;

  /// No description provided for @streaming.
  ///
  /// In en, this message translates to:
  /// **'Streaming'**
  String get streaming;

  /// No description provided for @idle.
  ///
  /// In en, this message translates to:
  /// **'Idle'**
  String get idle;

  /// No description provided for @audioFrames.
  ///
  /// In en, this message translates to:
  /// **'Audio frames {count}'**
  String audioFrames(int count);

  /// No description provided for @lastKey.
  ///
  /// In en, this message translates to:
  /// **'Last key: {event}'**
  String lastKey(String event);

  /// No description provided for @scanConnect.
  ///
  /// In en, this message translates to:
  /// **'Scan & connect'**
  String get scanConnect;

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @testTone.
  ///
  /// In en, this message translates to:
  /// **'1s test tone'**
  String get testTone;

  /// No description provided for @softPtt.
  ///
  /// In en, this message translates to:
  /// **'Hold soft PTT'**
  String get softPtt;

  /// No description provided for @softPttActive.
  ///
  /// In en, this message translates to:
  /// **'Soft PTT…'**
  String get softPttActive;

  /// No description provided for @virtualMic.
  ///
  /// In en, this message translates to:
  /// **'Virtual microphone'**
  String get virtualMic;

  /// No description provided for @virtualMicHint.
  ///
  /// In en, this message translates to:
  /// **'The companion writes to the playback device below. In WeChat/IME, choose the matching CABLE Output as microphone.'**
  String get virtualMicHint;

  /// No description provided for @selectLoopback.
  ///
  /// In en, this message translates to:
  /// **'Select CABLE Input / loopback'**
  String get selectLoopback;

  /// No description provided for @refreshDevices.
  ///
  /// In en, this message translates to:
  /// **'Refresh devices'**
  String get refreshDevices;

  /// No description provided for @voiceModifier.
  ///
  /// In en, this message translates to:
  /// **'Voice modifier'**
  String get voiceModifier;

  /// No description provided for @voiceModifierHint.
  ///
  /// In en, this message translates to:
  /// **'Injected while PTT is held to trigger IME voice (WeChat IME default: Ctrl+Win).'**
  String get voiceModifierHint;

  /// No description provided for @gain.
  ///
  /// In en, this message translates to:
  /// **'Gain {value}×'**
  String gain(String value);

  /// No description provided for @deviceCaps.
  ///
  /// In en, this message translates to:
  /// **'Device: protocol v{version} · {rate} Hz · {buttons} keys · touchpad={touchpad}'**
  String deviceCaps(int version, int rate, int buttons, String touchpad);

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'no'**
  String get no;

  /// No description provided for @scanDebug.
  ///
  /// In en, this message translates to:
  /// **'Scan debug'**
  String get scanDebug;

  /// No description provided for @empty.
  ///
  /// In en, this message translates to:
  /// **'(empty)'**
  String get empty;

  /// No description provided for @mappingTitle.
  ///
  /// In en, this message translates to:
  /// **'Button Mapping'**
  String get mappingTitle;

  /// No description provided for @mappingHint.
  ///
  /// In en, this message translates to:
  /// **'Layout: PTT on the left, volume on the right; front F4–F6, D-pad+OK, Home/Back/Menu, F1–F3. Squeeze: hold PTT+volume together; short/long press can bind screenshots and more.'**
  String get mappingHint;

  /// No description provided for @enableMapping.
  ///
  /// In en, this message translates to:
  /// **'Enable button mapping'**
  String get enableMapping;

  /// No description provided for @leftSide.
  ///
  /// In en, this message translates to:
  /// **'Left side'**
  String get leftSide;

  /// No description provided for @rightSide.
  ///
  /// In en, this message translates to:
  /// **'Right side'**
  String get rightSide;

  /// No description provided for @pttVoice.
  ///
  /// In en, this message translates to:
  /// **'PTT'**
  String get pttVoice;

  /// No description provided for @liveEvent.
  ///
  /// In en, this message translates to:
  /// **'Live: {event}'**
  String liveEvent(String event);

  /// No description provided for @keyId.
  ///
  /// In en, this message translates to:
  /// **'ID {id}'**
  String keyId(int id);

  /// No description provided for @squeezeHint.
  ///
  /// In en, this message translates to:
  /// **'Squeeze: hold left PTT with the matching volume key. Short press fires Click; hold ≥0.6s fires Long. Voice streaming is skipped during squeeze.'**
  String get squeezeHint;

  /// No description provided for @actionHold.
  ///
  /// In en, this message translates to:
  /// **'Hold (recommended for arrows)'**
  String get actionHold;

  /// No description provided for @actionClick.
  ///
  /// In en, this message translates to:
  /// **'Click'**
  String get actionClick;

  /// No description provided for @actionDouble.
  ///
  /// In en, this message translates to:
  /// **'Double'**
  String get actionDouble;

  /// No description provided for @actionLong.
  ///
  /// In en, this message translates to:
  /// **'Long press'**
  String get actionLong;

  /// No description provided for @actionSqueezeShort.
  ///
  /// In en, this message translates to:
  /// **'Short squeeze'**
  String get actionSqueezeShort;

  /// No description provided for @actionSqueezeLong.
  ///
  /// In en, this message translates to:
  /// **'Long squeeze'**
  String get actionSqueezeLong;

  /// No description provided for @resetDefaults.
  ///
  /// In en, this message translates to:
  /// **'Restore defaults'**
  String get resetDefaults;

  /// No description provided for @generalTitle.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get generalTitle;

  /// No description provided for @generalHint.
  ///
  /// In en, this message translates to:
  /// **'Local preferences for connection, buttons, and settings. Advanced features can be added later.'**
  String get generalHint;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @autoScan.
  ///
  /// In en, this message translates to:
  /// **'Scan on launch'**
  String get autoScan;

  /// No description provided for @autoScanSub.
  ///
  /// In en, this message translates to:
  /// **'Automatically look for VibeMic when the companion starts'**
  String get autoScanSub;

  /// No description provided for @autoReconnect.
  ///
  /// In en, this message translates to:
  /// **'Auto-reconnect'**
  String get autoReconnect;

  /// No description provided for @autoReconnectSub.
  ///
  /// In en, this message translates to:
  /// **'Rescan about 3 seconds after an unexpected disconnect'**
  String get autoReconnectSub;

  /// No description provided for @showScanDebug.
  ///
  /// In en, this message translates to:
  /// **'Show scan debug'**
  String get showScanDebug;

  /// No description provided for @showScanDebugSub.
  ///
  /// In en, this message translates to:
  /// **'List nearby BLE ads on the Connection page'**
  String get showScanDebugSub;

  /// No description provided for @tipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tipsTitle;

  /// No description provided for @tip1.
  ///
  /// In en, this message translates to:
  /// **'1. Install VB-Audio Virtual Cable; pick CABLE Input here and CABLE Output in your IME.'**
  String get tip1;

  /// No description provided for @tip2.
  ///
  /// In en, this message translates to:
  /// **'2. Do not connect VibeMic in Windows Bluetooth settings—only scan in this app.'**
  String get tip2;

  /// No description provided for @tip3.
  ///
  /// In en, this message translates to:
  /// **'3. INMP441 wiring: docs/mic-inmp441.md. Without the mic, PTT plays a test tone.'**
  String get tip3;

  /// No description provided for @tip4.
  ///
  /// In en, this message translates to:
  /// **'4. Key matrix wiring: docs/keys-matrix.md.'**
  String get tip4;

  /// No description provided for @tip5.
  ///
  /// In en, this message translates to:
  /// **'5. Multitasking: Menu → Win+Tab, hold ←/→ to switch, OK to confirm; F1/F2/F3 = agent accept/reject/new session.'**
  String get tip5;

  /// No description provided for @tip6.
  ///
  /// In en, this message translates to:
  /// **'6. Squeeze: PTT+Vol− short = full screenshot / long = WeChat snip; PTT+Vol+ short = window / long = Snipping Tool.'**
  String get tip6;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'VibeMic companion 0.1.0 · ESP32-C3 custom BLE audio + HID keys'**
  String get aboutBody;

  /// No description provided for @editAction.
  ///
  /// In en, this message translates to:
  /// **'Edit action'**
  String get editAction;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @customShortcutHint.
  ///
  /// In en, this message translates to:
  /// **'Shortcut (e.g. control+c or alt+f4)'**
  String get customShortcutHint;

  /// No description provided for @customAppHint.
  ///
  /// In en, this message translates to:
  /// **'App id or exe (e.g. wechat / chrome / notepad)'**
  String get customAppHint;

  /// No description provided for @catBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic keys'**
  String get catBasic;

  /// No description provided for @catEditing.
  ///
  /// In en, this message translates to:
  /// **'Editing'**
  String get catEditing;

  /// No description provided for @catMedia.
  ///
  /// In en, this message translates to:
  /// **'System & media'**
  String get catMedia;

  /// No description provided for @catAgent.
  ///
  /// In en, this message translates to:
  /// **'Cursor / Codex'**
  String get catAgent;

  /// No description provided for @catApps.
  ///
  /// In en, this message translates to:
  /// **'Open apps'**
  String get catApps;

  /// No description provided for @catCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get catCustom;

  /// No description provided for @actionNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get actionNone;

  /// No description provided for @actionKeyShortcut.
  ///
  /// In en, this message translates to:
  /// **'Custom shortcut'**
  String get actionKeyShortcut;

  /// No description provided for @actionHoldShortcut.
  ///
  /// In en, this message translates to:
  /// **'Hold shortcut'**
  String get actionHoldShortcut;

  /// No description provided for @actionOpenApp.
  ///
  /// In en, this message translates to:
  /// **'Open app…'**
  String get actionOpenApp;

  /// No description provided for @actionCombination.
  ///
  /// In en, this message translates to:
  /// **'Combination'**
  String get actionCombination;

  /// No description provided for @actionMediaPlayPause.
  ///
  /// In en, this message translates to:
  /// **'Play/Pause'**
  String get actionMediaPlayPause;

  /// No description provided for @actionVolumeUp.
  ///
  /// In en, this message translates to:
  /// **'Volume +'**
  String get actionVolumeUp;

  /// No description provided for @actionVolumeDown.
  ///
  /// In en, this message translates to:
  /// **'Volume −'**
  String get actionVolumeDown;

  /// No description provided for @actionMute.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get actionMute;

  /// No description provided for @actionMediaNext.
  ///
  /// In en, this message translates to:
  /// **'Next track'**
  String get actionMediaNext;

  /// No description provided for @actionMediaPrev.
  ///
  /// In en, this message translates to:
  /// **'Previous track'**
  String get actionMediaPrev;

  /// No description provided for @actionTaskView.
  ///
  /// In en, this message translates to:
  /// **'Task view (Win+Tab)'**
  String get actionTaskView;

  /// No description provided for @actionScreenshotFull.
  ///
  /// In en, this message translates to:
  /// **'Full-screen screenshot (PrtSc)'**
  String get actionScreenshotFull;

  /// No description provided for @actionScreenshotWindow.
  ///
  /// In en, this message translates to:
  /// **'Active window screenshot (Alt+PrtSc)'**
  String get actionScreenshotWindow;

  /// No description provided for @actionScreenshotWechat.
  ///
  /// In en, this message translates to:
  /// **'WeChat screenshot (Alt+A)'**
  String get actionScreenshotWechat;

  /// No description provided for @actionScreenshotSnip.
  ///
  /// In en, this message translates to:
  /// **'Snipping Tool (Win+Shift+S)'**
  String get actionScreenshotSnip;

  /// No description provided for @actionEscape.
  ///
  /// In en, this message translates to:
  /// **'Esc'**
  String get actionEscape;

  /// No description provided for @actionEnter.
  ///
  /// In en, this message translates to:
  /// **'Enter / OK'**
  String get actionEnter;

  /// No description provided for @actionCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get actionCopy;

  /// No description provided for @actionPaste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get actionPaste;

  /// No description provided for @actionCut.
  ///
  /// In en, this message translates to:
  /// **'Cut'**
  String get actionCut;

  /// No description provided for @actionSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get actionSelectAll;

  /// No description provided for @actionUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get actionUndo;

  /// No description provided for @actionRedo.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get actionRedo;

  /// No description provided for @actionFind.
  ///
  /// In en, this message translates to:
  /// **'Find'**
  String get actionFind;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionCloseWindow.
  ///
  /// In en, this message translates to:
  /// **'Close window'**
  String get actionCloseWindow;

  /// No description provided for @actionNewTab.
  ///
  /// In en, this message translates to:
  /// **'New tab'**
  String get actionNewTab;

  /// No description provided for @actionPrevTab.
  ///
  /// In en, this message translates to:
  /// **'Previous tab'**
  String get actionPrevTab;

  /// No description provided for @actionNextTab.
  ///
  /// In en, this message translates to:
  /// **'Next tab'**
  String get actionNextTab;

  /// No description provided for @actionArrowUp.
  ///
  /// In en, this message translates to:
  /// **'↑ (holdable)'**
  String get actionArrowUp;

  /// No description provided for @actionArrowDown.
  ///
  /// In en, this message translates to:
  /// **'↓ (holdable)'**
  String get actionArrowDown;

  /// No description provided for @actionArrowLeft.
  ///
  /// In en, this message translates to:
  /// **'← (holdable)'**
  String get actionArrowLeft;

  /// No description provided for @actionArrowRight.
  ///
  /// In en, this message translates to:
  /// **'→ (holdable)'**
  String get actionArrowRight;

  /// No description provided for @actionPageUp.
  ///
  /// In en, this message translates to:
  /// **'Page Up'**
  String get actionPageUp;

  /// No description provided for @actionPageDown.
  ///
  /// In en, this message translates to:
  /// **'Page Down'**
  String get actionPageDown;

  /// No description provided for @actionHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get actionHome;

  /// No description provided for @actionEnd.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get actionEnd;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionBackspace.
  ///
  /// In en, this message translates to:
  /// **'Backspace'**
  String get actionBackspace;

  /// No description provided for @actionAgentAccept.
  ///
  /// In en, this message translates to:
  /// **'Agent accept (Ctrl+Enter)'**
  String get actionAgentAccept;

  /// No description provided for @actionAgentReject.
  ///
  /// In en, this message translates to:
  /// **'Agent reject (Esc)'**
  String get actionAgentReject;

  /// No description provided for @actionAgentNewSession.
  ///
  /// In en, this message translates to:
  /// **'Agent new session (Ctrl+L)'**
  String get actionAgentNewSession;

  /// No description provided for @actionOpenWeChat.
  ///
  /// In en, this message translates to:
  /// **'Open WeChat'**
  String get actionOpenWeChat;

  /// No description provided for @actionOpenCursor.
  ///
  /// In en, this message translates to:
  /// **'Open Cursor'**
  String get actionOpenCursor;

  /// No description provided for @actionOpenCodex.
  ///
  /// In en, this message translates to:
  /// **'Open Codex / ChatGPT'**
  String get actionOpenCodex;

  /// No description provided for @actionOpenChrome.
  ///
  /// In en, this message translates to:
  /// **'Open Chrome'**
  String get actionOpenChrome;

  /// No description provided for @actionOpenEdge.
  ///
  /// In en, this message translates to:
  /// **'Open Edge'**
  String get actionOpenEdge;

  /// No description provided for @actionOpenNotepad.
  ///
  /// In en, this message translates to:
  /// **'Open Notepad'**
  String get actionOpenNotepad;

  /// No description provided for @actionOpenExplorer.
  ///
  /// In en, this message translates to:
  /// **'Open File Explorer'**
  String get actionOpenExplorer;

  /// No description provided for @descShortcut.
  ///
  /// In en, this message translates to:
  /// **'Shortcut: {keys}'**
  String descShortcut(String keys);

  /// No description provided for @descHold.
  ///
  /// In en, this message translates to:
  /// **'Hold: {keys}'**
  String descHold(String keys);

  /// No description provided for @descOpen.
  ///
  /// In en, this message translates to:
  /// **'Open: {app}'**
  String descOpen(String app);

  /// No description provided for @descCombinationEmpty.
  ///
  /// In en, this message translates to:
  /// **'Combination (empty)'**
  String get descCombinationEmpty;

  /// No description provided for @descCombination.
  ///
  /// In en, this message translates to:
  /// **'Combo: {steps}'**
  String descCombination(String steps);

  /// No description provided for @modNone.
  ///
  /// In en, this message translates to:
  /// **'None (virtual mic only)'**
  String get modNone;

  /// No description provided for @modFn.
  ///
  /// In en, this message translates to:
  /// **'Fn / Globe (macOS)'**
  String get modFn;

  /// No description provided for @modLeftControl.
  ///
  /// In en, this message translates to:
  /// **'Left Ctrl'**
  String get modLeftControl;

  /// No description provided for @modRightControl.
  ///
  /// In en, this message translates to:
  /// **'Right Ctrl'**
  String get modRightControl;

  /// No description provided for @modLeftAlt.
  ///
  /// In en, this message translates to:
  /// **'Left Alt'**
  String get modLeftAlt;

  /// No description provided for @modRightAlt.
  ///
  /// In en, this message translates to:
  /// **'Right Alt'**
  String get modRightAlt;

  /// No description provided for @modLeftMeta.
  ///
  /// In en, this message translates to:
  /// **'Win / Cmd'**
  String get modLeftMeta;

  /// No description provided for @modRightMeta.
  ///
  /// In en, this message translates to:
  /// **'Right Win / Cmd'**
  String get modRightMeta;

  /// No description provided for @modCtrlWin.
  ///
  /// In en, this message translates to:
  /// **'Ctrl + Win (WeChat IME)'**
  String get modCtrlWin;

  /// No description provided for @keyUp.
  ///
  /// In en, this message translates to:
  /// **'Up'**
  String get keyUp;

  /// No description provided for @keyDown.
  ///
  /// In en, this message translates to:
  /// **'Down'**
  String get keyDown;

  /// No description provided for @keyLeft.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get keyLeft;

  /// No description provided for @keyRight.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get keyRight;

  /// No description provided for @keyOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get keyOk;

  /// No description provided for @keyVolUp.
  ///
  /// In en, this message translates to:
  /// **'Volume +'**
  String get keyVolUp;

  /// No description provided for @keyVolDown.
  ///
  /// In en, this message translates to:
  /// **'Volume −'**
  String get keyVolDown;

  /// No description provided for @keyBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get keyBack;

  /// No description provided for @keyHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get keyHome;

  /// No description provided for @keyMenu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get keyMenu;

  /// No description provided for @keyF1.
  ///
  /// In en, this message translates to:
  /// **'F1'**
  String get keyF1;

  /// No description provided for @keyF2.
  ///
  /// In en, this message translates to:
  /// **'F2'**
  String get keyF2;

  /// No description provided for @keyF3.
  ///
  /// In en, this message translates to:
  /// **'F3'**
  String get keyF3;

  /// No description provided for @keyF4.
  ///
  /// In en, this message translates to:
  /// **'F4'**
  String get keyF4;

  /// No description provided for @keyF5.
  ///
  /// In en, this message translates to:
  /// **'F5'**
  String get keyF5;

  /// No description provided for @keyF6.
  ///
  /// In en, this message translates to:
  /// **'F6'**
  String get keyF6;

  /// No description provided for @keySqueezeVolDown.
  ///
  /// In en, this message translates to:
  /// **'Squeeze PTT+Vol−'**
  String get keySqueezeVolDown;

  /// No description provided for @keySqueezeVolUp.
  ///
  /// In en, this message translates to:
  /// **'Squeeze PTT+Vol+'**
  String get keySqueezeVolUp;

  /// No description provided for @keyShortVolUp.
  ///
  /// In en, this message translates to:
  /// **'Vol+'**
  String get keyShortVolUp;

  /// No description provided for @keyShortVolDown.
  ///
  /// In en, this message translates to:
  /// **'Vol−'**
  String get keyShortVolDown;

  /// No description provided for @keyShortSqueezeVolUp.
  ///
  /// In en, this message translates to:
  /// **'⊕+'**
  String get keyShortSqueezeVolUp;

  /// No description provided for @keyShortSqueezeVolDown.
  ///
  /// In en, this message translates to:
  /// **'⊕−'**
  String get keyShortSqueezeVolDown;

  /// No description provided for @statusIdle.
  ///
  /// In en, this message translates to:
  /// **'Idle'**
  String get statusIdle;

  /// No description provided for @statusCheckingBluetooth.
  ///
  /// In en, this message translates to:
  /// **'Checking Bluetooth…'**
  String get statusCheckingBluetooth;

  /// No description provided for @statusUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth not supported on this PC'**
  String get statusUnsupported;

  /// No description provided for @statusKnownConnecting.
  ///
  /// In en, this message translates to:
  /// **'Known device found, connecting…'**
  String get statusKnownConnecting;

  /// No description provided for @statusScanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning {seconds}s…'**
  String statusScanning(int seconds);

  /// No description provided for @statusScanningSeen.
  ///
  /// In en, this message translates to:
  /// **'Scanning… seen {count} device(s)'**
  String statusScanningSeen(int count);

  /// No description provided for @statusNoDevices.
  ///
  /// In en, this message translates to:
  /// **'Found 0 devices. Check Windows Bluetooth, or confirm the board is advertising with nRF Connect.'**
  String get statusNoDevices;

  /// No description provided for @statusNotFound.
  ///
  /// In en, this message translates to:
  /// **'VibeMic not found in {count} ads. Sample: {sample}'**
  String statusNotFound(int count, String sample);

  /// No description provided for @statusFoundConnecting.
  ///
  /// In en, this message translates to:
  /// **'Found VibeMic, connecting…'**
  String get statusFoundConnecting;

  /// No description provided for @statusAdapterTimeout.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth adapter timed out'**
  String get statusAdapterTimeout;

  /// No description provided for @statusScanFailed.
  ///
  /// In en, this message translates to:
  /// **'Scan failed: {error}'**
  String statusScanFailed(String error);

  /// No description provided for @statusConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting to {name}…'**
  String statusConnecting(String name);

  /// No description provided for @statusConnectFailed.
  ///
  /// In en, this message translates to:
  /// **'Connect failed: {error} — unpair in Windows, press RST, then retry'**
  String statusConnectFailed(String error);

  /// No description provided for @statusDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get statusDisconnected;

  /// No description provided for @statusMissingGatt.
  ///
  /// In en, this message translates to:
  /// **'Missing VibeMic GATT characteristics'**
  String get statusMissingGatt;

  /// No description provided for @statusConnectedReady.
  ///
  /// In en, this message translates to:
  /// **'Connected — hold PTT to talk'**
  String get statusConnectedReady;

  /// No description provided for @statusReconnecting.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting…'**
  String get statusReconnecting;

  /// No description provided for @statusNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get statusNotConnected;

  /// No description provided for @statusTestTone.
  ///
  /// In en, this message translates to:
  /// **'Test tone {ms}ms…'**
  String statusTestTone(int ms);

  /// No description provided for @statusDeviceNack.
  ///
  /// In en, this message translates to:
  /// **'Device NACK'**
  String get statusDeviceNack;

  /// No description provided for @statusPttStreaming.
  ///
  /// In en, this message translates to:
  /// **'PTT streaming…'**
  String get statusPttStreaming;

  /// No description provided for @btnEventUp.
  ///
  /// In en, this message translates to:
  /// **'up'**
  String get btnEventUp;

  /// No description provided for @btnEventDown.
  ///
  /// In en, this message translates to:
  /// **'down'**
  String get btnEventDown;

  /// No description provided for @btnEventClick.
  ///
  /// In en, this message translates to:
  /// **'click'**
  String get btnEventClick;

  /// No description provided for @btnEventDouble.
  ///
  /// In en, this message translates to:
  /// **'double'**
  String get btnEventDouble;

  /// No description provided for @btnEventLong.
  ///
  /// In en, this message translates to:
  /// **'long'**
  String get btnEventLong;

  /// No description provided for @lastKeyDetail.
  ///
  /// In en, this message translates to:
  /// **'Key {id} · {event}'**
  String lastKeyDetail(int id, String event);

  /// No description provided for @langEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @langSimplifiedChinese.
  ///
  /// In en, this message translates to:
  /// **'简体中文'**
  String get langSimplifiedChinese;

  /// No description provided for @langTraditionalChinese.
  ///
  /// In en, this message translates to:
  /// **'繁體中文'**
  String get langTraditionalChinese;

  /// No description provided for @langJapanese.
  ///
  /// In en, this message translates to:
  /// **'日本語'**
  String get langJapanese;

  /// No description provided for @langFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get langFrench;

  /// No description provided for @langSpanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get langSpanish;

  /// No description provided for @langArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get langArabic;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'en',
        'es',
        'fr',
        'ja',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
