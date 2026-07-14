import 'package:flutter/widgets.dart' show AppLifecycleState;

enum PlaybackLifecycleAction { none, pause, resume }

class PlaybackLifecycleCoordinator {
  bool _resumeWhenForegrounded = false;

  PlaybackLifecycleAction transition(
    AppLifecycleState state, {
    required bool isPlaying,
  }) {
    if (const <AppLifecycleState>[.paused, .detached].contains(state)) {
      if (isPlaying) {
        _resumeWhenForegrounded = true;
        return .pause;
      }
      return .none;
    }

    // On iOS, returning from the background transitions through hidden and
    // inactive before the Flutter view is active and rendering frames again.
    if (state == .resumed && _resumeWhenForegrounded) {
      _resumeWhenForegrounded = false;
      return .resume;
    }

    return .none;
  }
}
