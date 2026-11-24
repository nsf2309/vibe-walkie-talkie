// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'VibeMic';

  @override
  String get navConnection => '接続と音声';

  @override
  String get navMapping => 'ボタン割り当て';

  @override
  String get navGeneral => '一般';

  @override
  String get connectionTitle => '接続と音声';

  @override
  String get connectionHint =>
      '側面の PTT を押して話し、離すと停止します。Windows の Bluetooth 設定で VibeMic をペアリングしないでください。';

  @override
  String get connected => 'VibeMic に接続済み';

  @override
  String get notConnected => '未接続';

  @override
  String get streaming => '配信中';

  @override
  String get idle => '待機';

  @override
  String audioFrames(int count) {
    return '音声フレーム $count';
  }

  @override
  String lastKey(String event) {
    return '直前のキー: $event';
  }

  @override
  String get scanConnect => 'スキャンして接続';

  @override
  String get disconnect => '切断';

  @override
  String get testTone => '1秒テスト音';

  @override
  String get softPtt => 'ソフト PTT を長押し';

  @override
  String get softPttActive => 'ソフト PTT…';

  @override
  String get virtualMic => '仮想マイク';

  @override
  String get virtualMicHint =>
      'コンパニオンは下の再生デバイスへ書き込みます。IME では対応する CABLE Output をマイクに選んでください。';

  @override
  String get selectLoopback => 'CABLE Input / ループバックを選択';

  @override
  String get refreshDevices => 'デバイスを更新';

  @override
  String get voiceModifier => '音声修飾キー';

  @override
  String get voiceModifierHint =>
      'PTT 押下中に注入し、IME の音声入力を起動します（WeChat IME 既定: Ctrl+Win）。';

  @override
  String gain(String value) {
    return 'ゲイン $value×';
  }

  @override
  String deviceCaps(int version, int rate, int buttons, String touchpad) {
    return 'デバイス: プロトコル v$version · $rate Hz · $buttons キー · タッチパッド=$touchpad';
  }

  @override
  String get yes => 'あり';

  @override
  String get no => 'なし';

  @override
  String get scanDebug => 'スキャンデバッグ';

  @override
  String get empty => '（なし）';

  @override
  String get mappingTitle => 'ボタン割り当て';

  @override
  String get mappingHint =>
      '配置: 左 PTT、右音量。前面は F4–F6、十字+OK、Home/戻る/メニュー、F1–F3。スクイーズ: PTT+音量の同時押し。短押し/長押しでスクリーンショット等を割り当て可能。';

  @override
  String get enableMapping => 'ボタン割り当てを有効化';

  @override
  String get leftSide => '左側面';

  @override
  String get rightSide => '右側面';

  @override
  String get pttVoice => 'PTT';

  @override
  String liveEvent(String event) {
    return 'リアルタイム: $event';
  }

  @override
  String keyId(int id) {
    return 'ID $id';
  }

  @override
  String get squeezeHint =>
      'スクイーズ: 左 PTT と右の該当音量キーを同時押し。短押しはクリック、0.6秒以上は長押し。この間は音声配信しません。';

  @override
  String get actionHold => '長押し保持（矢印推奨）';

  @override
  String get actionClick => 'クリック';

  @override
  String get actionDouble => 'ダブル';

  @override
  String get actionLong => '長押し';

  @override
  String get actionSqueezeShort => '短押しスクイーズ';

  @override
  String get actionSqueezeLong => '長押しスクイーズ';

  @override
  String get resetDefaults => '既定に戻す';

  @override
  String get generalTitle => '一般';

  @override
  String get generalHint => '接続・ボタン・設定のローカル設定です。高度な機能は必要に応じて追加できます。';

  @override
  String get language => '言語';

  @override
  String get languageSystem => 'システムに従う';

  @override
  String get autoScan => '起動時にスキャン';

  @override
  String get autoScanSub => '起動後に自動で VibeMic を探します';

  @override
  String get autoReconnect => '自動再接続';

  @override
  String get autoReconnectSub => '予期せぬ切断の約3秒後に再スキャン';

  @override
  String get showScanDebug => 'スキャンデバッグを表示';

  @override
  String get showScanDebugSub => '接続ページに付近の BLE 広告を表示';

  @override
  String get tipsTitle => 'ヒント';

  @override
  String get tip1 =>
      '1. VB-Audio Virtual Cable をインストールし、ここは CABLE Input、IME は CABLE Output を選択。';

  @override
  String get tip2 => '2. Windows の Bluetooth 設定では接続せず、このアプリだけでスキャンしてください。';

  @override
  String get tip3 =>
      '3. INMP441 配線は docs/mic-inmp441.md。マイク未接続時は PTT がテスト音になります。';

  @override
  String get tip4 => '4. キーマトリックス配線は docs/keys-matrix.md。';

  @override
  String get tip5 =>
      '5. マルチタスク: Menu→Win+Tab、←/→長押しで切替、OK で確定。F1/F2/F3 = Agent 承認/拒否/新規。';

  @override
  String get tip6 =>
      '6. スクイーズ: PTT+Vol− 短押し=全画面 / 長押し=WeChat。PTT+Vol+ 短押し=ウィンドウ / 長押し=切り取りツール。';

  @override
  String get aboutTitle => '情報';

  @override
  String get aboutBody =>
      'VibeMic コンパニオン 0.1.0 · ESP32-C3 カスタム BLE 音声 + HID キー';

  @override
  String get editAction => 'アクションを編集';

  @override
  String get clear => 'クリア';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String get customShortcutHint => 'ショートカット（例: control+c / alt+f4）';

  @override
  String get customAppHint => 'アプリ id または exe（例: wechat / chrome）';

  @override
  String get catBasic => '基本キー';

  @override
  String get catEditing => '編集';

  @override
  String get catMedia => 'システムとメディア';

  @override
  String get catAgent => 'Cursor / Codex';

  @override
  String get catApps => 'アプリを開く';

  @override
  String get catCustom => 'カスタム';

  @override
  String get actionNone => 'なし';

  @override
  String get actionKeyShortcut => 'カスタムショートカット';

  @override
  String get actionHoldShortcut => '押し続けショートカット';

  @override
  String get actionOpenApp => 'アプリを開く…';

  @override
  String get actionCombination => 'コンビネーション';

  @override
  String get actionMediaPlayPause => '再生/一時停止';

  @override
  String get actionVolumeUp => '音量 +';

  @override
  String get actionVolumeDown => '音量 −';

  @override
  String get actionMute => 'ミュート';

  @override
  String get actionMediaNext => '次の曲';

  @override
  String get actionMediaPrev => '前の曲';

  @override
  String get actionTaskView => 'タスク表示 (Win+Tab)';

  @override
  String get actionScreenshotFull => '全画面キャプチャ (PrtSc)';

  @override
  String get actionScreenshotWindow => 'アクティブウィンドウ (Alt+PrtSc)';

  @override
  String get actionScreenshotWechat => 'WeChat キャプチャ (Alt+A)';

  @override
  String get actionScreenshotSnip => '切り取りツール (Win+Shift+S)';

  @override
  String get actionEscape => 'Esc';

  @override
  String get actionEnter => 'Enter / OK';

  @override
  String get actionCopy => 'コピー';

  @override
  String get actionPaste => '貼り付け';

  @override
  String get actionCut => '切り取り';

  @override
  String get actionSelectAll => 'すべて選択';

  @override
  String get actionUndo => '元に戻す';

  @override
  String get actionRedo => 'やり直し';

  @override
  String get actionFind => '検索';

  @override
  String get actionSave => '保存';

  @override
  String get actionCloseWindow => 'ウィンドウを閉じる';

  @override
  String get actionNewTab => '新しいタブ';

  @override
  String get actionPrevTab => '前のタブ';

  @override
  String get actionNextTab => '次のタブ';

  @override
  String get actionArrowUp => '↑（長押し可）';

  @override
  String get actionArrowDown => '↓（長押し可）';

  @override
  String get actionArrowLeft => '←（長押し可）';

  @override
  String get actionArrowRight => '→（長押し可）';

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
  String get actionAgentAccept => 'Agent 承認 (Ctrl+Enter)';

  @override
  String get actionAgentReject => 'Agent 拒否 (Esc)';

  @override
  String get actionAgentNewSession => 'Agent 新規セッション (Ctrl+L)';

  @override
  String get actionOpenWeChat => 'WeChat を開く';

  @override
  String get actionOpenCursor => 'Cursor を開く';

  @override
  String get actionOpenCodex => 'Codex / ChatGPT を開く';

  @override
  String get actionOpenChrome => 'Chrome を開く';

  @override
  String get actionOpenEdge => 'Edge を開く';

  @override
  String get actionOpenNotepad => 'メモ帳を開く';

  @override
  String get actionOpenExplorer => 'エクスプローラーを開く';

  @override
  String descShortcut(String keys) {
    return 'ショートカット: $keys';
  }

  @override
  String descHold(String keys) {
    return '長押し: $keys';
  }

  @override
  String descOpen(String app) {
    return '開く: $app';
  }

  @override
  String get descCombinationEmpty => 'コンビネーション（空）';

  @override
  String descCombination(String steps) {
    return 'コンボ: $steps';
  }

  @override
  String get modNone => 'なし（仮想マイクのみ）';

  @override
  String get modFn => 'Fn / 地球キー（macOS）';

  @override
  String get modLeftControl => '左 Ctrl';

  @override
  String get modRightControl => '右 Ctrl';

  @override
  String get modLeftAlt => '左 Alt';

  @override
  String get modRightAlt => '右 Alt';

  @override
  String get modLeftMeta => 'Win / Cmd';

  @override
  String get modRightMeta => '右 Win / Cmd';

  @override
  String get modCtrlWin => 'Ctrl + Win（WeChat IME）';

  @override
  String get keyUp => '上';

  @override
  String get keyDown => '下';

  @override
  String get keyLeft => '左';

  @override
  String get keyRight => '右';

  @override
  String get keyOk => 'OK';

  @override
  String get keyVolUp => '音量+';

  @override
  String get keyVolDown => '音量−';

  @override
  String get keyBack => '戻る';

  @override
  String get keyHome => 'Home';

  @override
  String get keyMenu => 'メニュー';

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
  String get keySqueezeVolDown => 'スクイーズ PTT+Vol−';

  @override
  String get keySqueezeVolUp => 'スクイーズ PTT+Vol+';

  @override
  String get keyShortVolUp => 'Vol+';

  @override
  String get keyShortVolDown => 'Vol−';

  @override
  String get keyShortSqueezeVolUp => '⊕+';

  @override
  String get keyShortSqueezeVolDown => '⊕−';

  @override
  String get statusIdle => '待機';

  @override
  String get statusCheckingBluetooth => 'Bluetooth を確認中…';

  @override
  String get statusUnsupported => 'この PC は Bluetooth 非対応です';

  @override
  String get statusKnownConnecting => '既知のデバイスを検出、接続中…';

  @override
  String statusScanning(int seconds) {
    return 'スキャン中 ${seconds}s…';
  }

  @override
  String statusScanningSeen(int count) {
    return 'スキャン中… $count 台検出';
  }

  @override
  String get statusNoDevices =>
      '0 台検出。Windows の Bluetooth を確認するか、nRF Connect で広告を確認してください。';

  @override
  String statusNotFound(int count, String sample) {
    return '$count 件の広告に VibeMic がありません。例: $sample';
  }

  @override
  String get statusFoundConnecting => 'VibeMic を検出、接続中…';

  @override
  String get statusAdapterTimeout => 'Bluetooth アダプターがタイムアウト';

  @override
  String statusScanFailed(String error) {
    return 'スキャン失敗: $error';
  }

  @override
  String statusConnecting(String name) {
    return '$name に接続中…';
  }

  @override
  String statusConnectFailed(String error) {
    return '接続失敗: $error — Windows でペア解除し、RST 後に再試行';
  }

  @override
  String get statusDisconnected => '切断しました';

  @override
  String get statusMissingGatt => 'VibeMic GATT 特性が不足';

  @override
  String get statusConnectedReady => '接続済み — PTT を押して話す';

  @override
  String get statusReconnecting => '再接続中…';

  @override
  String get statusNotConnected => '未接続';

  @override
  String statusTestTone(int ms) {
    return 'テスト音 ${ms}ms…';
  }

  @override
  String get statusDeviceNack => 'デバイス NACK';

  @override
  String get statusPttStreaming => 'PTT ストリーミング中…';

  @override
  String get btnEventUp => '離す';

  @override
  String get btnEventDown => '押す';

  @override
  String get btnEventClick => 'クリック';

  @override
  String get btnEventDouble => 'ダブル';

  @override
  String get btnEventLong => '長押し';

  @override
  String lastKeyDetail(int id, String event) {
    return 'キー $id · $event';
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
