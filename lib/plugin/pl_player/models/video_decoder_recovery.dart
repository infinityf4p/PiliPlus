typedef MpvCommandRunner = Future<void> Function(List<String> command);

class VideoDecoderRecovery {
  ({String videoTrack, Duration position})? _pendingRecovery;

  bool get isPending => _pendingRecovery != null;

  void prepare({
    required String currentHwdec,
    required String videoTrack,
    required Duration position,
  }) {
    if (isPending ||
        currentHwdec.isEmpty ||
        currentHwdec == 'no' ||
        videoTrack.isEmpty ||
        videoTrack == 'no') {
      return;
    }

    _pendingRecovery = (videoTrack: videoTrack, position: position);
  }

  Future<void> recover({required MpvCommandRunner runCommand}) async {
    final recovery = _pendingRecovery;
    _pendingRecovery = null;
    if (recovery == null) {
      return;
    }

    var videoDisabled = false;
    try {
      await runCommand(const ['set', 'vid', 'no']);
      videoDisabled = true;
      await runCommand(['set', 'vid', recovery.videoTrack]);
      videoDisabled = false;
      await runCommand([
        'seek',
        (recovery.position.inMilliseconds / 1000).toStringAsFixed(3),
        'absolute+exact',
      ]);
    } finally {
      if (videoDisabled) {
        await runCommand(['set', 'vid', recovery.videoTrack]);
      }
    }
  }

  void reset() {
    _pendingRecovery = null;
  }
}
