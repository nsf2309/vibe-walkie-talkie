# VibeMic on Linux (phase 2)

## BLE

- Stack: BlueZ via `flutter_blue_plus` (Linux endorsed implementation).
- User must be in `bluetooth` group; some distros need `CAP_NET_ADMIN` or D-Bus permissions.
- Scan/filter for name `VibeMic` or service UUID `6b1d0001-7c2e-4a9f-9b10-a1b2c3d4e5f0`.

## Virtual microphone (PipeWire)

Create a null sink + remap source so apps can pick “VibeMic Loopback”:

```bash
pw-cli create-node adapter '{
  factory.name=support.null-audio-sink
  node.name=VibeMicLoopback
  media.class=Audio/Sink
  audio.position=[MONO]
  monitor.channel-volumes=true
}'
```

Or PulseAudio-compatible:

```bash
pactl load-module module-null-sink sink_name=VibeMicLoopback sink_properties=device.description=VibeMicLoopback
# Monitor source: VibeMicLoopback.monitor
```

The Flutter Linux audio plugin writes 16 kHz mono float/PCM to the sink; speech apps select the monitor as input.

## Key injection

- Prefer `ydotool` or `uinput` (requires permissions).
- Accessibility portals vary by desktop (GNOME/KDE); document setup in-app.

## Status

Protocol and Flutter UI are shared. Linux audio + inject plugins ship as stubs that detect `Platform.isLinux` and use PipeWire/`uinput` when available.
