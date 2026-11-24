# VibeMic companion (Flutter)

Desktop host for the VibeMic BLE device: decode ADPCM, write virtual mic, inject voice modifiers, map macros.

## Run

```bash
flutter pub get
flutter run -d windows
# flutter run -d macos
# flutter run -d linux
```

Native MethodChannels:

| Channel | Purpose |
| --- | --- |
| `vibemic/audio` | list/select loopback, begin/end session, write Float32 PCM |
| `vibemic/input` | voiceBegin/End, tapShortcut, openApp |

Stubs are wired in `windows/runner`, `macos/Runner`, `linux/runner`. Full WASAPI/CoreAudio/PipeWire writers are the next hardware bring-up step; Dart already tolerates missing native audio by keeping session state for UI testing.

## Linux

See `../docs/linux.md`.
