// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'VibeMic';

  @override
  String get navConnection => 'Connection & Voice';

  @override
  String get navMapping => 'Button Mapping';

  @override
  String get navGeneral => 'General';

  @override
  String get connectionTitle => 'Connection & Voice';

  @override
  String get connectionHint =>
      'Hold the side PTT to talk; release to stop. Do not pair VibeMic in Windows Bluetooth settings.';

  @override
  String get connected => 'Connected to VibeMic';

  @override
  String get notConnected => 'Not connected';

  @override
  String get streaming => 'Streaming';

  @override
  String get idle => 'Idle';

  @override
  String audioFrames(int count) {
    return 'Audio frames $count';
  }

  @override
  String lastKey(String event) {
    return 'Last key: $event';
  }

  @override
  String get scanConnect => 'Scan & connect';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get testTone => '1s test tone';

  @override
  String get softPtt => 'Hold soft PTT';

  @override
  String get softPttActive => 'Soft PTT…';

  @override
  String get virtualMic => 'Virtual microphone';

  @override
  String get virtualMicHint =>
      'The companion writes to the playback device below. In WeChat/IME, choose the matching CABLE Output as microphone.';

  @override
  String get selectLoopback => 'Select CABLE Input / loopback';

  @override
  String get refreshDevices => 'Refresh devices';

  @override
  String get voiceModifier => 'Voice modifier';

  @override
  String get voiceModifierHint =>
      'Injected while PTT is held to trigger IME voice (WeChat IME default: Ctrl+Win).';

  @override
  String gain(String value) {
    return 'Gain $value×';
  }

  @override
  String deviceCaps(int version, int rate, int buttons, String touchpad) {
    return 'Device: protocol v$version · $rate Hz · $buttons keys · touchpad=$touchpad';
  }

  @override
  String get yes => 'yes';

  @override
  String get no => 'no';

  @override
  String get scanDebug => 'Scan debug';

  @override
  String get empty => '(empty)';

  @override
  String get mappingTitle => 'Button Mapping';

  @override
  String get mappingHint =>
      'Layout: PTT on the left, volume on the right; front F4–F6, D-pad+OK, Home/Back/Menu, F1–F3. Squeeze: hold PTT+volume together; short/long press can bind screenshots and more.';

  @override
  String get enableMapping => 'Enable button mapping';

  @override
  String get leftSide => 'Left side';

  @override
  String get rightSide => 'Right side';

  @override
  String get pttVoice => 'PTT';

  @override
  String liveEvent(String event) {
    return 'Live: $event';
  }

  @override
  String keyId(int id) {
    return 'ID $id';
  }

  @override
  String get squeezeHint =>
      'Squeeze: hold left PTT with the matching volume key. Short press fires Click; hold ≥0.6s fires Long. Voice streaming is skipped during squeeze.';

  @override
  String get actionHold => 'Hold (recommended for arrows)';

  @override
  String get actionClick => 'Click';

  @override
  String get actionDouble => 'Double';

  @override
  String get actionLong => 'Long press';

  @override
  String get actionSqueezeShort => 'Short squeeze';

  @override
  String get actionSqueezeLong => 'Long squeeze';

  @override
  String get resetDefaults => 'Restore defaults';

  @override
  String get generalTitle => 'General';

  @override
  String get generalHint =>
      'Local preferences for connection, buttons, and settings. Advanced features can be added later.';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get autoScan => 'Scan on launch';

  @override
  String get autoScanSub =>
      'Automatically look for VibeMic when the companion starts';

  @override
  String get autoReconnect => 'Auto-reconnect';

  @override
  String get autoReconnectSub =>
      'Rescan about 3 seconds after an unexpected disconnect';

  @override
  String get showScanDebug => 'Show scan debug';

  @override
  String get showScanDebugSub => 'List nearby BLE ads on the Connection page';

  @override
  String get tipsTitle => 'Tips';

  @override
  String get tip1 =>
      '1. Install VB-Audio Virtual Cable; pick CABLE Input here and CABLE Output in your IME.';

  @override
  String get tip2 =>
      '2. Do not connect VibeMic in Windows Bluetooth settings—only scan in this app.';

  @override
  String get tip3 =>
      '3. INMP441 wiring: docs/mic-inmp441.md. Without the mic, PTT plays a test tone.';

  @override
  String get tip4 => '4. Key matrix wiring: docs/keys-matrix.md.';

  @override
  String get tip5 =>
      '5. Multitasking: Menu → Win+Tab, hold ←/→ to switch, OK to confirm; F1/F2/F3 = agent accept/reject/new session.';

  @override
  String get tip6 =>
      '6. Squeeze: PTT+Vol− short = full screenshot / long = WeChat snip; PTT+Vol+ short = window / long = Snipping Tool.';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutBody =>
      'VibeMic companion 0.1.0 · ESP32-C3 custom BLE audio + HID keys';

  @override
  String get editAction => 'Edit action';

  @override
  String get clear => 'Clear';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get customShortcutHint => 'Shortcut (e.g. control+c or alt+f4)';

  @override
  String get customAppHint => 'App id or exe (e.g. wechat / chrome / notepad)';

  @override
  String get catBasic => 'Basic keys';

  @override
  String get catEditing => 'Editing';

  @override
  String get catMedia => 'System & media';

  @override
  String get catAgent => 'Cursor / Codex';

  @override
  String get catApps => 'Open apps';

  @override
  String get catCustom => 'Custom';

  @override
  String get actionNone => 'None';

  @override
  String get actionKeyShortcut => 'Custom shortcut';

  @override
  String get actionHoldShortcut => 'Hold shortcut';

  @override
  String get actionOpenApp => 'Open app…';

  @override
  String get actionCombination => 'Combination';

  @override
  String get actionMediaPlayPause => 'Play/Pause';

  @override
  String get actionVolumeUp => 'Volume +';

  @override
  String get actionVolumeDown => 'Volume −';

  @override
  String get actionMute => 'Mute';

  @override
  String get actionMediaNext => 'Next track';

  @override
  String get actionMediaPrev => 'Previous track';

  @override
  String get actionTaskView => 'Task view (Win+Tab)';

  @override
  String get actionScreenshotFull => 'Full-screen screenshot (PrtSc)';

  @override
  String get actionScreenshotWindow => 'Active window screenshot (Alt+PrtSc)';

  @override
  String get actionScreenshotWechat => 'WeChat screenshot (Alt+A)';

  @override
  String get actionScreenshotSnip => 'Snipping Tool (Win+Shift+S)';

  @override
  String get actionEscape => 'Esc';

  @override
  String get actionEnter => 'Enter / OK';

  @override
  String get actionCopy => 'Copy';

  @override
  String get actionPaste => 'Paste';

  @override
  String get actionCut => 'Cut';

  @override
  String get actionSelectAll => 'Select all';

  @override
  String get actionUndo => 'Undo';

  @override
  String get actionRedo => 'Redo';

  @override
  String get actionFind => 'Find';

  @override
  String get actionSave => 'Save';

  @override
  String get actionCloseWindow => 'Close window';

  @override
  String get actionNewTab => 'New tab';

  @override
  String get actionPrevTab => 'Previous tab';

  @override
  String get actionNextTab => 'Next tab';

  @override
  String get actionArrowUp => '↑ (holdable)';

  @override
  String get actionArrowDown => '↓ (holdable)';

  @override
  String get actionArrowLeft => '← (holdable)';

  @override
  String get actionArrowRight => '→ (holdable)';

  @override
  String get actionPageUp => 'Page Up';

  @override
  String get actionPageDown => 'Page Down';

  @override
  String get actionHome => 'Home';

  @override
  String get actionEnd => 'End';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionBackspace => 'Backspace';

  @override
  String get actionAgentAccept => 'Agent accept (Ctrl+Enter)';

  @override
  String get actionAgentReject => 'Agent reject (Esc)';

  @override
  String get actionAgentNewSession => 'Agent new session (Ctrl+L)';

  @override
  String get actionOpenWeChat => 'Open WeChat';

  @override
  String get actionOpenCursor => 'Open Cursor';

  @override
  String get actionOpenCodex => 'Open Codex / ChatGPT';

  @override
  String get actionOpenChrome => 'Open Chrome';

  @override
  String get actionOpenEdge => 'Open Edge';

  @override
  String get actionOpenNotepad => 'Open Notepad';

  @override
  String get actionOpenExplorer => 'Open File Explorer';

  @override
  String descShortcut(String keys) {
    return 'Shortcut: $keys';
  }

  @override
  String descHold(String keys) {
    return 'Hold: $keys';
  }

  @override
  String descOpen(String app) {
    return 'Open: $app';
  }

  @override
  String get descCombinationEmpty => 'Combination (empty)';

  @override
  String descCombination(String steps) {
    return 'Combo: $steps';
  }

  @override
  String get modNone => 'None (virtual mic only)';

  @override
  String get modFn => 'Fn / Globe (macOS)';

  @override
  String get modLeftControl => 'Left Ctrl';

  @override
  String get modRightControl => 'Right Ctrl';

  @override
  String get modLeftAlt => 'Left Alt';

  @override
  String get modRightAlt => 'Right Alt';

  @override
  String get modLeftMeta => 'Win / Cmd';

  @override
  String get modRightMeta => 'Right Win / Cmd';

  @override
  String get modCtrlWin => 'Ctrl + Win (WeChat IME)';

  @override
  String get keyUp => 'Up';

  @override
  String get keyDown => 'Down';

  @override
  String get keyLeft => 'Left';

  @override
  String get keyRight => 'Right';

  @override
  String get keyOk => 'OK';

  @override
  String get keyVolUp => 'Volume +';

  @override
  String get keyVolDown => 'Volume −';

  @override
  String get keyBack => 'Back';

  @override
  String get keyHome => 'Home';

  @override
  String get keyMenu => 'Menu';

  @override
  String get keyF1 => 'F1';

  @override
  String get keyF2 => 'F2';

  @override
  String get keyF3 => 'F3';

  @override
  String get keyF4 => 'F4';

  @override
  String get keyF5 => 'F5';

  @override
  String get keyF6 => 'F6';

  @override
  String get keySqueezeVolDown => 'Squeeze PTT+Vol−';

  @override
  String get keySqueezeVolUp => 'Squeeze PTT+Vol+';

  @override
  String get keyShortVolUp => 'Vol+';

  @override
  String get keyShortVolDown => 'Vol−';

  @override
  String get keyShortSqueezeVolUp => '⊕+';

  @override
  String get keyShortSqueezeVolDown => '⊕−';

  @override
  String get statusIdle => 'Idle';

  @override
  String get statusCheckingBluetooth => 'Checking Bluetooth…';

  @override
  String get statusUnsupported => 'Bluetooth not supported on this PC';

  @override
  String get statusKnownConnecting => 'Known device found, connecting…';

  @override
  String statusScanning(int seconds) {
    return 'Scanning ${seconds}s…';
  }

  @override
  String statusScanningSeen(int count) {
    return 'Scanning… seen $count device(s)';
  }

  @override
  String get statusNoDevices =>
      'Found 0 devices. Check Windows Bluetooth, or confirm the board is advertising with nRF Connect.';

  @override
  String statusNotFound(int count, String sample) {
    return 'VibeMic not found in $count ads. Sample: $sample';
  }

  @override
  String get statusFoundConnecting => 'Found VibeMic, connecting…';

  @override
  String get statusAdapterTimeout => 'Bluetooth adapter timed out';

  @override
  String statusScanFailed(String error) {
    return 'Scan failed: $error';
  }

  @override
  String statusConnecting(String name) {
    return 'Connecting to $name…';
  }

  @override
  String statusConnectFailed(String error) {
    return 'Connect failed: $error — unpair in Windows, press RST, then retry';
  }

  @override
  String get statusDisconnected => 'Disconnected';

  @override
  String get statusMissingGatt => 'Missing VibeMic GATT characteristics';

  @override
  String get statusConnectedReady => 'Connected — hold PTT to talk';

  @override
  String get statusReconnecting => 'Reconnecting…';

  @override
  String get statusNotConnected => 'Not connected';

  @override
  String statusTestTone(int ms) {
    return 'Test tone ${ms}ms…';
  }

  @override
  String get statusDeviceNack => 'Device NACK';

  @override
  String get statusPttStreaming => 'PTT streaming…';

  @override
  String get btnEventUp => 'up';

  @override
  String get btnEventDown => 'down';

  @override
  String get btnEventClick => 'click';

  @override
  String get btnEventDouble => 'double';

  @override
  String get btnEventLong => 'long';

  @override
  String lastKeyDetail(int id, String event) {
    return 'Key $id · $event';
  }

  @override
  String get langEnglish => 'English';

  @override
  String get langSimplifiedChinese => '简体中文';

  @override
  String get langTraditionalChinese => '繁體中文';

  @override
  String get langJapanese => '日本語';

  @override
  String get langFrench => 'Français';

  @override
  String get langSpanish => 'Español';

  @override
  String get langArabic => 'العربية';
}
