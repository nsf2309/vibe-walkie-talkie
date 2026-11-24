import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum VoiceModifier {
  none,
  fn,
  leftControl,
  rightControl,
  leftAlt,
  rightAlt,
  leftMeta,
  rightMeta,
  /// Windows WeChat IME style default for SayAll Windows preview.
  ctrlWin,
}

extension VoiceModifierLabel on VoiceModifier {
  String get labelZh {
    switch (this) {
      case VoiceModifier.none:
        return '无（仅推虚拟麦）';
      case VoiceModifier.fn:
        return 'Fn / 地球键（macOS）';
      case VoiceModifier.leftControl:
        return '左 Ctrl';
      case VoiceModifier.rightControl:
        return '右 Ctrl';
      case VoiceModifier.leftAlt:
        return '左 Alt';
      case VoiceModifier.rightAlt:
        return '右 Alt';
      case VoiceModifier.leftMeta:
        return 'Win / Cmd';
      case VoiceModifier.rightMeta:
        return '右 Win / Cmd';
      case VoiceModifier.ctrlWin:
        return 'Ctrl + Win（微信输入法）';
    }
  }
}

/// Platform key injection for PTT modifier hold and macro shortcuts.
class KeyInjector {
  static const _channel = MethodChannel('vibemic/input');

  VoiceModifier voiceModifier = defaultTargetPlatform == TargetPlatform.macOS
      ? VoiceModifier.fn
      : VoiceModifier.ctrlWin;

  Future<void> voiceSessionBegin() async {
    try {
      await _channel.invokeMethod('voiceBegin', {'modifier': voiceModifier.name});
    } on MissingPluginException {
      debugPrint('key inject stub: voiceBegin ${voiceModifier.name}');
    }
  }

  Future<void> voiceSessionEnd() async {
    try {
      await _channel.invokeMethod('voiceEnd', {'modifier': voiceModifier.name});
    } on MissingPluginException {
      debugPrint('key inject stub: voiceEnd ${voiceModifier.name}');
    }
  }

  /// [keys] is a list of logical key names, e.g. ["control", "c"] or ["f5"].
  Future<void> tapShortcut(List<String> keys) async {
    try {
      await _channel.invokeMethod('tapShortcut', {'keys': keys});
    } on MissingPluginException {
      debugPrint('key inject stub: tap $keys');
    }
  }

  Future<void> keyDown(List<String> keys) async {
    try {
      await _channel.invokeMethod('keyDown', {'keys': keys});
    } on MissingPluginException {
      debugPrint('key inject stub: keyDown $keys');
    }
  }

  Future<void> keyUp(List<String> keys) async {
    try {
      await _channel.invokeMethod('keyUp', {'keys': keys});
    } on MissingPluginException {
      debugPrint('key inject stub: keyUp $keys');
    }
  }

  Future<void> openApp(String appId) async {
    try {
      await _channel.invokeMethod('openApp', {'id': appId});
    } on MissingPluginException {
      debugPrint('key inject stub: openApp $appId');
    }
  }
}