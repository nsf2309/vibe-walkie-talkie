import 'dart:convert';

import '../protocol/vibemic_buttons.dart';

/// Action catalog aligned with SayAll + VibeMic agent/task-view needs.
enum MacroActionType {
  none,
  // Custom
  keyShortcut,
  holdShortcut,
  openApp,
  combination,
  // System / media
  mediaPlayPause,
  volumeUp,
  volumeDown,
  mute,
  mediaNext,
  mediaPrev,
  taskView,
  // Screenshots / squeeze
  screenshotFull,
  screenshotWindow,
  screenshotWechat,
  screenshotSnip,
  // Basic / editing
  escape,
  enter,
  copy,
  paste,
  cut,
  selectAll,
  undo,
  redo,
  find,
  save,
  closeWindow,
  newTab,
  prevTab,
  nextTab,
  // Navigation (also usable as hold)
  arrowUp,
  arrowDown,
  arrowLeft,
  arrowRight,
  pageUp,
  pageDown,
  home,
  end,
  delete,
  backspace,
  // Agent (Cursor / Codex)
  agentAccept,
  agentReject,
  agentNewSession,
  // Apps
  openWeChat,
  openCursor,
  openCodex,
  openChrome,
  openEdge,
  openNotepad,
  openExplorer,
}

enum MacroActionCategory {
  basic,
  editing,
  media,
  agent,
  apps,
  custom,
}

extension MacroActionTypeX on MacroActionType {
  MacroActionCategory get category {
    switch (this) {
      case MacroActionType.none:
      case MacroActionType.escape:
      case MacroActionType.enter:
      case MacroActionType.arrowUp:
      case MacroActionType.arrowDown:
      case MacroActionType.arrowLeft:
      case MacroActionType.arrowRight:
      case MacroActionType.pageUp:
      case MacroActionType.pageDown:
      case MacroActionType.home:
      case MacroActionType.end:
      case MacroActionType.delete:
      case MacroActionType.backspace:
        return MacroActionCategory.basic;
      case MacroActionType.copy:
      case MacroActionType.paste:
      case MacroActionType.cut:
      case MacroActionType.selectAll:
      case MacroActionType.undo:
      case MacroActionType.redo:
      case MacroActionType.find:
      case MacroActionType.save:
      case MacroActionType.closeWindow:
      case MacroActionType.newTab:
      case MacroActionType.prevTab:
      case MacroActionType.nextTab:
        return MacroActionCategory.editing;
      case MacroActionType.mediaPlayPause:
      case MacroActionType.volumeUp:
      case MacroActionType.volumeDown:
      case MacroActionType.mute:
      case MacroActionType.mediaNext:
      case MacroActionType.mediaPrev:
      case MacroActionType.taskView:
      case MacroActionType.screenshotFull:
      case MacroActionType.screenshotWindow:
      case MacroActionType.screenshotWechat:
      case MacroActionType.screenshotSnip:
        return MacroActionCategory.media;
      case MacroActionType.agentAccept:
      case MacroActionType.agentReject:
      case MacroActionType.agentNewSession:
        return MacroActionCategory.agent;
      case MacroActionType.openApp:
      case MacroActionType.openWeChat:
      case MacroActionType.openCursor:
      case MacroActionType.openCodex:
      case MacroActionType.openChrome:
      case MacroActionType.openEdge:
      case MacroActionType.openNotepad:
      case MacroActionType.openExplorer:
        return MacroActionCategory.apps;
      case MacroActionType.keyShortcut:
      case MacroActionType.holdShortcut:
      case MacroActionType.combination:
        return MacroActionCategory.custom;
    }
  }

