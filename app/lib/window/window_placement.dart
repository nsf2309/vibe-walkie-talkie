import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

/// Persists window bounds across launches (multi-monitor aware).
class WindowPlacement with WindowListener {
  WindowPlacement();

  static const defaultSize = Size(520, 720);
  static const minSize = Size(420, 560);

  static const _kX = 'window_x';
  static const _kY = 'window_y';
  static const _kW = 'window_w';
  static const _kH = 'window_h';
  static const _kMaximized = 'window_maximized';

  Timer? _saveTimer;
  bool _ready = false;

  Future<void> initAndShow() async {
    await windowManager.ensureInitialized();
    await windowManager.setPreventClose(true);
    windowManager.addListener(this);

    final bounds = await _resolveBounds();
    final maximized = await _readMaximized();

    const opts = WindowOptions(
      size: defaultSize,
      minimumSize: minSize,
      title: 'VibeMic',
      skipTaskbar: false,
    );

    await windowManager.waitUntilReadyToShow(opts, () async {
      await windowManager.setMinimumSize(minSize);
      if (maximized) {
        await windowManager.setBounds(bounds);
        await windowManager.maximize();
      } else {
        await windowManager.setBounds(bounds);
      }
      await windowManager.show();
      await windowManager.focus();
      _ready = true;
    });
  }

  Future<Rect> _resolveBounds() async {
    final prefs = await SharedPreferences.getInstance();
    final has = prefs.containsKey(_kX) &&
        prefs.containsKey(_kY) &&
        prefs.containsKey(_kW) &&
        prefs.containsKey(_kH);

    Size size = defaultSize;
    if (has) {
      final w = prefs.getDouble(_kW) ?? defaultSize.width;
      final h = prefs.getDouble(_kH) ?? defaultSize.height;
      size = Size(
        w.clamp(minSize.width, 10000),
        h.clamp(minSize.height, 10000),
      );
    }

    final displays = await screenRetriever.getAllDisplays();
    final primary = await screenRetriever.getPrimaryDisplay();

    if (has) {
      final x = prefs.getDouble(_kX)!;
      final y = prefs.getDouble(_kY)!;
      final remembered = Rect.fromLTWH(x, y, size.width, size.height);
      if (_isUsableOnDisplays(remembered, displays)) {
        return remembered;
      }
    }

    return _centerOnDisplay(primary, size);
  }

  Future<bool> _readMaximized() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kMaximized) ?? false;
  }

  /// Prefer: window center lies on a visible display.
  /// Fallback: at least 30% of the window intersects some display.
  bool _isUsableOnDisplays(Rect window, List<Display> displays) {
    if (displays.isEmpty) return false;
    final center = window.center;
    for (final d in displays) {
      final area = _visibleRect(d);
      if (area.contains(center)) return true;
    }
    final windowArea = window.width * window.height;
    if (windowArea <= 0) return false;
    for (final d in displays) {
      final area = _visibleRect(d);
      final inter = window.intersect(area);
      if (inter.width <= 0 || inter.height <= 0) continue;
      if ((inter.width * inter.height) / windowArea >= 0.30) return true;
    }
    return false;
  }

  Rect _visibleRect(Display d) {
    final origin = d.visiblePosition ?? Offset.zero;
    final size = d.visibleSize ?? d.size;
    return Rect.fromLTWH(origin.dx, origin.dy, size.width, size.height);
  }

  Rect _centerOnDisplay(Display display, Size size) {
    final area = _visibleRect(display);
    final dx = area.left + (area.width - size.width) / 2;
    final dy = area.top + (area.height - size.height) / 2;
    return Rect.fromLTWH(dx, dy, size.width, size.height);
  }

  void _scheduleSave() {
    if (!_ready) return;
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 250), () {
      unawaited(_persist());
    });
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final maximized = await windowManager.isMaximized();
      await prefs.setBool(_kMaximized, maximized);

      // Save normal bounds even when maximized (Windows restores from them).
      if (maximized) {
        // Keep last non-maximized bounds already stored; only update flag.
        return;
      }

      final bounds = await windowManager.getBounds();
      await prefs.setDouble(_kX, bounds.left);
      await prefs.setDouble(_kY, bounds.top);
      await prefs.setDouble(_kW, bounds.width);
      await prefs.setDouble(_kH, bounds.height);
    } catch (e) {
      debugPrint('WindowPlacement save failed: $e');
    }
  }

  @override
  void onWindowMoved() => _scheduleSave();

  @override
  void onWindowResized() => _scheduleSave();

  @override
  void onWindowMaximize() => _scheduleSave();

  @override
  void onWindowUnmaximize() => _scheduleSave();

  @override
  void onWindowClose() async {
    _saveTimer?.cancel();
    await _persist();
    // When closing while maximized, also refresh xywh from current restore bounds if available.
    try {
      if (await windowManager.isMaximized()) {
        // Unmaximize briefly is disruptive; leave stored normal size as-is.
      }
    } catch (_) {}
    await windowManager.destroy();
  }

  void dispose() {
    _saveTimer?.cancel();
    windowManager.removeListener(this);
  }
}
