import 'package:PiliPlus/plugin/pl_player/models/playback_lifecycle.dart';
import 'package:flutter/widgets.dart' show AppLifecycleState;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlaybackLifecycleCoordinator', () {
    test('waits for resumed during an iOS foreground transition', () {
      final coordinator = PlaybackLifecycleCoordinator();

      expect(
        coordinator.transition(.inactive, isPlaying: true),
        PlaybackLifecycleAction.none,
      );
      expect(
        coordinator.transition(.hidden, isPlaying: true),
        PlaybackLifecycleAction.none,
      );
      expect(
        coordinator.transition(.paused, isPlaying: true),
        PlaybackLifecycleAction.pause,
      );

      expect(
        coordinator.transition(.hidden, isPlaying: false),
        PlaybackLifecycleAction.none,
      );
      expect(
        coordinator.transition(.inactive, isPlaying: false),
        PlaybackLifecycleAction.none,
      );
      expect(
        coordinator.transition(.resumed, isPlaying: false),
        PlaybackLifecycleAction.resume,
      );
      expect(
        coordinator.transition(.resumed, isPlaying: true),
        PlaybackLifecycleAction.none,
      );
    });

    test('does not resume playback that was paused before backgrounding', () {
      final coordinator = PlaybackLifecycleCoordinator();

      for (final state in const <AppLifecycleState>[
        .paused,
        .hidden,
        .inactive,
        .resumed,
      ]) {
        expect(
          coordinator.transition(state, isPlaying: false),
          PlaybackLifecycleAction.none,
        );
      }
    });

    test('does not pause for a foreground-only inactive transition', () {
      final coordinator = PlaybackLifecycleCoordinator();

      expect(
        coordinator.transition(.inactive, isPlaying: true),
        PlaybackLifecycleAction.none,
      );
      expect(
        coordinator.transition(.resumed, isPlaying: true),
        PlaybackLifecycleAction.none,
      );
    });
  });
}