  String get labelZh {
    switch (this) {
      case MacroActionType.none:
        return '无';
      case MacroActionType.keyShortcut:
        return '自定义快捷键';
      case MacroActionType.holdShortcut:
        return '按住保持快捷键';
      case MacroActionType.openApp:
        return '打开应用…';
      case MacroActionType.combination:
        return '组合动作';
      case MacroActionType.mediaPlayPause:
        return '播放/暂停';
      case MacroActionType.volumeUp:
        return '音量 +';
      case MacroActionType.volumeDown:
        return '音量 −';
      case MacroActionType.mute:
        return '静音';
      case MacroActionType.mediaNext:
        return '下一曲';
      case MacroActionType.mediaPrev:
        return '上一曲';
      case MacroActionType.taskView:
        return '多任务视图 (Win+Tab)';
      case MacroActionType.screenshotFull:
        return '全屏截图 (PrtSc)';
      case MacroActionType.screenshotWindow:
        return '当前窗口截图 (Alt+PrtSc)';
      case MacroActionType.screenshotWechat:
        return '微信截图 (Alt+A)';
      case MacroActionType.screenshotSnip:
        return '系统截图工具 (Win+Shift+S)';
      case MacroActionType.escape:
        return 'Esc';
      case MacroActionType.enter:
        return '回车 / 确认';
      case MacroActionType.copy:
        return '复制';
      case MacroActionType.paste:
        return '粘贴';
      case MacroActionType.cut:
        return '剪切';
      case MacroActionType.selectAll:
        return '全选';
      case MacroActionType.undo:
        return '撤销';
      case MacroActionType.redo:
        return '重做';
      case MacroActionType.find:
        return '查找';
      case MacroActionType.save:
        return '保存';
      case MacroActionType.closeWindow:
        return '关闭窗口';
      case MacroActionType.newTab:
        return '新建标签';
      case MacroActionType.prevTab:
        return '上一个标签';
      case MacroActionType.nextTab:
        return '下一个标签';
      case MacroActionType.arrowUp:
        return '↑（可按住）';
      case MacroActionType.arrowDown:
        return '↓（可按住）';
      case MacroActionType.arrowLeft:
        return '←（可按住）';
      case MacroActionType.arrowRight:
        return '→（可按住）';
      case MacroActionType.pageUp:
        return 'Page Up';
      case MacroActionType.pageDown:
        return 'Page Down';
      case MacroActionType.home:
        return 'Home';
      case MacroActionType.end:
        return 'End';
      case MacroActionType.delete:
        return 'Delete';
      case MacroActionType.backspace:
        return 'Backspace';
      case MacroActionType.agentAccept:
        return 'Agent 接受 (Ctrl+Enter)';
      case MacroActionType.agentReject:
        return 'Agent 拒绝 (Esc)';
      case MacroActionType.agentNewSession:
        return 'Agent 新建会话 (Ctrl+L)';
      case MacroActionType.openWeChat:
        return '打开微信';
      case MacroActionType.openCursor:
        return '打开 Cursor';
      case MacroActionType.openCodex:
        return '打开 Codex / ChatGPT';
      case MacroActionType.openChrome:
        return '打开 Chrome';
      case MacroActionType.openEdge:
        return '打开 Edge';
      case MacroActionType.openNotepad:
        return '打开记事本';
      case MacroActionType.openExplorer:
        return '打开资源管理器';
    }
  }

  /// True if host should key-down on BTN_DOWN and key-up on BTN_UP.
  bool get isHoldable {
    switch (this) {
      case MacroActionType.holdShortcut:
      case MacroActionType.arrowUp:
      case MacroActionType.arrowDown:
      case MacroActionType.arrowLeft:
      case MacroActionType.arrowRight:
        return true;
      default:
        return false;
    }
  }

  List<String>? get presetKeys {
    switch (this) {
      case MacroActionType.escape:
      case MacroActionType.agentReject:
        return ['escape'];
      case MacroActionType.enter:
        return ['enter'];
      case MacroActionType.agentAccept:
        return ['control', 'enter'];
      case MacroActionType.agentNewSession:
        return ['control', 'l'];
      case MacroActionType.taskView:
        return ['win', 'tab'];
      case MacroActionType.screenshotFull:
        return ['printscreen'];
      case MacroActionType.screenshotWindow:
        return ['alt', 'printscreen'];
      case MacroActionType.screenshotWechat:
        return ['alt', 'a'];
      case MacroActionType.screenshotSnip:
        return ['win', 'shift', 's'];
      case MacroActionType.copy:
        return ['control', 'c'];
      case MacroActionType.paste:
        return ['control', 'v'];
      case MacroActionType.cut:
        return ['control', 'x'];
      case MacroActionType.selectAll:
        return ['control', 'a'];
      case MacroActionType.undo:
        return ['control', 'z'];
      case MacroActionType.redo:
        return ['control', 'y'];
      case MacroActionType.find:
        return ['control', 'f'];
      case MacroActionType.save:
        return ['control', 's'];
      case MacroActionType.closeWindow:
        return ['alt', 'f4'];
      case MacroActionType.newTab:
        return ['control', 't'];
      case MacroActionType.prevTab:
        return ['control', 'shift', 'tab'];
      case MacroActionType.nextTab:
        return ['control', 'tab'];
      case MacroActionType.arrowUp:
        return ['up'];
      case MacroActionType.arrowDown:
        return ['down'];
      case MacroActionType.arrowLeft:
        return ['left'];
      case MacroActionType.arrowRight:
        return ['right'];
      case MacroActionType.pageUp:
        return ['pageup'];
      case MacroActionType.pageDown:
        return ['pagedown'];
      case MacroActionType.home:
        return ['home'];
      case MacroActionType.end:
        return ['end'];
      case MacroActionType.delete:
        return ['delete'];
      case MacroActionType.backspace:
        return ['backspace'];
      case MacroActionType.mediaPlayPause:
        return ['mediaPlayPause'];
      case MacroActionType.volumeUp:
        return ['volumeUp'];
      case MacroActionType.volumeDown:
        return ['volumeDown'];
      case MacroActionType.mute:
        return ['volumeMute'];
      case MacroActionType.mediaNext:
        return ['mediaNext'];
      case MacroActionType.mediaPrev:
        return ['mediaPrev'];
      default:
        return null;
    }
  }

