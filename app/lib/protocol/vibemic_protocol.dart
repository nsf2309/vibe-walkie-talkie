/// Mirrors `shared/vibemic_protocol.h` and `docs/protocol.md`.
library;

const String kVibeMicName = 'VibeMic';
const int kProtoVersion = 0x01;
const int kSampleRateHz = 16000;
const int kChannels = 1;
const int kFrameSamples = 128;
const int kAdpcmBytes = kFrameSamples ~/ 2;
const int kAudioHdrSize = 2;
const int kAudioPktSize = kAudioHdrSize + kAdpcmBytes;

const String kUuidService = '6b1d0001-7c2e-4a9f-9b10-a1b2c3d4e5f0';
const String kUuidCmd = '6b1d0002-7c2e-4a9f-9b10-a1b2c3d4e5f0';
const String kUuidAudio = '6b1d0003-7c2e-4a9f-9b10-a1b2c3d4e5f0';
const String kUuidCtrl = '6b1d0004-7c2e-4a9f-9b10-a1b2c3d4e5f0';

const int cmdGetCaps = 0x01;
const int cmdSetMode = 0x02;
const int cmdSetTouchpad = 0x03;
const int cmdTestTone = 0x04;

const int modeIdle = 0x00;
const int modeLive = 0x01;
const int modeTest = 0x02;

const int tpOff = 0x00;
const int tpOn = 0x01;
const int tpAudioPriority = 0x02;

const int ctrlCaps = 0x81;
const int ctrlPttState = 0x82;
const int ctrlButton = 0x83;
const int ctrlNack = 0x84;
const int ctrlSync = 0x85;

const int btnUp = 0;
const int btnDown = 1;
const int btnClick = 2;
const int btnDouble = 3;
const int btnLong = 4;

const int flagHasMic = 1 << 0;
const int flagHasTouchpad = 1 << 1;
const int flagTestTone = 1 << 2;
const int flagAdpcmIma = 1 << 3;

const int aflagSessionStart = 1 << 0;
const int aflagSessionEnd = 1 << 1;
const int aflagSync = 1 << 2;

class DeviceCaps {
  DeviceCaps({
    required this.version,
    required this.flags,
    required this.sampleRateHz,
    required this.channels,
    required this.frameSamples,
    required this.buttonCount,
  });

  final int version;
  final int flags;
  final int sampleRateHz;
  final int channels;
  final int frameSamples;
  final int buttonCount;

  bool get hasMic => (flags & flagHasMic) != 0;
  bool get hasTouchpad => (flags & flagHasTouchpad) != 0;

  static DeviceCaps? tryParse(List<int> p) {
    if (p.length < 8 || p[0] != ctrlCaps) return null;
    final rate = p[3] | (p[4] << 8);
    return DeviceCaps(
      version: p[1],
      flags: p[2],
      sampleRateHz: rate,
      channels: p[5],
      frameSamples: p[6],
      buttonCount: p[7],
    );
  }
}
