/// Logical button IDs — mirrors `shared/vibemic_buttons.h`. PTT is separate.
library;

const int kButtonCount = 16;

const int keyUp = 1;
const int keyDown = 2;
const int keyLeft = 3;
const int keyRight = 4;
const int keyOk = 5;
const int keyVolUp = 6;
const int keyVolDown = 7;
const int keyBack = 8;
const int keyHome = 9;
const int keyMenu = 10;
const int keyF1 = 11;
const int keyF2 = 12;
const int keyF3 = 13;
const int keyF4 = 14;
const int keyF5 = 15;
const int keyF6 = 16;

class RemoteKeyInfo {
  const RemoteKeyInfo(this.id, this.label, this.shortLabel);
  final int id;
  final String label;
  final String shortLabel;
}

const List<RemoteKeyInfo> kRemoteKeys = [
  RemoteKeyInfo(keyUp, '上', '↑'),
  RemoteKeyInfo(keyDown, '下', '↓'),
  RemoteKeyInfo(keyLeft, '左', '←'),
  RemoteKeyInfo(keyRight, '右', '→'),
  RemoteKeyInfo(keyOk, '确认', 'OK'),
  RemoteKeyInfo(keyVolUp, '音量+', 'Vol+'),
  RemoteKeyInfo(keyVolDown, '音量−', 'Vol−'),
  RemoteKeyInfo(keyBack, '返回', 'Back'),
  RemoteKeyInfo(keyHome, 'Home', 'Home'),
  RemoteKeyInfo(keyMenu, '菜单', 'Menu'),
  RemoteKeyInfo(keyF1, '功能1', 'F1'),
  RemoteKeyInfo(keyF2, '功能2', 'F2'),
  RemoteKeyInfo(keyF3, '功能3', 'F3'),
  RemoteKeyInfo(keyF4, '功能4', 'F4'),
  RemoteKeyInfo(keyF5, '功能5', 'F5'),
  RemoteKeyInfo(keyF6, '功能6', 'F6'),
];

RemoteKeyInfo? remoteKeyById(int id) {
  for (final k in kRemoteKeys) {
    if (k.id == id) return k;
  }
  return null;
}