  String? get presetAppId {
    switch (this) {
      case MacroActionType.openWeChat:
        return 'wechat';
      case MacroActionType.openCursor:
        return 'cursor';
      case MacroActionType.openCodex:
        return 'codex';
      case MacroActionType.openChrome:
        return 'chrome';
      case MacroActionType.openEdge:
        return 'edge';
      case MacroActionType.openNotepad:
        return 'notepad';
      case MacroActionType.openExplorer:
        return 'explorer';
      default:
        return null;
    }
  }
}

extension MacroActionCategoryX on MacroActionCategory {
  String get labelZh {
    switch (this) {
      case MacroActionCategory.basic:
        return '基础按键';
      case MacroActionCategory.editing:
        return '编辑';
      case MacroActionCategory.media:
        return '系统与媒体';
      case MacroActionCategory.agent:
        return 'Cursor / Codex';
      case MacroActionCategory.apps:
        return '打开应用';
      case MacroActionCategory.custom:
        return '自定义';
    }
  }
}

class MacroAction {
  MacroAction({
    this.type = MacroActionType.none,
    this.keys = const [],
    this.appId = '',
    List<MacroAction>? steps,
  }) : steps = steps ?? const [];

  MacroActionType type;
  List<String> keys;
  String appId;
  List<MacroAction> steps;

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'keys': keys,
        'appId': appId,
        if (steps.isNotEmpty) 'steps': steps.map((s) => s.toJson()).toList(),
      };

  factory MacroAction.fromJson(Map<String, dynamic> j) => MacroAction(
        type: MacroActionType.values.firstWhere(
          (e) => e.name == j['type'],
          orElse: () => MacroActionType.none,
        ),
        keys: (j['keys'] as List?)?.cast<String>() ?? const [],
        appId: j['appId'] as String? ?? '',
        steps: (j['steps'] as List?)
                ?.map((e) => MacroAction.fromJson(Map<String, dynamic>.from(e as Map)))
                .toList() ??
            const [],
      );

  String describe() {
    switch (type) {
      case MacroActionType.none:
        return '无';
      case MacroActionType.keyShortcut:
        return '快捷键: ${keys.join("+")}';
      case MacroActionType.holdShortcut:
        return '按住: ${keys.join("+")}';
      case MacroActionType.openApp:
        return '打开: $appId';
      case MacroActionType.combination:
        if (steps.isEmpty) return '组合动作（空）';
        return '组合: ${steps.map((s) => s.describe()).join(" → ")}';
      default:
        return type.labelZh;
    }
  }

  List<String> resolveKeys() {
    if (type == MacroActionType.keyShortcut || type == MacroActionType.holdShortcut) {
      return keys;
    }
    return type.presetKeys ?? const [];
  }
}

class ButtonBinding {
  ButtonBinding({
    required this.buttonId,
    MacroAction? onClick,
    MacroAction? onDouble,
    MacroAction? onLong,
    MacroAction? onHold,
  })  : onClick = onClick ?? MacroAction(),
        onDouble = onDouble ?? MacroAction(),
        onLong = onLong ?? MacroAction(),
        onHold = onHold ?? MacroAction();

