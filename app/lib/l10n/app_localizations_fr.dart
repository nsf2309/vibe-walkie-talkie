// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'VibeMic';

  @override
  String get navConnection => 'Connexion et voix';

  @override
  String get navMapping => 'Affectation des touches';

  @override
  String get navGeneral => 'Général';

  @override
  String get connectionTitle => 'Connexion et voix';

  @override
  String get connectionHint =>
      'Maintenez le PTT latéral pour parler ; relâchez pour arrêter. Ne couplez pas VibeMic dans les paramètres Bluetooth de Windows.';

  @override
  String get connected => 'Connecté à VibeMic';

  @override
  String get notConnected => 'Non connecté';

  @override
  String get streaming => 'En streaming';

  @override
  String get idle => 'Inactif';

  @override
  String audioFrames(int count) {
    return 'Trames audio $count';
  }

  @override
  String lastKey(String event) {
    return 'Dernière touche : $event';
  }

  @override
  String get scanConnect => 'Scanner et connecter';

  @override
  String get disconnect => 'Déconnecter';

  @override
  String get testTone => 'Tonalité 1 s';

  @override
  String get softPtt => 'Maintenir PTT logiciel';

  @override
  String get softPttActive => 'PTT logiciel…';

  @override
  String get virtualMic => 'Microphone virtuel';

  @override
  String get virtualMicHint =>
      'Le compagnon écrit vers le périphérique de lecture ci-dessous. Dans l’IME, choisissez le CABLE Output correspondant comme micro.';

  @override
  String get selectLoopback => 'Choisir CABLE Input / boucle';

  @override
  String get refreshDevices => 'Actualiser les périphériques';

  @override
  String get voiceModifier => 'Modificateur vocal';

  @override
  String get voiceModifierHint =>
      'Injecté pendant le PTT pour déclencher la voix IME (WeChat IME : Ctrl+Win par défaut).';

  @override
  String gain(String value) {
    return 'Gain $value×';
  }

  @override
  String deviceCaps(int version, int rate, int buttons, String touchpad) {
    return 'Appareil : protocole v$version · $rate Hz · $buttons touches · pavé=$touchpad';
  }

  @override
  String get yes => 'oui';

  @override
  String get no => 'non';

  @override
  String get scanDebug => 'Débogage du scan';

  @override
  String get empty => '(vide)';

  @override
  String get mappingTitle => 'Affectation des touches';

  @override
  String get mappingHint =>
      'Disposition : PTT à gauche, volume à droite ; face F4–F6, croix+OK, Accueil/Retour/Menu, F1–F3. Compression : PTT+volume ; court/long pour captures, etc.';

  @override
  String get enableMapping => 'Activer l’affectation';

  @override
  String get leftSide => 'Côté gauche';

  @override
  String get rightSide => 'Côté droit';

  @override
  String get pttVoice => 'PTT';

  @override
  String liveEvent(String event) {
    return 'Temps réel : $event';
  }

  @override
  String keyId(int id) {
    return 'ID $id';
  }

  @override
  String get squeezeHint =>
      'Compression : maintenez le PTT gauche avec la touche volume correspondante. Court = clic ; ≥0,6 s = long. Pas de streaming vocal pendant ce temps.';

  @override
  String get actionHold => 'Maintenir (recommandé pour les flèches)';

  @override
  String get actionClick => 'Clic';

  @override
  String get actionDouble => 'Double';

  @override
  String get actionLong => 'Appui long';

  @override
  String get actionSqueezeShort => 'Compression courte';

  @override
  String get actionSqueezeLong => 'Compression longue';

  @override
  String get resetDefaults => 'Restaurer les valeurs par défaut';

  @override
  String get generalTitle => 'Général';

  @override
  String get generalHint =>
      'Préférences locales : connexion, touches et réglages. Fonctions avancées ajoutables plus tard.';

  @override
  String get language => 'Langue';

  @override
  String get languageSystem => 'Par défaut du système';

  @override
  String get autoScan => 'Scanner au démarrage';

  @override
  String get autoScanSub => 'Rechercher automatiquement VibeMic à l’ouverture';

  @override
  String get autoReconnect => 'Reconnexion automatique';

  @override
  String get autoReconnectSub =>
      'Nouveau scan ~3 s après une déconnexion inattendue';

  @override
  String get showScanDebug => 'Afficher le débogage du scan';

  @override
  String get showScanDebugSub => 'Lister les pubs BLE sur la page Connexion';

  @override
  String get tipsTitle => 'Conseils';

  @override
  String get tip1 =>
      '1. Installez VB-Audio Virtual Cable ; CABLE Input ici, CABLE Output dans l’IME.';

  @override
  String get tip2 =>
      '2. Ne connectez pas VibeMic dans Bluetooth Windows — scannez uniquement ici.';

  @override
  String get tip3 =>
      '3. Câblage INMP441 : docs/mic-inmp441.md. Sans micro, le PTT joue une tonalité.';

  @override
  String get tip4 => '4. Matrice de touches : docs/keys-matrix.md.';

  @override
  String get tip5 =>
      '5. Multitâche : Menu → Win+Tab, ←/→ pour changer, OK pour valider ; F1/F2/F3 = agent accepter/refuser/nouvelle session.';

  @override
  String get tip6 =>
      '6. Compression : PTT+Vol− court = plein écran / long = WeChat ; PTT+Vol+ court = fenêtre / long = Outil Capture.';

  @override
  String get aboutTitle => 'À propos';

  @override
  String get aboutBody =>
      'Compagnon VibeMic 0.1.0 · audio BLE ESP32-C3 + touches HID';

  @override
  String get editAction => 'Modifier l’action';

  @override
  String get clear => 'Effacer';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get customShortcutHint => 'Raccourci (ex. control+c ou alt+f4)';

  @override
  String get customAppHint => 'Id d’app ou exe (ex. wechat / chrome)';

  @override
  String get catBasic => 'Touches de base';

  @override
  String get catEditing => 'Édition';

  @override
  String get catMedia => 'Système et médias';

  @override
  String get catAgent => 'Cursor / Codex';

  @override
  String get catApps => 'Ouvrir des apps';

  @override
  String get catCustom => 'Personnalisé';

  @override
  String get actionNone => 'Aucun';

  @override
  String get actionKeyShortcut => 'Raccourci personnalisé';

  @override
  String get actionHoldShortcut => 'Maintenir le raccourci';

  @override
  String get actionOpenApp => 'Ouvrir une app…';

  @override
  String get actionCombination => 'Combinaison';

  @override
  String get actionMediaPlayPause => 'Lecture/Pause';

  @override
  String get actionVolumeUp => 'Volume +';

  @override
  String get actionVolumeDown => 'Volume −';

  @override
  String get actionMute => 'Muet';

  @override
  String get actionMediaNext => 'Piste suivante';

  @override
  String get actionMediaPrev => 'Piste précédente';

  @override
  String get actionTaskView => 'Vue des tâches (Win+Tab)';

  @override
  String get actionScreenshotFull => 'Capture plein écran (PrtSc)';

  @override
  String get actionScreenshotWindow => 'Fenêtre active (Alt+PrtSc)';

  @override
  String get actionScreenshotWechat => 'Capture WeChat (Alt+A)';

  @override
  String get actionScreenshotSnip => 'Outil Capture (Win+Shift+S)';

  @override
  String get actionEscape => 'Échap';

  @override
  String get actionEnter => 'Entrée / OK';

  @override
  String get actionCopy => 'Copier';

  @override
  String get actionPaste => 'Coller';

  @override
  String get actionCut => 'Couper';

  @override
  String get actionSelectAll => 'Tout sélectionner';

  @override
  String get actionUndo => 'Annuler';

  @override
  String get actionRedo => 'Rétablir';

  @override
  String get actionFind => 'Rechercher';

  @override
  String get actionSave => 'Enregistrer';

  @override
  String get actionCloseWindow => 'Fermer la fenêtre';

  @override
  String get actionNewTab => 'Nouvel onglet';

  @override
  String get actionPrevTab => 'Onglet précédent';

  @override
  String get actionNextTab => 'Onglet suivant';

  @override
  String get actionArrowUp => '↑ (maintenable)';

  @override
  String get actionArrowDown => '↓ (maintenable)';

  @override
  String get actionArrowLeft => '← (maintenable)';

  @override
  String get actionArrowRight => '→ (maintenable)';

  @override
  String get actionPageUp => 'Page Up';

  @override
  String get actionPageDown => 'Page Down';

  @override
  String get actionHome => 'Home';

  @override
  String get actionEnd => 'End';

  @override
  String get actionDelete => 'Suppr';

  @override
  String get actionBackspace => 'Retour arrière';

  @override
  String get actionAgentAccept => 'Agent accepter (Ctrl+Entrée)';

  @override
  String get actionAgentReject => 'Agent refuser (Échap)';

  @override
  String get actionAgentNewSession => 'Agent nouvelle session (Ctrl+L)';

  @override
  String get actionOpenWeChat => 'Ouvrir WeChat';

  @override
  String get actionOpenCursor => 'Ouvrir Cursor';

  @override
  String get actionOpenCodex => 'Ouvrir Codex / ChatGPT';

  @override
  String get actionOpenChrome => 'Ouvrir Chrome';

  @override
  String get actionOpenEdge => 'Ouvrir Edge';

  @override
  String get actionOpenNotepad => 'Ouvrir le Bloc-notes';

  @override
  String get actionOpenExplorer => 'Ouvrir l’Explorateur';

  @override
  String descShortcut(String keys) {
    return 'Raccourci : $keys';
  }

  @override
  String descHold(String keys) {
    return 'Maintenir : $keys';
  }

  @override
  String descOpen(String app) {
    return 'Ouvrir : $app';
  }

  @override
  String get descCombinationEmpty => 'Combinaison (vide)';

  @override
  String descCombination(String steps) {
    return 'Combo : $steps';
  }

  @override
  String get modNone => 'Aucun (micro virtuel seulement)';

  @override
  String get modFn => 'Fn / Globe (macOS)';

  @override
  String get modLeftControl => 'Ctrl gauche';

  @override
  String get modRightControl => 'Ctrl droit';

  @override
  String get modLeftAlt => 'Alt gauche';

  @override
  String get modRightAlt => 'Alt droit';

  @override
  String get modLeftMeta => 'Win / Cmd';

  @override
  String get modRightMeta => 'Win / Cmd droit';

  @override
  String get modCtrlWin => 'Ctrl + Win (IME WeChat)';

  @override
  String get keyUp => 'Haut';

  @override
  String get keyDown => 'Bas';

  @override
  String get keyLeft => 'Gauche';

  @override
  String get keyRight => 'Droite';

  @override
  String get keyOk => 'OK';

  @override
  String get keyVolUp => 'Volume +';

  @override
  String get keyVolDown => 'Volume −';

  @override
  String get keyBack => 'Retour';

  @override
  String get keyHome => 'Accueil';

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
  String get keySqueezeVolDown => 'Compression PTT+Vol−';

  @override
  String get keySqueezeVolUp => 'Compression PTT+Vol+';

  @override
  String get keyShortVolUp => 'Vol+';

  @override
  String get keyShortVolDown => 'Vol−';

  @override
  String get keyShortSqueezeVolUp => '⊕+';

  @override
  String get keyShortSqueezeVolDown => '⊕−';

  @override
  String get statusIdle => 'Inactif';

  @override
  String get statusCheckingBluetooth => 'Vérification du Bluetooth…';

  @override
  String get statusUnsupported => 'Bluetooth non pris en charge sur ce PC';

  @override
  String get statusKnownConnecting => 'Appareil connu trouvé, connexion…';

  @override
  String statusScanning(int seconds) {
    return 'Scan ${seconds}s…';
  }

  @override
  String statusScanningSeen(int count) {
    return 'Scan… $count appareil(s) vu(s)';
  }

  @override
  String get statusNoDevices =>
      '0 appareil trouvé. Vérifiez le Bluetooth Windows, ou confirmez l’annonce avec nRF Connect.';

  @override
  String statusNotFound(int count, String sample) {
    return 'VibeMic introuvable dans $count annonces. Ex. : $sample';
  }

  @override
  String get statusFoundConnecting => 'VibeMic trouvé, connexion…';

  @override
  String get statusAdapterTimeout =>
      'Délai d’attente de l’adaptateur Bluetooth';

  @override
  String statusScanFailed(String error) {
    return 'Échec du scan : $error';
  }

  @override
  String statusConnecting(String name) {
    return 'Connexion à $name…';
  }

  @override
  String statusConnectFailed(String error) {
    return 'Échec de connexion : $error — dissociez sous Windows, appuyez sur RST, puis réessayez';
  }

  @override
  String get statusDisconnected => 'Déconnecté';

  @override
  String get statusMissingGatt => 'Caractéristiques GATT VibeMic manquantes';

  @override
  String get statusConnectedReady => 'Connecté — maintenez PTT pour parler';

  @override
  String get statusReconnecting => 'Reconnexion…';

  @override
  String get statusNotConnected => 'Non connecté';

  @override
  String statusTestTone(int ms) {
    return 'Tonalité de test ${ms}ms…';
  }

  @override
  String get statusDeviceNack => 'NACK de l’appareil';

  @override
  String get statusPttStreaming => 'Diffusion PTT…';

  @override
  String get btnEventUp => 'relâché';

  @override
  String get btnEventDown => 'enfoncé';

  @override
  String get btnEventClick => 'clic';

  @override
  String get btnEventDouble => 'double';

  @override
  String get btnEventLong => 'long';

  @override
  String lastKeyDetail(int id, String event) {
    return 'Touche $id · $event';
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
