import 'package:flutter_test/flutter_test.dart';
import 'package:vibemic/audio/ima_adpcm.dart';
import 'package:vibemic/protocol/vibemic_protocol.dart';

void main() {
  test('protocol constants', () {
    expect(kSampleRateHz, 16000);
    expect(kAdpcmBytes, 64);
    expect(kUuidService.isNotEmpty, true);
  });

  test('adpcm decode length', () {
    final d = ImaAdpcmDecoder();
    expect(d.decode(List.filled(64, 0)).length, 128);
  });
}