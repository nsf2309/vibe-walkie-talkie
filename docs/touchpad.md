# Touchpad (phase 2)

## Hardware

ESP32-C3 has **no** on-die capacitive touch. Use an external controller, e.g.:

| Part | Bus | Notes |
| --- | --- | --- |
| GT911 | I2C | Common in cheap capacitive panels |
| CST816 | I2C | Smaller round/rect modules |

Default firmware pins: see `firmware/README.md` (`PIN_I2C_SDA/SCL`, `PIN_TP_IRQ`).

## Firmware

- `vibemic_touchpad.c` probes presence (currently stub → `present=false`).
- HID mouse report ID 3 is already in the report map.
- Host command `SET_TOUCHPAD`:
  - `0` off
  - `1` on
  - `2` audio_priority — while PTT streaming, mouse reports capped (~20 Hz)

## Host

Companion enables `tpAudioPriority` after connect. Caps bit `has_touchpad` reflects firmware probe.

## Bring-up checklist

1. Wire I2C + IRQ, set `s_present = true` after ACK from controller.
2. Map absolute touch → relative dx/dy with simple delta filter.
3. Verify BLE: move pad without PTT (high rate), then with PTT (throttled) while watching audio glitches.