  final int buttonId;
  MacroAction onClick;
  MacroAction onDouble;
  MacroAction onLong;
  /// While physical key is held (BTN_DOWN → BTN_UP). Prefer holdable actions.
  MacroAction onHold;

  Map<String, dynamic> toJson() => {
        'buttonId': buttonId,
        'onClick': onClick.toJson(),
        'onDouble': onDouble.toJson(),
        'onLong': onLong.toJson(),
        'onHold': onHold.toJson(),
      };

  factory ButtonBinding.fromJson(Map<String, dynamic> j) => ButtonBinding(
        buttonId: j['buttonId'] as int,
        onClick: MacroAction.fromJson(Map<String, dynamic>.from(j['onClick'] as Map)),
        onDouble: MacroAction.fromJson(Map<String, dynamic>.from(j['onDouble'] as Map)),
        onLong: MacroAction.fromJson(Map<String, dynamic>.from(j['onLong'] as Map)),
        onHold: j['onHold'] != null
            ? MacroAction.fromJson(Map<String, dynamic>.from(j['onHold'] as Map))
            : MacroAction(),
      );
}

class MacroStore {
  MacroStore() {
    _applyDefaults();
  }

  final Map<int, ButtonBinding> bindings = {
    for (var i = 1; i <= kButtonCount; i++) i: ButtonBinding(buttonId: i),
  };

  void _applyDefaults() {
    void set(
      int id, {
      MacroAction? click,
      MacroAction? dbl,
      MacroAction? long,
      MacroAction? hold,
    }) {
      bindings[id] = ButtonBinding(
        buttonId: id,
        onClick: click,
        onDouble: dbl,
        onLong: long,
        onHold: hold,
      );
    }

    set(keyUp, hold: MacroAction(type: MacroActionType.arrowUp));
    set(keyDown, hold: MacroAction(type: MacroActionType.arrowDown));
    set(keyLeft, hold: MacroAction(type: MacroActionType.arrowLeft));
    set(keyRight, hold: MacroAction(type: MacroActionType.arrowRight));
    set(
      keyOk,
      click: MacroAction(type: MacroActionType.enter),
      long: MacroAction(type: MacroActionType.agentAccept),
    );
    set(keyVolUp, click: MacroAction(type: MacroActionType.volumeUp));
    set(keyVolDown, click: MacroAction(type: MacroActionType.volumeDown));
    set(
      keyBack,
      click: MacroAction(type: MacroActionType.escape),
      long: MacroAction(type: MacroActionType.agentReject),
    );
    set(keyHome, click: MacroAction(type: MacroActionType.openExplorer));
    set(
      keyMenu,
      click: MacroAction(type: MacroActionType.taskView),
      long: MacroAction(type: MacroActionType.mediaPlayPause),
    );
    set(keyF1, click: MacroAction(type: MacroActionType.agentAccept));
    set(keyF2, click: MacroAction(type: MacroActionType.agentReject));
    set(keyF3, click: MacroAction(type: MacroActionType.agentNewSession));
    set(keyF4, click: MacroAction(type: MacroActionType.openCursor));
    set(keyF5, click: MacroAction(type: MacroActionType.openCodex));
    set(
      keyF6,
      click: MacroAction(type: MacroActionType.taskView),
      long: MacroAction(type: MacroActionType.mute),
    );
    // Side squeeze: PTT + Vol (virtual keys from firmware)
    set(
      keySqueezeVolDown,
      click: MacroAction(type: MacroActionType.screenshotFull),
      long: MacroAction(type: MacroActionType.screenshotWechat),
    );
    set(
      keySqueezeVolUp,
      click: MacroAction(type: MacroActionType.screenshotWindow),
      long: MacroAction(type: MacroActionType.screenshotSnip),
    );
  }

  String encode() => jsonEncode({
        'bindings': bindings.values.map((b) => b.toJson()).toList(),
      });

  void decode(String raw) {
    final j = jsonDecode(raw) as Map<String, dynamic>;
    final list = j['bindings'] as List? ?? [];
    for (final item in list) {
      final b = ButtonBinding.fromJson(Map<String, dynamic>.from(item as Map));
      if (b.buttonId >= 1 && b.buttonId <= kButtonCount) {
        bindings[b.buttonId] = b;
      }
    }
  }

  void resetDefaults() {
    _applyDefaults();
  }
}
