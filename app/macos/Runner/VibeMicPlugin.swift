import Cocoa
import FlutterMacOS
import Carbon

/// Registers MethodChannels vibemic/audio and vibemic/input.
public class VibeMicPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let audio = FlutterMethodChannel(name: "vibemic/audio", binaryMessenger: registrar.messenger)
    let input = FlutterMethodChannel(name: "vibemic/input", binaryMessenger: registrar.messenger)
    let instance = VibeMicPlugin()
    registrar.addMethodCallDelegate(instance, channel: audio)
    // Re-use same instance for second channel via separate registrar call:
    let inputDelegate = VibeMicPlugin()
    registrar.addMethodCallDelegate(inputDelegate, channel: input)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "listOutputDevices":
      result([["id": "blackhole", "name": "BlackHole 2ch"]])
    case "selectDevice", "beginSession", "endSession", "writeFloat32":
      // CoreAudio loopback write — wire to BlackHole device UID in a follow-up.
      result(nil)
    case "voiceBegin":
      postKey(key: CGKeyCode(63), down: true) // Fn on many Apple keyboards via HID remap apps; fallback Control
      result(nil)
    case "voiceEnd":
      postKey(key: CGKeyCode(63), down: false)
      result(nil)
    case "tapShortcut":
      if let args = call.arguments as? [String: Any], let keys = args["keys"] as? [String] {
        tap(keys: keys)
      }
      result(nil)
    case "openApp":
      if let args = call.arguments as? [String: Any], let id = args["id"] as? String {
        let map: [String: String] = [
          "chrome": "com.google.Chrome",
          "safari": "com.apple.Safari",
          "cursor": "com.todesktop.230313mzl4w4u92",
          "wechat": "com.tencent.xinWeChat",
        ]
        if let bundle = map[id] {
          NSWorkspace.shared.launchApplication(withBundleIdentifier: bundle, options: [], additionalEventParamDescriptor: nil, launchIdentifier: nil)
        }
      }
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func postKey(key: CGKeyCode, down: Bool) {
    let src = CGEventSource(stateID: .hidSystemState)
    if let ev = CGEvent(keyboardEventSource: src, virtualKey: key, keyDown: down) {
      ev.post(tap: .cghidEventTap)
    }
  }

  private func tap(keys: [String]) {
    let map: [String: CGKeyCode] = [
      "a": 0, "c": 8, "v": 9, "control": 59, "command": 55, "shift": 56, "option": 58, "escape": 53,
    ]
    var codes: [CGKeyCode] = []
    for k in keys {
      if let c = map[k.lowercased()] { codes.append(c) }
    }
    for c in codes { postKey(key: c, down: true) }
    for c in codes.reversed() { postKey(key: c, down: false) }
  }
}