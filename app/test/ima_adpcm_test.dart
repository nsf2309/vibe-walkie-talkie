import 'package:flutter_test/flutter_test.dart';
import 'package:vibemic/audio/ima_adpcm.dart';

void main() {
  test('decoder resets and produces samples', () {
    final d = ImaAdpcmDecoder();
    d.reset();
    final pcm = d.decode([0x00, 0x00, 0x77, 0x77]);
    expect(pcm.length, 8);
  });
}