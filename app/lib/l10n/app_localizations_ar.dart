// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'VibeMic';

  @override
  String get navConnection => 'الاتصال والصوت';

  @override
  String get navMapping => 'تعيين الأزرار';

  @override
  String get navGeneral => 'عام';

  @override
  String get connectionTitle => 'الاتصال والصوت';

  @override
  String get connectionHint =>
      'اضغط مع الاستمرار على زر PTT الجانبي للتحدث؛ أفلت للإيقاف. لا تقم بإقران VibeMic من إعدادات بلوتوث ويندوز.';

  @override
  String get connected => 'متصل بـ VibeMic';

  @override
  String get notConnected => 'غير متصل';

  @override
  String get streaming => 'بث جارٍ';

  @override
  String get idle => 'خامل';

  @override
  String audioFrames(int count) {
    return 'إطارات الصوت $count';
  }

  @override
  String lastKey(String event) {
    return 'آخر مفتاح: $event';
  }

  @override
  String get scanConnect => 'مسح واتصال';

  @override
  String get disconnect => 'قطع الاتصال';

  @override
  String get testTone => 'نغمة اختبار ثانية واحدة';

  @override
  String get softPtt => 'اضغط مع الاستمرار على PTT البرمجي';

  @override
  String get softPttActive => 'PTT برمجي…';

  @override
  String get virtualMic => 'ميكروفون افتراضي';

  @override
  String get virtualMicHint =>
      'يكتب التطبيق إلى جهاز التشغيل أدناه. في طريقة الإدخال اختر CABLE Output المطابق كميكروفون.';

  @override
  String get selectLoopback => 'اختر CABLE Input / حلقة';

  @override
  String get refreshDevices => 'تحديث الأجهزة';

  @override
  String get voiceModifier => 'مفتاح تعديل الصوت';

  @override
  String get voiceModifierHint =>
      'يُحقن أثناء الضغط على PTT لتشغيل صوت طريقة الإدخال (WeChat افتراضيًا: Ctrl+Win).';

  @override
  String gain(String value) {
    return 'ال增益 $value×';
  }

  @override
  String deviceCaps(int version, int rate, int buttons, String touchpad) {
    return 'الجهاز: بروتوكول v$version · $rate هرتز · $buttons مفاتيح · لوحة لمس=$touchpad';
  }

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get scanDebug => 'تصحيح المسح';

  @override
  String get empty => '(فارغ)';

  @override
  String get mappingTitle => 'تعيين الأزرار';

  @override
  String get mappingHint =>
      'التخطيط: PTT يسارًا والصوت يمينًا؛ الواجهة F4–F6 والاتجاهات+موافق وHome/رجوع/قائمة وF1–F3. الضغط المزدوج: PTT+الصوت؛ قصير/طويل للقطات الشاشة وغيرها.';

  @override
  String get enableMapping => 'تفعيل تعيين الأزرار';

  @override
  String get leftSide => 'الجانب الأيسر';

  @override
  String get rightSide => 'الجانب الأيمن';

  @override
  String get pttVoice => 'PTT';

  @override
  String liveEvent(String event) {
    return 'مباشر: $event';
  }

  @override
  String keyId(int id) {
    return 'المعرّف $id';
  }

  @override
  String get squeezeHint =>
      'الضغط المزدوج: اضغط PTT الأيسر مع مفتاح الصوت المطابق. القصير = نقرة؛ ≥0.6 ث = طويل. لا بث صوتي أثناء ذلك.';

  @override
  String get actionHold => 'ضغط مطوّل (موصى به للأسهم)';

  @override
  String get actionClick => 'نقرة';

  @override
  String get actionDouble => 'مزدوج';

  @override
  String get actionLong => 'ضغط طويل';

  @override
  String get actionSqueezeShort => 'ضغط مزدوج قصير';

  @override
  String get actionSqueezeLong => 'ضغط مزدوج طويل';

  @override
  String get resetDefaults => 'استعادة الافتراضي';

  @override
  String get generalTitle => 'عام';

  @override
  String get generalHint =>
      'تفضيلات محلية للاتصال والأزرار والإعدادات. يمكن إضافة الميزات المتقدمة لاحقًا.';

  @override
  String get language => 'اللغة';

  @override
  String get languageSystem => 'افتراضي النظام';

  @override
  String get autoScan => 'مسح عند التشغيل';

  @override
  String get autoScanSub => 'البحث تلقائيًا عن VibeMic عند فتح التطبيق';

  @override
  String get autoReconnect => 'إعادة الاتصال تلقائيًا';

  @override
  String get autoReconnectSub =>
      'إعادة المسح بعد نحو 3 ثوانٍ من انقطاع غير متوقع';

  @override
  String get showScanDebug => 'إظهار تصحيح المسح';

  @override
  String get showScanDebugSub => 'عرض إعلانات BLE القريبة في صفحة الاتصال';

  @override
  String get tipsTitle => 'نصائح';

  @override
  String get tip1 =>
      '1. ثبّت VB-Audio Virtual Cable؛ اختر CABLE Input هنا وCABLE Output في طريقة الإدخال.';

  @override
  String get tip2 =>
      '2. لا تصل VibeMic من إعدادات بلوتوث ويندوز—امسح فقط من هذا التطبيق.';

  @override
  String get tip3 =>
      '3. توصيل INMP441: docs/mic-inmp441.md. بدون ميكروفون يشغّل PTT نغمة اختبار.';

  @override
  String get tip4 => '4. مصفوفة المفاتيح: docs/keys-matrix.md.';

  @override
  String get tip5 =>
      '5. تعدد المهام: القائمة → Win+Tab، ←/→ للتبديل، موافق للتأكيد؛ F1/F2/F3 = قبول/رفض/جلسة جديدة للوكيل.';

  @override
  String get tip6 =>
      '6. ضغط مزدوج: PTT+Vol− قصير = شاشة كاملة / طويل = WeChat؛ PTT+Vol+ قصير = نافذة / طويل = أداة القص.';

  @override
  String get aboutTitle => 'حول';

  @override
  String get aboutBody =>
      'رفيق VibeMic 0.1.0 · صوت BLE مخصص لـ ESP32-C3 + مفاتيح HID';

  @override
  String get editAction => 'تحرير الإجراء';

  @override
  String get clear => 'مسح';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get customShortcutHint => 'اختصار (مثل control+c أو alt+f4)';

  @override
  String get customAppHint => 'معرّف التطبيق أو exe (مثل wechat / chrome)';

  @override
  String get catBasic => 'مفاتيح أساسية';

  @override
  String get catEditing => 'تحرير';

  @override
  String get catMedia => 'النظام والوسائط';

  @override
  String get catAgent => 'Cursor / Codex';

  @override
  String get catApps => 'فتح التطبيقات';

  @override
  String get catCustom => 'مخصص';

  @override
  String get actionNone => 'لا شيء';

  @override
  String get actionKeyShortcut => 'اختصار مخصص';

  @override
  String get actionHoldShortcut => 'إمساك الاختصار';

  @override
  String get actionOpenApp => 'فتح تطبيق…';

  @override
  String get actionCombination => 'تركيبة';

  @override
  String get actionMediaPlayPause => 'تشغيل/إيقاف مؤقت';

  @override
  String get actionVolumeUp => 'رفع الصوت';

  @override
  String get actionVolumeDown => 'خفض الصوت';

  @override
  String get actionMute => 'كتم';

  @override
  String get actionMediaNext => 'المقطع التالي';

  @override
  String get actionMediaPrev => 'المقطع السابق';

  @override
  String get actionTaskView => 'عرض المهام (Win+Tab)';

  @override
  String get actionScreenshotFull => 'لقطة شاشة كاملة (PrtSc)';

  @override
  String get actionScreenshotWindow => 'لقطة النافذة النشطة (Alt+PrtSc)';

  @override
  String get actionScreenshotWechat => 'لقطة WeChat (Alt+A)';

  @override
  String get actionScreenshotSnip => 'أداة القص (Win+Shift+S)';

  @override
  String get actionEscape => 'Esc';

  @override
  String get actionEnter => 'إدخال / موافق';

  @override
  String get actionCopy => 'نسخ';

  @override
  String get actionPaste => 'لصق';

  @override
  String get actionCut => 'قص';

  @override
  String get actionSelectAll => 'تحديد الكل';

  @override
  String get actionUndo => 'تراجع';

  @override
  String get actionRedo => 'إعادة';

  @override
  String get actionFind => 'بحث';

  @override
  String get actionSave => 'حفظ';

  @override
  String get actionCloseWindow => 'إغلاق النافذة';

  @override
  String get actionNewTab => 'علامة تبويب جديدة';

  @override
  String get actionPrevTab => 'التبويب السابق';

  @override
  String get actionNextTab => 'التبويب التالي';

  @override
  String get actionArrowUp => '↑ (يمكن الإمساك)';

  @override
  String get actionArrowDown => '↓ (يمكن الإمساك)';

  @override
  String get actionArrowLeft => '← (يمكن الإمساك)';

  @override
  String get actionArrowRight => '→ (يمكن الإمساك)';

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
  String get actionAgentAccept => 'قبول الوكيل (Ctrl+Enter)';

  @override
  String get actionAgentReject => 'رفض الوكيل (Esc)';

  @override
  String get actionAgentNewSession => 'جلسة وكيل جديدة (Ctrl+L)';

  @override
  String get actionOpenWeChat => 'فتح WeChat';

  @override
  String get actionOpenCursor => 'فتح Cursor';

  @override
  String get actionOpenCodex => 'فتح Codex / ChatGPT';

  @override
  String get actionOpenChrome => 'فتح Chrome';

  @override
  String get actionOpenEdge => 'فتح Edge';

  @override
  String get actionOpenNotepad => 'فتح المفكرة';

  @override
  String get actionOpenExplorer => 'فتح مستكشف الملفات';

  @override
  String descShortcut(String keys) {
    return 'اختصار: $keys';
  }

  @override
  String descHold(String keys) {
    return 'إمساك: $keys';
  }

  @override
  String descOpen(String app) {
    return 'فتح: $app';
  }

  @override
  String get descCombinationEmpty => 'تركيبة (فارغة)';

  @override
  String descCombination(String steps) {
    return 'تركيبة: $steps';
  }

  @override
  String get modNone => 'لا شيء (الميكروفون الافتراضي فقط)';

  @override
  String get modFn => 'Fn / الكرة الأرضية (macOS)';

  @override
  String get modLeftControl => 'Ctrl أيسر';

  @override
  String get modRightControl => 'Ctrl أيمن';

  @override
  String get modLeftAlt => 'Alt أيسر';

  @override
  String get modRightAlt => 'Alt أيمن';

  @override
  String get modLeftMeta => 'Win / Cmd';

  @override
  String get modRightMeta => 'Win / Cmd أيمن';

  @override
  String get modCtrlWin => 'Ctrl + Win (إدخال WeChat)';

  @override
  String get keyUp => 'أعلى';

  @override
  String get keyDown => 'أسفل';

  @override
  String get keyLeft => 'يسار';

  @override
  String get keyRight => 'يمين';

  @override
  String get keyOk => 'موافق';

  @override
  String get keyVolUp => 'رفع الصوت';

  @override
  String get keyVolDown => 'خفض الصوت';

  @override
  String get keyBack => 'رجوع';

  @override
  String get keyHome => 'الرئيسية';

  @override
  String get keyMenu => 'القائمة';

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
  String get keySqueezeVolDown => 'ضغط مزدوج PTT+Vol−';

  @override
  String get keySqueezeVolUp => 'ضغط مزدوج PTT+Vol+';

  @override
  String get keyShortVolUp => 'Vol+';

  @override
  String get keyShortVolDown => 'Vol−';

  @override
  String get keyShortSqueezeVolUp => '⊕+';

  @override
  String get keyShortSqueezeVolDown => '⊕−';

  @override
  String get statusIdle => 'خامل';

  @override
  String get statusCheckingBluetooth => 'جارٍ التحقق من البلوتوث…';

  @override
  String get statusUnsupported => 'البلوتوث غير مدعوم على هذا الجهاز';

  @override
  String get statusKnownConnecting => 'تم العثور على جهاز معروف، جارٍ الاتصال…';

  @override
  String statusScanning(int seconds) {
    return 'جارٍ المسح $seconds ث…';
  }

  @override
  String statusScanningSeen(int count) {
    return 'جارٍ المسح… شوهد $count جهاز';
  }

  @override
  String get statusNoDevices =>
      'لم يُعثر على أجهزة. تحقق من بلوتوث Windows أو أكّد البث عبر nRF Connect.';

  @override
  String statusNotFound(int count, String sample) {
    return 'لم يُعثر على VibeMic ضمن $count إعلان. مثال: $sample';
  }

  @override
  String get statusFoundConnecting => 'تم العثور على VibeMic، جارٍ الاتصال…';

  @override
  String get statusAdapterTimeout => 'انتهت مهلة محوّل البلوتوث';

  @override
  String statusScanFailed(String error) {
    return 'فشل المسح: $error';
  }

  @override
  String statusConnecting(String name) {
    return 'جارٍ الاتصال بـ $name…';
  }

  @override
  String statusConnectFailed(String error) {
    return 'فشل الاتصال: $error — ألغِ الاقتران في Windows واضغط RST ثم أعد المحاولة';
  }

  @override
  String get statusDisconnected => 'تم قطع الاتصال';

  @override
  String get statusMissingGatt => 'خصائص GATT الخاصة بـ VibeMic مفقودة';

  @override
  String get statusConnectedReady => 'متصل — اضغط مطولاً على PTT للتحدث';

  @override
  String get statusReconnecting => 'جارٍ إعادة الاتصال…';

  @override
  String get statusNotConnected => 'غير متصل';

  @override
  String statusTestTone(int ms) {
    return 'نغمة اختبار $ms ملث…';
  }

  @override
  String get statusDeviceNack => 'NACK من الجهاز';

  @override
  String get statusPttStreaming => 'بث PTT…';

  @override
  String get btnEventUp => 'رفع';

  @override
  String get btnEventDown => 'ضغط';

  @override
  String get btnEventClick => 'نقرة';

  @override
  String get btnEventDouble => 'مزدوج';

  @override
  String get btnEventLong => 'طويل';

  @override
  String lastKeyDetail(int id, String event) {
    return 'مفتاح $id · $event';
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
