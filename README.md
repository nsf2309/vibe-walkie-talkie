# VibeMic

Self-built BLE push-to-talk mic + macro pad (ESP32-C3) with a Flutter companion that **rewrites audio into a virtual microphone** (SayAll-style). Not a system HFP Bluetooth headset.

| Layer | Stack |
| --- | --- |
| Firmware | ESP-IDF, NimBLE, target **esp32c3** (classic **esp32** secondary) |
| Protocol | [`docs/protocol.md`](docs/protocol.md) |
| Desktop | Flutter (`app/`) — Windows / macOS first, Linux phase-2 |

## Quick start

### Firmware

```bash
cd firmware
idf.py set-target esp32c3   # or esp32
idf.py build flash monitor
```

Hold the PTT GPIO (see `firmware/README.md`) to stream 16 kHz IMA-ADPCM over vendor GATT. Without a wired mic, firmware sends a 440 Hz tone so the host path can be verified.

### Companion app

```bash
cd app
flutter pub get
flutter run -d windows    # or macos / linux
```

Install a loopback device first:

- **Windows:** [VB-Audio Virtual Cable](https://vb-audio.com/Cable/)
- **macOS:** [BlackHole](https://existential.audio/blackhole/)
- **Linux:** see [`docs/linux.md`](docs/linux.md)

In the speech app, select that loopback as the microphone. In VibeMic, pick the same device, connect, hold PTT.

## Layout

```
docs/           protocol + Linux notes
shared/         C header mirrored by Dart
firmware/       ESP-IDF project
app/            Flutter companion + platform channel stubs
```

## Status

- [x] BLE protocol v0.1
- [x] C3 firmware: HID + audio GATT + keys + touchpad stub
- [x] Flutter: scan/connect, ADPCM decode, virtual-mic channel, PTT inject, macros UI
- [x] Win/macOS/Linux native channel stubs
- [ ] Real PDM mic bring-up on your PCB
- [ ] WASAPI/CoreAudio/PipeWire full write path
- [ ] GT911 (or similar) touchpad hardware
