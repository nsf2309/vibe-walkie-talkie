// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'VibeMic';

  @override
  String get navConnection => 'Conexión y voz';

  @override
  String get navMapping => 'Asignación de teclas';

  @override
  String get navGeneral => 'General';

  @override
  String get connectionTitle => 'Conexión y voz';

  @override
  String get connectionHint =>
      'Mantén el PTT lateral para hablar; suelta para parar. No emparejes VibeMic en Bluetooth de Windows.';

  @override
  String get connected => 'Conectado a VibeMic';

  @override
  String get notConnected => 'No conectado';

  @override
  String get streaming => 'Transmitiendo';

  @override
  String get idle => 'Inactivo';

  @override
  String audioFrames(int count) {
    return 'Fotogramas de audio $count';
  }

  @override
  String lastKey(String event) {
    return 'Última tecla: $event';
  }

  @override
  String get scanConnect => 'Escanear y conectar';

  @override
  String get disconnect => 'Desconectar';

  @override
  String get testTone => 'Tono de 1 s';

  @override
  String get softPtt => 'Mantener PTT software';

  @override
  String get softPttActive => 'PTT software…';

  @override
  String get virtualMic => 'Micrófono virtual';

  @override
  String get virtualMicHint =>
      'El compañero escribe al dispositivo de reproducción de abajo. En el IME elige el CABLE Output correspondiente como micrófono.';

  @override
  String get selectLoopback => 'Elegir CABLE Input / bucle';

  @override
  String get refreshDevices => 'Actualizar dispositivos';

  @override
  String get voiceModifier => 'Modificador de voz';

  @override
  String get voiceModifierHint =>
      'Se inyecta al mantener PTT para activar la voz del IME (WeChat IME: Ctrl+Win por defecto).';

  @override
  String gain(String value) {
    return 'Ganancia $value×';
  }

  @override
  String deviceCaps(int version, int rate, int buttons, String touchpad) {
    return 'Dispositivo: protocolo v$version · $rate Hz · $buttons teclas · panel=$touchpad';
  }

  @override
  String get yes => 'sí';

  @override
  String get no => 'no';

  @override
  String get scanDebug => 'Depuración de escaneo';

  @override
  String get empty => '(vacío)';

  @override
  String get mappingTitle => 'Asignación de teclas';

  @override
  String get mappingHint =>
      'Diseño: PTT a la izquierda, volumen a la derecha; frente F4–F6, cruceta+OK, Inicio/Atrás/Menú, F1–F3. Apretón: PTT+volumen; corto/largo para capturas, etc.';

  @override
  String get enableMapping => 'Activar asignación';

  @override
  String get leftSide => 'Lado izquierdo';

  @override
  String get rightSide => 'Lado derecho';

  @override
  String get pttVoice => 'PTT';

  @override
  String liveEvent(String event) {
    return 'En vivo: $event';
  }

  @override
  String keyId(int id) {
    return 'ID $id';
  }

  @override
  String get squeezeHint =>
      'Apretón: mantén el PTT izquierdo con la tecla de volumen correspondiente. Corto = clic; ≥0,6 s = largo. No hay streaming de voz durante el apretón.';

  @override
  String get actionHold => 'Mantener (recomendado para flechas)';

  @override
  String get actionClick => 'Clic';

  @override
  String get actionDouble => 'Doble';

  @override
  String get actionLong => 'Pulsación larga';

  @override
  String get actionSqueezeShort => 'Apretón corto';

  @override
  String get actionSqueezeLong => 'Apretón largo';

  @override
  String get resetDefaults => 'Restaurar valores predeterminados';

  @override
  String get generalTitle => 'General';

  @override
  String get generalHint =>
      'Preferencias locales de conexión, teclas y ajustes. Funciones avanzadas se pueden añadir después.';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Predeterminado del sistema';

  @override
  String get autoScan => 'Escanear al iniciar';

  @override
  String get autoScanSub => 'Buscar VibeMic automáticamente al abrir';

  @override
  String get autoReconnect => 'Reconexión automática';

  @override
  String get autoReconnectSub =>
      'Volver a escanear ~3 s tras una desconexión inesperada';

  @override
  String get showScanDebug => 'Mostrar depuración de escaneo';

  @override
  String get showScanDebugSub => 'Listar anuncios BLE en la página de Conexión';

  @override
  String get tipsTitle => 'Consejos';

  @override
  String get tip1 =>
      '1. Instala VB-Audio Virtual Cable; CABLE Input aquí y CABLE Output en el IME.';

  @override
  String get tip2 =>
      '2. No conectes VibeMic en Bluetooth de Windows; escanea solo en esta app.';

  @override
  String get tip3 =>
      '3. Cableado INMP441: docs/mic-inmp441.md. Sin micrófono, el PTT reproduce un tono de prueba.';

  @override
  String get tip4 => '4. Matriz de teclas: docs/keys-matrix.md.';

  @override
  String get tip5 =>
      '5. Multitarea: Menú → Win+Tab, ←/→ para cambiar, OK para confirmar; F1/F2/F3 = agente aceptar/rechazar/nueva sesión.';

  @override
  String get tip6 =>
      '6. Apretón: PTT+Vol− corto = pantalla completa / largo = WeChat; PTT+Vol+ corto = ventana / largo = Recortes.';

  @override
  String get aboutTitle => 'Acerca de';

  @override
  String get aboutBody =>
      'Compañero VibeMic 0.1.0 · audio BLE ESP32-C3 + teclas HID';

  @override
  String get editAction => 'Editar acción';

  @override
  String get clear => 'Borrar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get customShortcutHint => 'Atajo (p. ej. control+c o alt+f4)';

  @override
  String get customAppHint => 'Id de app o exe (p. ej. wechat / chrome)';

  @override
  String get catBasic => 'Teclas básicas';

  @override
  String get catEditing => 'Edición';

  @override
  String get catMedia => 'Sistema y medios';

  @override
  String get catAgent => 'Cursor / Codex';

  @override
  String get catApps => 'Abrir apps';

  @override
  String get catCustom => 'Personalizado';

  @override
  String get actionNone => 'Ninguna';

  @override
  String get actionKeyShortcut => 'Atajo personalizado';

  @override
  String get actionHoldShortcut => 'Mantener atajo';

  @override
  String get actionOpenApp => 'Abrir app…';

  @override
  String get actionCombination => 'Combinación';

  @override
  String get actionMediaPlayPause => 'Reproducir/Pausa';

  @override
  String get actionVolumeUp => 'Volumen +';

  @override
  String get actionVolumeDown => 'Volumen −';

  @override
  String get actionMute => 'Silencio';

  @override
  String get actionMediaNext => 'Siguiente pista';

  @override
  String get actionMediaPrev => 'Pista anterior';

  @override
  String get actionTaskView => 'Vista de tareas (Win+Tab)';

  @override
  String get actionScreenshotFull => 'Captura de pantalla completa (PrtSc)';

  @override
  String get actionScreenshotWindow => 'Ventana activa (Alt+PrtSc)';

  @override
  String get actionScreenshotWechat => 'Captura WeChat (Alt+A)';

  @override
  String get actionScreenshotSnip => 'Recortes (Win+Shift+S)';

  @override
  String get actionEscape => 'Esc';

  @override
  String get actionEnter => 'Intro / OK';

  @override
  String get actionCopy => 'Copiar';

  @override
  String get actionPaste => 'Pegar';

  @override
  String get actionCut => 'Cortar';

  @override
  String get actionSelectAll => 'Seleccionar todo';

  @override
  String get actionUndo => 'Deshacer';

  @override
  String get actionRedo => 'Rehacer';

  @override
  String get actionFind => 'Buscar';

  @override
  String get actionSave => 'Guardar';

  @override
  String get actionCloseWindow => 'Cerrar ventana';

  @override
  String get actionNewTab => 'Nueva pestaña';

  @override
  String get actionPrevTab => 'Pestaña anterior';

  @override
  String get actionNextTab => 'Pestaña siguiente';

  @override
  String get actionArrowUp => '↑ (mantenible)';

  @override
  String get actionArrowDown => '↓ (mantenible)';

  @override
  String get actionArrowLeft => '← (mantenible)';

  @override
  String get actionArrowRight => '→ (mantenible)';

  @override
  String get actionPageUp => 'Re Pág';

  @override
  String get actionPageDown => 'Av Pág';

  @override
  String get actionHome => 'Inicio';

  @override
  String get actionEnd => 'Fin';

  @override
  String get actionDelete => 'Supr';

  @override
  String get actionBackspace => 'Retroceso';

  @override
  String get actionAgentAccept => 'Agente aceptar (Ctrl+Intro)';

  @override
  String get actionAgentReject => 'Agente rechazar (Esc)';

  @override
  String get actionAgentNewSession => 'Agente nueva sesión (Ctrl+L)';

  @override
  String get actionOpenWeChat => 'Abrir WeChat';

  @override
  String get actionOpenCursor => 'Abrir Cursor';

  @override
  String get actionOpenCodex => 'Abrir Codex / ChatGPT';

  @override
  String get actionOpenChrome => 'Abrir Chrome';

  @override
  String get actionOpenEdge => 'Abrir Edge';

  @override
  String get actionOpenNotepad => 'Abrir Bloc de notas';

  @override
  String get actionOpenExplorer => 'Abrir Explorador';

  @override
  String descShortcut(String keys) {
    return 'Atajo: $keys';
  }

  @override
  String descHold(String keys) {
    return 'Mantener: $keys';
  }

  @override
  String descOpen(String app) {
    return 'Abrir: $app';
  }

  @override
  String get descCombinationEmpty => 'Combinación (vacía)';

  @override
  String descCombination(String steps) {
    return 'Combo: $steps';
  }

  @override
  String get modNone => 'Ninguno (solo mic virtual)';

  @override
  String get modFn => 'Fn / Globo (macOS)';

  @override
  String get modLeftControl => 'Ctrl izquierdo';

  @override
  String get modRightControl => 'Ctrl derecho';

  @override
  String get modLeftAlt => 'Alt izquierdo';

  @override
  String get modRightAlt => 'Alt derecho';

  @override
  String get modLeftMeta => 'Win / Cmd';

  @override
  String get modRightMeta => 'Win / Cmd derecho';

  @override
  String get modCtrlWin => 'Ctrl + Win (IME WeChat)';

  @override
  String get keyUp => 'Arriba';

  @override
  String get keyDown => 'Abajo';

  @override
  String get keyLeft => 'Izquierda';

  @override
  String get keyRight => 'Derecha';

  @override
  String get keyOk => 'OK';

  @override
  String get keyVolUp => 'Volumen +';

  @override
  String get keyVolDown => 'Volumen −';

  @override
  String get keyBack => 'Atrás';

  @override
  String get keyHome => 'Inicio';

  @override
  String get keyMenu => 'Menú';

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
  String get keySqueezeVolDown => 'Apretón PTT+Vol−';

  @override
  String get keySqueezeVolUp => 'Apretón PTT+Vol+';

  @override
  String get keyShortVolUp => 'Vol+';

  @override
  String get keyShortVolDown => 'Vol−';

  @override
  String get keyShortSqueezeVolUp => '⊕+';

  @override
  String get keyShortSqueezeVolDown => '⊕−';

  @override
  String get statusIdle => 'Inactivo';

  @override
  String get statusCheckingBluetooth => 'Comprobando Bluetooth…';

  @override
  String get statusUnsupported => 'Bluetooth no compatible en este PC';

  @override
  String get statusKnownConnecting =>
      'Dispositivo conocido encontrado, conectando…';

  @override
  String statusScanning(int seconds) {
    return 'Escaneando ${seconds}s…';
  }

  @override
  String statusScanningSeen(int count) {
    return 'Escaneando… $count dispositivo(s) visto(s)';
  }

  @override
  String get statusNoDevices =>
      '0 dispositivos. Revisa el Bluetooth de Windows o confirma el anuncio con nRF Connect.';

  @override
  String statusNotFound(int count, String sample) {
    return 'VibeMic no está en $count anuncios. Ej.: $sample';
  }

  @override
  String get statusFoundConnecting => 'VibeMic encontrado, conectando…';

  @override
  String get statusAdapterTimeout => 'Tiempo de espera del adaptador Bluetooth';

  @override
  String statusScanFailed(String error) {
    return 'Error de escaneo: $error';
  }

  @override
  String statusConnecting(String name) {
    return 'Conectando a $name…';
  }

  @override
  String statusConnectFailed(String error) {
    return 'Error de conexión: $error — desvincula en Windows, pulsa RST y reintenta';
  }

  @override
  String get statusDisconnected => 'Desconectado';

  @override
  String get statusMissingGatt => 'Faltan características GATT de VibeMic';

  @override
  String get statusConnectedReady => 'Conectado — mantén PTT para hablar';

  @override
  String get statusReconnecting => 'Reconectando…';

  @override
  String get statusNotConnected => 'No conectado';

  @override
  String statusTestTone(int ms) {
    return 'Tono de prueba ${ms}ms…';
  }

  @override
  String get statusDeviceNack => 'NACK del dispositivo';

  @override
  String get statusPttStreaming => 'PTT en streaming…';

  @override
  String get btnEventUp => 'soltar';

  @override
  String get btnEventDown => 'pulsar';

  @override
  String get btnEventClick => 'clic';

  @override
  String get btnEventDouble => 'doble';

  @override
  String get btnEventLong => 'largo';

  @override
  String lastKeyDetail(int id, String event) {
    return 'Tecla $id · $event';
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
