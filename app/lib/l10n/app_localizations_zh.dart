// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'VibeMic';

  @override
  String get navConnection => '连接与语音';

  @override
  String get navMapping => '按键映射';

  @override
  String get navGeneral => '通用';

  @override
  String get connectionTitle => '连接与语音';

  @override
  String get connectionHint => '按住侧面 PTT 说话；松开停止。不要在 Windows 系统蓝牙里配对 VibeMic。';

  @override
  String get connected => '已连接 VibeMic';

  @override
  String get notConnected => '未连接';

  @override
  String get streaming => '推流中';

  @override
  String get idle => '待机';

  @override
  String audioFrames(int count) {
    return '音频帧 $count';
  }

  @override
  String lastKey(String event) {
    return '最近按键：$event';
  }

  @override
  String get scanConnect => '扫描并连接';

  @override
  String get disconnect => '断开';

  @override
  String get testTone => '1 秒测试音';

  @override
  String get softPtt => '按住软件 PTT';

  @override
  String get softPttActive => '软件 PTT…';

  @override
  String get virtualMic => '虚拟麦克风';

  @override
  String get virtualMicHint => '伴侣写入下方「播放设备」；微信/输入法请选择对应的 CABLE Output 作为麦克风。';

  @override
  String get selectLoopback => '选择 CABLE Input / 回环设备';

  @override
  String get refreshDevices => '刷新设备';

  @override
  String get voiceModifier => '语音修饰键';

  @override
  String get voiceModifierHint =>
      'PTT 按下时注入，用于触发输入法语音（Windows 微信输入法默认 Ctrl+Win）。';

  @override
  String gain(String value) {
    return '增益 $value×';
  }

  @override
  String deviceCaps(int version, int rate, int buttons, String touchpad) {
    return '设备能力：协议 v$version · $rate Hz · $buttons 键 · 触控板=$touchpad';
  }

  @override
  String get yes => '有';

  @override
  String get no => '无';

  @override
  String get scanDebug => '扫描调试';

  @override
  String get empty => '（无）';

  @override
  String get mappingTitle => '按键映射';

  @override
  String get mappingHint =>
      '布局：左侧 PTT、右侧音量；正面上排 F4–F6，方向键+OK，Home/返回/菜单，下排 F1–F3。捏合：同时按 PTT+音量，短按/长按可分别绑定截图等动作。';

  @override
  String get enableMapping => '启用按键映射';

  @override
  String get leftSide => '左侧面';

  @override
  String get rightSide => '右侧面';

  @override
  String get pttVoice => 'PTT';

  @override
  String liveEvent(String event) {
    return '实时：$event';
  }

  @override
  String keyId(int id) {
    return 'ID $id';
  }

  @override
  String get squeezeHint =>
      '捏合手势：同时按左侧 PTT 与右侧对应音量键。短按发「单击」，按住 ≥0.6s 发「长按」。期间不会进语音推流。';

  @override
  String get actionHold => '按住（方向键推荐）';

  @override
  String get actionClick => '单击';

  @override
  String get actionDouble => '双击';

  @override
  String get actionLong => '长按';

  @override
  String get actionSqueezeShort => '短按捏合';

  @override
  String get actionSqueezeLong => '长按捏合';

  @override
  String get resetDefaults => '恢复默认映射';

  @override
  String get generalTitle => '通用';

  @override
  String get generalHint => '本机偏好：连接、按键与设置。高级能力可按需继续扩展。';

  @override
  String get language => '语言';

  @override
  String get languageSystem => '跟随系统';

  @override
  String get autoScan => '启动时自动扫描';

  @override
  String get autoScanSub => '打开伴侣后自动寻找 VibeMic';

  @override
  String get autoReconnect => '断线自动重连';

  @override
  String get autoReconnectSub => '意外断开约 3 秒后重新扫描';

  @override
  String get showScanDebug => '显示扫描调试';

  @override
  String get showScanDebugSub => '在「连接与语音」页列出附近 BLE 广播';

  @override
  String get tipsTitle => '使用提示';

  @override
  String get tip1 =>
      '1. 安装 VB-Audio Virtual Cable；伴侣选 CABLE Input，输入法选 CABLE Output。';

  @override
  String get tip2 => '2. 不要在 Windows「设置 → 蓝牙」里连接 VibeMic，只在本伴侣扫描。';

  @override
  String get tip3 => '3. INMP441 接线见仓库 docs/mic-inmp441.md；麦未焊时 PTT 为测试音。';

  @override
  String get tip4 => '4. 按键矩阵接线见 docs/keys-matrix.md。';

  @override
  String get tip5 =>
      '5. 多任务：Menu→Win+Tab，按住←/→切换，OK 确认；F1/F2/F3 = Agent 接受/拒绝/新建会话。';

  @override
  String get tip6 =>
      '6. 捏合：PTT+Vol− 短按全屏截图 / 长按微信截图；PTT+Vol+ 短按窗口截图 / 长按系统截图工具。';

  @override
  String get aboutTitle => '关于';

  @override
  String get aboutBody => 'VibeMic 伴侣 0.1.0 · ESP32-C3 自定义 BLE 音频 + HID 按键';

  @override
  String get editAction => '编辑动作';

  @override
  String get clear => '清除';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get customShortcutHint => '快捷键（如 control+c 或 alt+f4）';

  @override
  String get customAppHint => '应用 id 或 exe 名（如 wechat / chrome / notepad）';

  @override
  String get catBasic => '基础按键';

  @override
  String get catEditing => '编辑';

  @override
  String get catMedia => '系统与媒体';

  @override
  String get catAgent => 'Cursor / Codex';

  @override
  String get catApps => '打开应用';

  @override
  String get catCustom => '自定义';

  @override
  String get actionNone => '无';

  @override
  String get actionKeyShortcut => '自定义快捷键';

  @override
  String get actionHoldShortcut => '按住保持快捷键';

  @override
  String get actionOpenApp => '打开应用…';

  @override
  String get actionCombination => '组合动作';

  @override
  String get actionMediaPlayPause => '播放/暂停';

  @override
  String get actionVolumeUp => '音量 +';

  @override
  String get actionVolumeDown => '音量 −';

  @override
  String get actionMute => '静音';

  @override
  String get actionMediaNext => '下一曲';

  @override
  String get actionMediaPrev => '上一曲';

  @override
  String get actionTaskView => '多任务视图 (Win+Tab)';

  @override
  String get actionScreenshotFull => '全屏截图 (PrtSc)';

  @override
  String get actionScreenshotWindow => '当前窗口截图 (Alt+PrtSc)';

  @override
  String get actionScreenshotWechat => '微信截图 (Alt+A)';

  @override
  String get actionScreenshotSnip => '系统截图工具 (Win+Shift+S)';

  @override
  String get actionEscape => 'Esc';

  @override
  String get actionEnter => '回车 / 确认';

  @override
  String get actionCopy => '复制';

  @override
  String get actionPaste => '粘贴';

  @override
  String get actionCut => '剪切';

  @override
  String get actionSelectAll => '全选';

  @override
  String get actionUndo => '撤销';

  @override
  String get actionRedo => '重做';

  @override
  String get actionFind => '查找';

  @override
  String get actionSave => '保存';

  @override
  String get actionCloseWindow => '关闭窗口';

  @override
  String get actionNewTab => '新建标签';

  @override
  String get actionPrevTab => '上一个标签';

  @override
  String get actionNextTab => '下一个标签';

  @override
  String get actionArrowUp => '↑（可按住）';

  @override
  String get actionArrowDown => '↓（可按住）';

  @override
  String get actionArrowLeft => '←（可按住）';

  @override
  String get actionArrowRight => '→（可按住）';

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
  String get actionAgentAccept => 'Agent 接受 (Ctrl+Enter)';

  @override
  String get actionAgentReject => 'Agent 拒绝 (Esc)';

  @override
  String get actionAgentNewSession => 'Agent 新建会话 (Ctrl+L)';

  @override
  String get actionOpenWeChat => '打开微信';

  @override
  String get actionOpenCursor => '打开 Cursor';

  @override
  String get actionOpenCodex => '打开 Codex / ChatGPT';

  @override
  String get actionOpenChrome => '打开 Chrome';

  @override
  String get actionOpenEdge => '打开 Edge';

  @override
  String get actionOpenNotepad => '打开记事本';

  @override
  String get actionOpenExplorer => '打开资源管理器';

  @override
  String descShortcut(String keys) {
    return '快捷键: $keys';
  }

  @override
  String descHold(String keys) {
    return '按住: $keys';
  }

  @override
  String descOpen(String app) {
    return '打开: $app';
  }

  @override
  String get descCombinationEmpty => '组合动作（空）';

  @override
  String descCombination(String steps) {
    return '组合: $steps';
  }

  @override
  String get modNone => '无（仅推虚拟麦）';

  @override
  String get modFn => 'Fn / 地球键（macOS）';

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
  String get modCtrlWin => 'Ctrl + Win（微信输入法）';

  @override
  String get keyUp => '上';

  @override
  String get keyDown => '下';

  @override
  String get keyLeft => '左';

  @override
  String get keyRight => '右';

  @override
  String get keyOk => '确认';

  @override
  String get keyVolUp => '音量+';

  @override
  String get keyVolDown => '音量−';

  @override
  String get keyBack => '返回';

  @override
  String get keyHome => 'Home';

  @override
  String get keyMenu => '菜单';

  @override
  String get keyF1 => '功能1';

  @override
  String get keyF2 => '功能2';

  @override
  String get keyF3 => '功能3';

  @override
  String get keyF4 => '功能4';

  @override
  String get keyF5 => '功能5';

  @override
  String get keyF6 => '功能6';

  @override
  String get keySqueezeVolDown => '捏合 PTT+Vol−';

  @override
  String get keySqueezeVolUp => '捏合 PTT+Vol+';

  @override
  String get keyShortVolUp => 'Vol+';

  @override
  String get keyShortVolDown => 'Vol−';

  @override
  String get keyShortSqueezeVolUp => '⊕+';

  @override
  String get keyShortSqueezeVolDown => '⊕−';

  @override
  String get statusIdle => '空闲';

  @override
  String get statusCheckingBluetooth => '检查蓝牙…';

  @override
  String get statusUnsupported => '本机不支持蓝牙';

  @override
  String get statusKnownConnecting => '发现已知设备，连接中…';

  @override
  String statusScanning(int seconds) {
    return '扫描中 ${seconds}s…';
  }

  @override
  String statusScanningSeen(int count) {
    return '扫描中… 已见 $count 台设备';
  }

  @override
  String get statusNoDevices =>
      '扫描到 0 台设备。请检查 Windows 蓝牙，或用手机 nRF Connect 确认板子在广播。';

  @override
  String statusNotFound(int count, String sample) {
    return '在 $count 条广播中未找到 VibeMic。样例: $sample';
  }

  @override
  String get statusFoundConnecting => '找到 VibeMic，连接中…';

  @override
  String get statusAdapterTimeout => '蓝牙适配器超时';

  @override
  String statusScanFailed(String error) {
    return '扫描失败: $error';
  }

  @override
  String statusConnecting(String name) {
    return '正在连接 $name…';
  }

  @override
  String statusConnectFailed(String error) {
    return '连接失败: $error — 请在 Windows 取消配对，按 RST 后重试';
  }

  @override
  String get statusDisconnected => '已断开';

  @override
  String get statusMissingGatt => '缺少 VibeMic GATT 特征';

  @override
  String get statusConnectedReady => '已连接 — 按住 PTT 说话';

  @override
  String get statusReconnecting => '自动重连中…';

  @override
  String get statusNotConnected => '未连接';

  @override
  String statusTestTone(int ms) {
    return '测试音 ${ms}ms…';
  }

  @override
  String get statusDeviceNack => '设备 NACK';

  @override
  String get statusPttStreaming => 'PTT 推流中…';

  @override
  String get btnEventUp => '抬起';

  @override
  String get btnEventDown => '按下';

  @override
  String get btnEventClick => '单击';

  @override
  String get btnEventDouble => '双击';

  @override
  String get btnEventLong => '长按';

  @override
  String lastKeyDetail(int id, String event) {
    return '按键 $id · $event';
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

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => 'VibeMic';

  @override
  String get navConnection => '連線與語音';

  @override
  String get navMapping => '按鍵對應';

  @override
  String get navGeneral => '一般';

  @override
  String get connectionTitle => '連線與語音';

  @override
  String get connectionHint => '按住側面 PTT 說話；放開停止。請勿在 Windows 系統藍牙中配對 VibeMic。';

  @override
  String get connected => '已連線 VibeMic';

  @override
  String get notConnected => '未連線';

  @override
  String get streaming => '串流中';

  @override
  String get idle => '待機';

  @override
  String audioFrames(int count) {
    return '音訊幀 $count';
  }

  @override
  String lastKey(String event) {
    return '最近按鍵：$event';
  }

  @override
  String get scanConnect => '掃描並連線';

  @override
  String get disconnect => '中斷連線';

  @override
  String get testTone => '1 秒測試音';

  @override
  String get softPtt => '按住軟體 PTT';

  @override
  String get softPttActive => '軟體 PTT…';

  @override
  String get virtualMic => '虛擬麥克風';

  @override
  String get virtualMicHint => '伴侶寫入下方「播放裝置」；請在微信/輸入法選擇對應的 CABLE Output 作為麥克風。';

  @override
  String get selectLoopback => '選擇 CABLE Input / 迴路裝置';

  @override
  String get refreshDevices => '重新整理裝置';

  @override
  String get voiceModifier => '語音修飾鍵';

  @override
  String get voiceModifierHint =>
      '按住 PTT 時注入，用於觸發輸入法語音（Windows 微信輸入法預設 Ctrl+Win）。';

  @override
  String gain(String value) {
    return '增益 $value×';
  }

  @override
  String deviceCaps(int version, int rate, int buttons, String touchpad) {
    return '裝置能力：協定 v$version · $rate Hz · $buttons 鍵 · 觸控板=$touchpad';
  }

  @override
  String get yes => '有';

  @override
  String get no => '無';

  @override
  String get scanDebug => '掃描除錯';

  @override
  String get empty => '（無）';

  @override
  String get mappingTitle => '按鍵對應';

  @override
  String get mappingHint =>
      '配置：左側 PTT、右側音量；正面上排 F4–F6，方向鍵+OK，Home/返回/選單，下排 F1–F3。捏合：同時按 PTT+音量，短按/長按可分別綁定截圖等動作。';

  @override
  String get enableMapping => '啟用按鍵對應';

  @override
  String get leftSide => '左側';

  @override
  String get rightSide => '右側';

  @override
  String get pttVoice => 'PTT';

  @override
  String liveEvent(String event) {
    return '即時：$event';
  }

  @override
  String keyId(int id) {
    return 'ID $id';
  }

  @override
  String get squeezeHint =>
      '捏合手勢：同時按左側 PTT 與右側對應音量鍵。短按送出「單擊」，按住 ≥0.6s 送出「長按」。期間不會進入語音串流。';

  @override
  String get actionHold => '按住（方向鍵建議）';

  @override
  String get actionClick => '單擊';

  @override
  String get actionDouble => '雙擊';

  @override
  String get actionLong => '長按';

  @override
  String get actionSqueezeShort => '短按捏合';

  @override
  String get actionSqueezeLong => '長按捏合';

  @override
  String get resetDefaults => '還原預設對應';

  @override
  String get generalTitle => '一般';

  @override
  String get generalHint => '本機偏好：連線、按鍵與設定。進階功能可依需求擴充。';

  @override
  String get language => '語言';

  @override
  String get languageSystem => '跟隨系統';

  @override
  String get autoScan => '啟動時自動掃描';

  @override
  String get autoScanSub => '開啟伴侶後自動尋找 VibeMic';

  @override
  String get autoReconnect => '斷線自動重連';

  @override
  String get autoReconnectSub => '意外中斷約 3 秒後重新掃描';

  @override
  String get showScanDebug => '顯示掃描除錯';

  @override
  String get showScanDebugSub => '在「連線與語音」頁列出附近 BLE 廣播';

  @override
  String get tipsTitle => '使用提示';

  @override
  String get tip1 =>
      '1. 安裝 VB-Audio Virtual Cable；伴侶選 CABLE Input，輸入法選 CABLE Output。';

  @override
  String get tip2 => '2. 請勿在 Windows「設定 → 藍牙」連線 VibeMic，只在本伴侶掃描。';

  @override
  String get tip3 => '3. INMP441 接線見 docs/mic-inmp441.md；尚未接麥克風時 PTT 為測試音。';

  @override
  String get tip4 => '4. 按鍵矩陣接線見 docs/keys-matrix.md。';

  @override
  String get tip5 =>
      '5. 多工：Menu→Win+Tab，按住←/→切換，OK 確認；F1/F2/F3 = Agent 接受/拒絕/新建工作階段。';

  @override
  String get tip6 =>
      '6. 捏合：PTT+Vol− 短按全螢幕截圖 / 長按微信截圖；PTT+Vol+ 短按視窗截圖 / 長按系統截圖工具。';

  @override
  String get aboutTitle => '關於';

  @override
  String get aboutBody => 'VibeMic 伴侶 0.1.0 · ESP32-C3 自訂 BLE 音訊 + HID 按鍵';

  @override
  String get editAction => '編輯動作';

  @override
  String get clear => '清除';

  @override
  String get cancel => '取消';

  @override
  String get save => '儲存';

  @override
  String get customShortcutHint => '快捷鍵（例如 control+c 或 alt+f4）';

  @override
  String get customAppHint => '應用程式 id 或 exe（例如 wechat / chrome / notepad）';

  @override
  String get catBasic => '基本按鍵';

  @override
  String get catEditing => '編輯';

  @override
  String get catMedia => '系統與媒體';

  @override
  String get catAgent => 'Cursor / Codex';

  @override
  String get catApps => '開啟應用程式';

  @override
  String get catCustom => '自訂';

  @override
  String get actionNone => '無';

  @override
  String get actionKeyShortcut => '自訂快捷鍵';

  @override
  String get actionHoldShortcut => '按住保持快捷鍵';

  @override
  String get actionOpenApp => '開啟應用程式…';

  @override
  String get actionCombination => '組合動作';

  @override
  String get actionMediaPlayPause => '播放/暫停';

  @override
  String get actionVolumeUp => '音量 +';

  @override
  String get actionVolumeDown => '音量 −';

  @override
  String get actionMute => '靜音';

  @override
  String get actionMediaNext => '下一首';

  @override
  String get actionMediaPrev => '上一首';

  @override
  String get actionTaskView => '多工檢視 (Win+Tab)';

  @override
  String get actionScreenshotFull => '全螢幕截圖 (PrtSc)';

  @override
  String get actionScreenshotWindow => '目前視窗截圖 (Alt+PrtSc)';

  @override
  String get actionScreenshotWechat => '微信截圖 (Alt+A)';

  @override
  String get actionScreenshotSnip => '系統截圖工具 (Win+Shift+S)';

  @override
  String get actionEscape => 'Esc';

  @override
  String get actionEnter => 'Enter / 確認';

  @override
  String get actionCopy => '複製';

  @override
  String get actionPaste => '貼上';

  @override
  String get actionCut => '剪下';

  @override
  String get actionSelectAll => '全選';

  @override
  String get actionUndo => '復原';

  @override
  String get actionRedo => '重做';

  @override
  String get actionFind => '尋找';

  @override
  String get actionSave => '儲存';

  @override
  String get actionCloseWindow => '關閉視窗';

  @override
  String get actionNewTab => '新增分頁';

  @override
  String get actionPrevTab => '上一個分頁';

  @override
  String get actionNextTab => '下一個分頁';

  @override
  String get actionArrowUp => '↑（可按住）';

  @override
  String get actionArrowDown => '↓（可按住）';

  @override
  String get actionArrowLeft => '←（可按住）';

  @override
  String get actionArrowRight => '→（可按住）';

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
  String get actionAgentAccept => 'Agent 接受 (Ctrl+Enter)';

  @override
  String get actionAgentReject => 'Agent 拒絕 (Esc)';

  @override
  String get actionAgentNewSession => 'Agent 新建工作階段 (Ctrl+L)';

  @override
  String get actionOpenWeChat => '開啟微信';

  @override
  String get actionOpenCursor => '開啟 Cursor';

  @override
  String get actionOpenCodex => '開啟 Codex / ChatGPT';

  @override
  String get actionOpenChrome => '開啟 Chrome';

  @override
  String get actionOpenEdge => '開啟 Edge';

  @override
  String get actionOpenNotepad => '開啟記事本';

  @override
  String get actionOpenExplorer => '開啟檔案總管';

  @override
  String descShortcut(String keys) {
    return '快捷鍵: $keys';
  }

  @override
  String descHold(String keys) {
    return '按住: $keys';
  }

  @override
  String descOpen(String app) {
    return '開啟: $app';
  }

  @override
  String get descCombinationEmpty => '組合動作（空）';

  @override
  String descCombination(String steps) {
    return '組合: $steps';
  }

  @override
  String get modNone => '無（僅推虛擬麥克風）';

  @override
  String get modFn => 'Fn / 地球鍵（macOS）';

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
  String get modCtrlWin => 'Ctrl + Win（微信輸入法）';

  @override
  String get keyUp => '上';

  @override
  String get keyDown => '下';

  @override
  String get keyLeft => '左';

  @override
  String get keyRight => '右';

  @override
  String get keyOk => '確認';

  @override
  String get keyVolUp => '音量+';

  @override
  String get keyVolDown => '音量−';

  @override
  String get keyBack => '返回';

  @override
  String get keyHome => 'Home';

  @override
  String get keyMenu => '選單';

  @override
  String get keyF1 => '功能1';

  @override
  String get keyF2 => '功能2';

  @override
  String get keyF3 => '功能3';

  @override
  String get keyF4 => '功能4';

  @override
  String get keyF5 => '功能5';

  @override
  String get keyF6 => '功能6';

  @override
  String get keySqueezeVolDown => '捏合 PTT+Vol−';

  @override
  String get keySqueezeVolUp => '捏合 PTT+Vol+';

  @override
  String get keyShortVolUp => 'Vol+';

  @override
  String get keyShortVolDown => 'Vol−';

  @override
  String get keyShortSqueezeVolUp => '⊕+';

  @override
  String get keyShortSqueezeVolDown => '⊕−';

  @override
  String get statusIdle => '閒置';

  @override
  String get statusCheckingBluetooth => '檢查藍牙…';

  @override
  String get statusUnsupported => '本機不支援藍牙';

  @override
  String get statusKnownConnecting => '發現已知裝置，連線中…';

  @override
  String statusScanning(int seconds) {
    return '掃描中 ${seconds}s…';
  }

  @override
  String statusScanningSeen(int count) {
    return '掃描中… 已見 $count 台裝置';
  }

  @override
  String get statusNoDevices =>
      '掃描到 0 台裝置。請檢查 Windows 藍牙，或用手機 nRF Connect 確認板子在廣播。';

  @override
  String statusNotFound(int count, String sample) {
    return '在 $count 則廣播中未找到 VibeMic。樣例: $sample';
  }

  @override
  String get statusFoundConnecting => '找到 VibeMic，連線中…';

  @override
  String get statusAdapterTimeout => '藍牙配接器逾時';

  @override
  String statusScanFailed(String error) {
    return '掃描失敗: $error';
  }

  @override
  String statusConnecting(String name) {
    return '正在連線 $name…';
  }

  @override
  String statusConnectFailed(String error) {
    return '連線失敗: $error — 請在 Windows 取消配對，按 RST 後重試';
  }

  @override
  String get statusDisconnected => '已中斷';

  @override
  String get statusMissingGatt => '缺少 VibeMic GATT 特徵';

  @override
  String get statusConnectedReady => '已連線 — 按住 PTT 說話';

  @override
  String get statusReconnecting => '自動重連中…';

  @override
  String get statusNotConnected => '未連線';

  @override
  String statusTestTone(int ms) {
    return '測試音 ${ms}ms…';
  }

  @override
  String get statusDeviceNack => '裝置 NACK';

  @override
  String get statusPttStreaming => 'PTT 串流中…';

  @override
  String get btnEventUp => '放開';

  @override
  String get btnEventDown => '按下';

  @override
  String get btnEventClick => '單擊';

  @override
  String get btnEventDouble => '雙擊';

  @override
  String get btnEventLong => '長按';

  @override
  String lastKeyDetail(int id, String event) {
    return '按鍵 $id · $event';
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
