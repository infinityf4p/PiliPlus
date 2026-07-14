class HardwareDecodingConfiguration {
  const HardwareDecodingConfiguration({
    required bool enabled,
    required String preferredHwdec,
  }) : enableHardwareAcceleration = enabled,
       hwdec = enabled ? preferredHwdec : 'no';

  final bool enableHardwareAcceleration;
  final String hwdec;
}
