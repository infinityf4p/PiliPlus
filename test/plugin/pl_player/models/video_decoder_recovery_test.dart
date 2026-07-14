import 'package:PiliPlus/plugin/pl_player/models/video_decoder_recovery.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VideoDecoderRecovery', () {
    test('reloads the video track and seeks to the saved position', () async {
      final recovery = VideoDecoderRecovery();
      final commands = <List<String>>[];

      recovery.prepare(
        currentHwdec: 'videotoolbox',
        videoTrack: '1',
        position: const Duration(milliseconds: 12345),
      );
      await recovery.recover(
        runCommand: (command) async => commands.add(command),
      );

      expect(recovery.isPending, isFalse);
      expect(commands, [
        ['set', 'vid', 'no'],
        ['set', 'vid', '1'],
        ['seek', '12.345', 'absolute+exact'],
      ]);
    });

    test('does nothing when software decoding is active', () async {
      final recovery = VideoDecoderRecovery();
      final commands = <List<String>>[];

      recovery.prepare(
        currentHwdec: 'no',
        videoTrack: '1',
        position: Duration.zero,
      );
      await recovery.recover(
        runCommand: (command) async => commands.add(command),
      );

      expect(recovery.isPending, isFalse);
      expect(commands, isEmpty);
    });

    test('does nothing when video playback is disabled', () async {
      final recovery = VideoDecoderRecovery();
      final commands = <List<String>>[];

      recovery.prepare(
        currentHwdec: 'videotoolbox',
        videoTrack: 'no',
        position: Duration.zero,
      );
      await recovery.recover(
        runCommand: (command) async => commands.add(command),
      );

      expect(commands, isEmpty);
    });

    test('restores the video track if re-enabling it fails', () async {
      final recovery = VideoDecoderRecovery();
      final commands = <List<String>>[];
      var restoreAttempts = 0;

      recovery.prepare(
        currentHwdec: 'videotoolbox',
        videoTrack: '1',
        position: Duration.zero,
      );

      await expectLater(
        recovery.recover(
          runCommand: (command) async {
            commands.add(command);
            if (command case ['set', 'vid', '1']) {
              restoreAttempts += 1;
              if (restoreAttempts == 1) {
                throw StateError('failed');
              }
            }
          },
        ),
        throwsStateError,
      );

      expect(commands, [
        ['set', 'vid', 'no'],
        ['set', 'vid', '1'],
        ['set', 'vid', '1'],
      ]);
      expect(recovery.isPending, isFalse);
    });

    test('reset discards a pending recovery', () async {
      final recovery = VideoDecoderRecovery()
        ..prepare(
          currentHwdec: 'videotoolbox',
          videoTrack: '1',
          position: Duration.zero,
        )
        ..reset();

      final commands = <List<String>>[];
      await recovery.recover(
        runCommand: (command) async => commands.add(command),
      );
      expect(commands, isEmpty);
    });
  });
}
