# INMP441 接线（ESP32-C3）

数字 MEMS 麦，I2S Philips，左声道。

## 引脚

| INMP441 | ESP32-C3 | 说明 |
| --- | --- | --- |
| VDD | 3.3V | 不要接 5V |
| GND | GND | |
| SCK | **GPIO10** (`PIN_I2S_CLK`) | 位时钟 BCLK |
| WS | **GPIO20** (`PIN_I2S_WS`) | 左右时钟 LRCLK |
| SD | **GPIO2** (`PIN_I2S_DIN`) | 数据 |
| L/R | **GND** | 固定左声道（接 3.3V 则改右声道并改固件 `slot_mask`） |

Classic ESP32 默认：BCLK=GPIO0，WS=GPIO14，DIN=GPIO35。

## 固件行为

- 启动时打开 I2S RX（`CONFIG_VIBEMIC_USE_INMP441=y`）。
- 麦未焊 / 无能量时：PTT 仍播 440Hz 测试音（`CONFIG_VIBEMIC_MIC_TONE_FALLBACK=y`）。
- 首次采到非静音帧后：自动切到真实麦，串口打印 `mic energy detected`。
- 伴侣「1s test tone」仍可强制测试音。

## 到货验收

1. 按上表接线，RST 板子。
2. 监视器应有 `INMP441 I2S RX ready`。
3. 伴侣连接后对麦说话并按住 PTT：电平条应随语音变化；串口出现 `mic energy detected`。
4. 若一直只有测试音：查 L/R、WS、供电；少数模块左右相反，把 L/R 改接 3.3V 试一次。
