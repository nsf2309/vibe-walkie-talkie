import 'package:material_ui/material_ui.dart';

import '../ble/vibemic_ble.dart';
import '../settings/app_settings.dart';

class GeneralPage extends StatefulWidget {
  const GeneralPage({
    super.key,
    required this.ble,
    required this.settings,
  });

  final VibeMicBle ble;
  final AppSettings settings;

  @override
  State<GeneralPage> createState() => _GeneralPageState();
}

class _GeneralPageState extends State<GeneralPage> {
  @override
  Widget build(BuildContext context) {
    final s = widget.settings;
    return ListView(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 40),
      children: [
        Text('通用', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 6),
        Text(
          '对齐 SayAll「连接与语音 / 按键 / 设置」中的本机偏好。会员回眸、MCP、多方案按 App 切换等高级能力后续按需加。',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('启动时自动扫描'),
          subtitle: const Text('打开伴侣后自动寻找 VibeMic'),
          value: s.autoScanOnLaunch,
          onChanged: (v) async {
            setState(() => s.autoScanOnLaunch = v);
            await s.save();
          },
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('断线自动重连'),
          subtitle: const Text('意外断开约 3 秒后重新扫描'),
          value: s.autoReconnect,
          onChanged: (v) async {
            setState(() {
              s.autoReconnect = v;
              widget.ble.autoReconnect = v;
            });
            await s.save();
          },
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('显示扫描调试'),
          subtitle: const Text('在「连接与语音」页列出附近 BLE 广播'),
          value: s.showScanDebug,
          onChanged: (v) async {
            setState(() => s.showScanDebug = v);
            await s.save();
          },
        ),
        const Divider(height: 32),
        Text('使用提示', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        const Text('1. 安装 VB-Audio Virtual Cable；伴侣选 CABLE Input，输入法选 CABLE Output。'),
        const SizedBox(height: 6),
        const Text('2. 不要在 Windows「设置 → 蓝牙」里连接 VibeMic，只在本伴侣扫描。'),
        const SizedBox(height: 6),
        const Text('3. INMP441 接线见仓库 docs/mic-inmp441.md；麦未焊时 PTT 为测试音。'),
        const SizedBox(height: 6),
        const Text('4. 按键矩阵接线见 docs/keys-matrix.md（方向/OK/音量/返回/Home/菜单/F1–F6 + PTT）。'),
        const SizedBox(height: 6),
        const Text('5. 多任务：Menu→Win+Tab，按住←/→切换，OK 确认；F1/F2/F3 = Agent 接受/拒绝/新建会话。'),
        const Divider(height: 32),
        Text('关于', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        const Text('VibeMic 伴侣 0.1.0 · ESP32-C3 自定义 BLE 音频 + HID 按键'),
      ],
    );
  }
}
