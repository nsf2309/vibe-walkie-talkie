# 伴侣联调（Windows）

## 1. 重烧固件（测试音会自动停）

```powershell
cd c:\Code\A\VibeMic\firmware
idf.py build flash monitor
```

确认仍有 `advertising as VibeMic`。

## 2. （推荐）安装虚拟线缆

- [VB-Audio Virtual Cable](https://vb-audio.com/Cable/)
- 安装后在声音设置里应能看到 **CABLE Input**（播放设备）/ **CABLE Output**（录音设备）

## 3. 启动 Flutter 伴侣

```powershell
$env:PATH = "C:\Code\tools\flutter\bin;" + $env:PATH
cd c:\Code\A\VibeMic\app
flutter run -d windows
```

## 4. 验收

1. 点 **Scan & connect**，状态变为 `Connected — hold PTT to stream`，Caps 有数据。
2. 按住板子 **GPIO3 (PTT)**：电平条跳动，`Audio frames` 增加。
3. 点 **1s test tone**：约 1 秒电平后停。
4. 若已装 VB-Cable：下拉框选 CABLE；在「录音设备」或微信输入法里选 **CABLE Output** 作麦克风，按住 PTT 应能听到/识别测试音。
5. 按键宏：默认 Key1 静音 / Key2 播放暂停 / Key3 音量− / Key4 音量+；可在伴侣 Macros 页改。也可用界面 **Hold Soft PTT** 不碰板子测音频通路。
6. INMP441 到货后接线见 [mic-inmp441.md](mic-inmp441.md)。

## 常见问题

| 现象 | 处理 |
| --- | --- |
| No VibeMic found | **不要**在 Windows「设置 → 蓝牙」里点连接。若已配对：删除 VibeMic → 板子按 RST → 只在伴侣里 Scan |
| 手动连了系统蓝牙后 Not found | 正常：C3 只允许 1 路连接，系统占线后设备不再广播，App 扫不到 |
| 能连但无电平 | 固件监视器应有 PTT down；伴侣看 frames 是否增加 |
| 有电平但输入法无声 | 输入法麦克风选 CABLE Output；伴侣输出选 CABLE Input |
