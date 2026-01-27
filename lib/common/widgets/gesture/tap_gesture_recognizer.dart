import 'package:flutter/gestures.dart' show TapGestureRecognizer;

class NoDeadlineTapGestureRecognizer extends TapGestureRecognizer {
  NoDeadlineTapGestureRecognizer({
    super.debugOwner,
    super.supportedDevices,
    super.allowedButtonsFilter,
    super.preAcceptSlopTolerance,
    super.postAcceptSlopTolerance,
  });

  @override
  Duration? get deadline => null;
}
