/// Structured BLE status so the UI can localize without hardcoding language.
enum BleStatusCode {
  idle,
  checkingBluetooth,
  unsupported,
  knownConnecting,
  scanning,
  scanningSeen,
  noDevices,
  notFound,
  foundConnecting,
  adapterTimeout,
  scanFailed,
  connecting,
  connectFailed,
  disconnected,
  missingGatt,
  connectedReady,
  reconnecting,
  notConnected,
  testTone,
  deviceNack,
  pttStreaming,
}

class BleUiStatus {
  const BleUiStatus(this.code, {this.n, this.s});

  final BleStatusCode code;
  final int? n;
  final String? s;

  static const idle = BleUiStatus(BleStatusCode.idle);
  static const checkingBluetooth = BleUiStatus(BleStatusCode.checkingBluetooth);
  static const unsupported = BleUiStatus(BleStatusCode.unsupported);
  static const knownConnecting = BleUiStatus(BleStatusCode.knownConnecting);
  static const foundConnecting = BleUiStatus(BleStatusCode.foundConnecting);
  static const adapterTimeout = BleUiStatus(BleStatusCode.adapterTimeout);
  static const disconnected = BleUiStatus(BleStatusCode.disconnected);
  static const missingGatt = BleUiStatus(BleStatusCode.missingGatt);
  static const connectedReady = BleUiStatus(BleStatusCode.connectedReady);
  static const reconnecting = BleUiStatus(BleStatusCode.reconnecting);
  static const notConnected = BleUiStatus(BleStatusCode.notConnected);
  static const deviceNack = BleUiStatus(BleStatusCode.deviceNack);
  static const pttStreaming = BleUiStatus(BleStatusCode.pttStreaming);
  static const noDevices = BleUiStatus(BleStatusCode.noDevices);

  bool get isScanning =>
      code == BleStatusCode.scanning || code == BleStatusCode.scanningSeen;
}

class LastButtonEvent {
  const LastButtonEvent(this.id, this.event);
  final int id;
  final int event;
}
