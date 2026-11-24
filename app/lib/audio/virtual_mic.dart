import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../protocol/vibemic_protocol.dart';

/// Writes PCM float/int16 into a user-selected loopback device via platform plugin.
class VirtualMic {
  VirtualMic();

  static const _channel = MethodChannel('vibemic/audio');

  String? deviceId;
  double gain = 1.0;
  bool _sessionOpen = false;

  bool get sessionOpen => _sessionOpen;

  Future<List<AudioDeviceInfo>> listDevices() async {
    try {
      final raw = await _channel.invokeMethod<List<dynamic>>('listOutputDevices');
      return (raw ?? [])
          .map((e) => AudioDeviceInfo.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
    } on MissingPluginException {
      return [
        AudioDeviceInfo(
          id: 'stub-loopback',
          name: defaultTargetPlatform == TargetPlatform.macOS
              ? 'BlackHole 2ch (install required)'
              : defaultTargetPlatform == TargetPlatform.linux
                  ? 'VibeMicLoopback (PipeWire/Pulse)'
                  : 'CABLE Input (VB-Audio install required)',
        ),
      ];
    }
  }

  Future<void> selectDevice(String id) async {
    deviceId = id;
    try {
      await _channel.invokeMethod('selectDevice', {'id': id});
    } on MissingPluginException {
      // stub
    }
  }

  Future<void> beginSession() async {
    if (_sessionOpen) return;
    _sessionOpen = true;
    try {
      await _channel.invokeMethod('beginSession', {
        'sampleRate': kSampleRateHz,
        'channels': kChannels,
      });
    } on MissingPluginException {
      // stub
    }
  }

  Future<void> endSession() async {
    if (!_sessionOpen) return;
    _sessionOpen = false;
    try {
      await _channel.invokeMethod('endSession');
    } on MissingPluginException {
      // stub
    }
  }

  /// PCM16 samples → platform write (scaled by [gain]).
  Future<void> writePcm16(List<int> samples) async {
    if (!_sessionOpen) return;
    final floats = Float32List(samples.length);
    for (var i = 0; i < samples.length; i++) {
      var v = (samples[i] / 32768.0) * gain;
      if (v > 1) v = 1;
      if (v < -1) v = -1;
      floats[i] = v;
    }
    try {
      await _channel.invokeMethod('writeFloat32', {
        'bytes': floats.buffer.asUint8List(),
      });
    } on MissingPluginException {
      // Host without plugin still advances session state for UI bring-up.
    }
  }
}

class AudioDeviceInfo {
  AudioDeviceInfo({required this.id, required this.name});
  final String id;
  final String name;

  factory AudioDeviceInfo.fromMap(Map<String, dynamic> m) =>
      AudioDeviceInfo(id: m['id'] as String, name: m['name'] as String);
}