import 'package:PiliPlus/plugin/pl_player/models/hardware_decoding_configuration.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HardwareDecodingConfiguration', () {
    test(
      'uses the preferred decoder when hardware acceleration is enabled',
      () {
        const configuration = HardwareDecodingConfiguration(
          enabled: true,
          preferredHwdec: 'auto-safe',
        );

        expect(configuration.enableHardwareAcceleration, isTrue);
        expect(configuration.hwdec, 'auto-safe');
      },
    );

    test('forces software decoding when hardware acceleration is disabled', () {
      const configuration = HardwareDecodingConfiguration(
        enabled: false,
        preferredHwdec: 'auto',
      );

      expect(configuration.enableHardwareAcceleration, isFalse);
      expect(configuration.hwdec, 'no');
    });
  });
}
