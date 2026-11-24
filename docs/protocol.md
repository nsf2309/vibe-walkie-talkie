# VibeMic BLE Protocol v0.1

Custom BLE peripheral protocol for the VibeMic hardware + Flutter companion.
Does **not** emulate Xiaomi ATVV UUIDs or VID/PID.

## Device identity

| Field | Value |
| --- | --- |
| Advertised name | `VibeMic` |
| Appearance | HID Generic (0x03C0) optional |
| USB/BLE HID VID | `0xVIPM` → use `0xVIP0` placeholder `0x56D0` (VibeMic) |
| USB/BLE HID PID | `0x0001` |

Host apps filter by: advertised name prefix `VibeMic` **or** presence of Vendor Audio service UUID below.

## GATT services

### 1. HID Service (0x1812)

Standard BLE HID. Reports:

| Report | ID | Type | Description |
| --- | --- | --- | --- |
| Keyboard | 1 | Input | 8-byte boot-compatible keyboard report |
| Consumer | 2 | Input | 2-byte consumer control (volume, etc.) |
| Mouse | 3 | Input | 4-byte relative mouse (touchpad phase 2) |
| Voice key | — | via Keyboard | Usage `F20` (0x6F) while PTT held; released on PTT up |

Firmware also notifies PTT on the Vendor Control characteristic so the companion does not rely solely on OS HID for voice session edges.

### 2. Battery Service (0x180F)

Optional. Battery Level characteristic (0x2A19).

### 3. Vendor Audio Service

Base UUID namespace (128-bit):

```
Service:  6b1d0001-7c2e-4a9f-9b10-vibemic000001  →  6b1d0001-7c2e-4a9f-9b10-a1b2c3d4e5f0
TX/Cmd:   6b1d0002-7c2e-4a9f-9b10-a1b2c3d4e5f0   (Write)  host → device commands
Audio:    6b1d0003-7c2e-4a9f-9b10-a1b2c3d4e5f0   (Notify) device → host ADPCM frames
Control:  6b1d0004-7c2e-4a9f-9b10-a1b2c3d4e5f0   (Notify+Write) session / caps / PTT
```

Canonical hex (no vibemic mnemonic):

| Role | UUID |
| --- | --- |
| Service | `6b1d0001-7c2e-4a9f-9b10-a1b2c3d4e5f0` |
| Command (Write) | `6b1d0002-7c2e-4a9f-9b10-a1b2c3d4e5f0` |
| Audio (Notify) | `6b1d0003-7c2e-4a9f-9b10-a1b2c3d4e5f0` |
| Control (Notify+Write) | `6b1d0004-7c2e-4a9f-9b10-a1b2c3d4e5f0` |

## Capability handshake

After connect + CCCD subscribe on Audio + Control:

1. Host writes Command `0x01 GET_CAPS`.
2. Device notifies Control with:

```
offset  size  field
0       1     opcode = 0x81 CAPS
1       1     version = 0x01
2       1     flags
              button_count: 16 (D-pad/OK/vol/back/home/menu/F1-F6; PTT separate)
              bit0: has_mic
              bit1: has_touchpad
              bit2: test_tone
              bit3: adpcm_ima
3       2     sample_rate_hz LE (16000)
4       1     channels (1)
5       1     frame_samples (128 PCM samples → 64 ADPCM bytes)
6       1     button_count
7       1     reserved
```

3. Host writes Command `0x02 SET_MODE` with mode byte:
   - `0x00` idle
   - `0x01` live mic (PTT gated)
   - `0x02` test tone (1 s bursts allowed without PTT)

Only 16 kHz mono IMA/DVI ADPCM is supported in v0.1. Other rates → device NACKs.

## PTT / voice session state machine

```
        release / disconnect / SET_MODE idle
     ┌──────────────────────────────────────┐
     ▼                                      │
  IDLE ──PTT down──► STREAMING ──PTT up─────┘
     │                   │
     │                   └── audio Notify frames
     └── Control: PTT_STATE
```

### Control Notify opcodes

| Opcode | Name | Payload |
| --- | --- | --- |
| `0x81` | CAPS | see above |
| `0x82` | PTT_STATE | `1` byte: `0` up, `1` down |
| `0x83` | BUTTON | `button_id` u8, `event` u8 (`0` up, `1` down, `2` click, `3` double, `4` long) |
| `0x84` | NACK | reason u8 |
| `0x85` | SYNC | resets ADPCM predictor (sent before first audio frame of a session) |

### Command Write opcodes

| Opcode | Name | Payload |
| --- | --- | --- |
| `0x01` | GET_CAPS | none |
| `0x02` | SET_MODE | mode u8 |
| `0x03` | SET_TOUCHPAD | `0` off / `1` on / `2` audio_priority (reduce mouse Hz while streaming) |
| `0x04` | REQUEST_TEST_TONE | duration_ms u16 LE (max 2000) |

## Audio frame format (Notify on Audio char)

Each notification is one ADPCM frame:

```
offset  size  field
0       1     seq (wrapping)
1       1     flags
              bit0: session_start (first frame after PTT)
              bit1: session_end (optional empty/last)
              bit2: sync (predictor reset applied before this frame)
2       N     IMA ADPCM nibbles, high-nibble-first, N = frame_samples/2 (64 for 128 samples)
```

- PCM: signed 16-bit, 16 kHz, mono
- Codec: IMA/DVI ADPCM, standard step table
- Host accumulates by `seq`; gaps → request new session or tolerate drop
- On `PTT_STATE=1` host starts virtual-mic session + optional modifier key down
- On `PTT_STATE=0` host drains queue then modifier key up

Bandwidth (approx): 16e3 samples/s ÷ 2 = 8 kB/s ADPCM + headers ≈ well within BLE 2M PHY with conn interval ≤ 15 ms.

## HID button map (default firmware)

| Physical | HID / Control |
| --- | --- |
| Voice (PTT) | Keyboard F20 held + Control PTT_STATE |
| Key 1 | BUTTON id=1 |
| Key 2 | BUTTON id=2 |
| Key 3 | BUTTON id=3 |
| Key 4 | BUTTON id=4 |
| Vol+ / Vol− | Consumer Volume Increment/Decrement (optional) |

Host maps BUTTON events to macros; complex click/double/long may be classified on device (debounce) or host. v0.1 device sends raw down/up; host classifies gestures.

## Touchpad (phase 2)

- HID Mouse report ID 3: buttons(1) + dx(1) + dy(1) + wheel(1)
- While `SET_TOUCHPAD=audio_priority` and STREAMING: mouse report rate capped (e.g. 20 Hz)
- External controller (e.g. GT911) over I2C; C3 has no on-die touch

## Linux notes

See [linux.md](linux.md): BlueZ central via Flutter, PipeWire null sink as virtual mic.

## Versioning

`CAPS.version` increments on breaking changes. Hosts must ignore unknown opcodes.
