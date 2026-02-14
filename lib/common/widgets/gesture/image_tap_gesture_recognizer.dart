import 'package:flutter/gestures.dart'
    show TapGestureRecognizer, PointerDownEvent;

class ImageTapGestureRecognizer extends TapGestureRecognizer {
  ImageTapGestureRecognizer({
    super.debugOwner,
    super.supportedDevices,
    super.allowedButtonsFilter,
    super.preAcceptSlopTolerance,
    super.postAcceptSlopTolerance,
  });

  int? _pointer;

  @override
  void addPointer(PointerDownEvent event) {
    if (_pointer == event.pointer) {
      return;
    }
    _pointer = event.pointer;
    super.addPointer(event);
  }
}
