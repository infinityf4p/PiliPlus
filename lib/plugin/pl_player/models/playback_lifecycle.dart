import 'package:flutter/widgets.dart' show AppLifecycleState;

enum PlaybackLifecycleAction { none, pause, resume }

class PlaybackLifecycleCoordinator {
  PlaybackLifecycleCoordinator({this.pauseOnHidden = false});

  final bool pauseOnHidden;
  bool _resumeWhenForegrounded = false;

  PlaybackLifecycleAction transition(
    AppLifecycleState state, {
    required bool isPlaying,
  }) {
    final shouldPause =
        state == .paused ||
        state == .detached ||
        (pauseOnHidden && state == .hidden);
    if (shouldPause) {
      if (_resumeWhenForegrounded) {
        return .none;
      }
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
