# VibeMic firmware (ESP-IDF)

Primary target: **ESP32-C3**. Classic ESP32 is a secondary `idf.py set-target esp32` build of the same sources.

## Build

```bash
cd firmware
idf.py set-target esp32c3   # or: esp32
idf.py build
idf.py -p COMx flash monitor
```

## Pins (override in `main/board_pins.h`)

| Function | ESP32-C3 | Classic ESP32 |
| --- | --- | --- |
| PTT（按住说话） | **GPIO3** | GPIO32 |
| Matrix ROW0–3 | **4,5,6,7** | 33,25,26,27 |
| Matrix COL0–4 | **0,21,11,12,13** | 12,13,14,15,16 |
| I2S BCLK (INMP441 SCK) | GPIO10 | GPIO0 |
| I2S WS (INMP441 WS) | GPIO20 | GPIO4 |
| I2S DIN (INMP441 SD) | GPIO2 | GPIO35 |
| Touchpad IRQ (phase 2) | GPIO1 | GPIO34 |
| Touchpad I2C SDA | GPIO8 | GPIO21 |
| Touchpad I2C SCL | GPIO9 | GPIO22 |

按键为 **4×5 矩阵** + 独立 PTT；产品布局为左侧 PTT、右侧音量、正面 F4–F6 / 方向+OK / Home·返回·菜单 / F1–F3。支持 **PTT+音量捏合** 截图手势。详见 [`../docs/keys-matrix.md`](../docs/keys-matrix.md)。

麦克风接线见 [`../docs/mic-inmp441.md`](../docs/mic-inmp441.md)。

### 无按键板怎么测

1. 串口应看到 `advertising as VibeMic` 和 matrix 引脚日志。
2. **GPIO3 → GND**：`PTT down` / `PTT up`。
3. 短接某一 ROW 与 COL（如 GPIO4↔GPIO0）应看到对应 `button N event …`。
4. 伴侣「按键映射」页可看实时按键并改动作。

麦未到货时，按住 PTT 仍会推 440Hz 测试音；焊上 INMP441 并采到能量后自动切真实麦。

## Features

- BLE name `VibeMic`
- HID keyboard (F20 while PTT) + consumer + mouse report (touchpad stub)
- Vendor GATT audio + control (see `../docs/protocol.md`)
