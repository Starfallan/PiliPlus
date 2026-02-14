import 'package:flutter/gestures.dart';

typedef IsBoundaryAllowed =
    bool Function(Offset? initialPosition, OffsetPair lastPosition);

class ImageHorizontalDragGestureRecognizer
    extends HorizontalDragGestureRecognizer {
  ImageHorizontalDragGestureRecognizer({
    super.debugOwner,
    super.supportedDevices,
    super.allowedButtonsFilter,
  });

  Offset? _initialPosition;

  IsBoundaryAllowed? isBoundaryAllowed;

  int? _pointer;

  @override
  void addPointer(PointerDownEvent event) {
    if (_pointer == event.pointer) {
      return;
    }
    _pointer = event.pointer;
    super.addPointer(event);
  }

  @override
  void addAllowedPointer(PointerDownEvent event) {
    super.addAllowedPointer(event);
    _initialPosition = event.position;
  }

  @override
  bool hasSufficientGlobalDistanceToAccept(
    PointerDeviceKind pointerDeviceKind,
    double? deviceTouchSlop,
  ) {
    return globalDistanceMoved.abs() >
            computeHitSlop(pointerDeviceKind, gestureSettings) &&
        (isBoundaryAllowed?.call(_initialPosition, lastPosition) ?? true);
  }

  @override
  void dispose() {
    isBoundaryAllowed = null;
    super.dispose();
  }
}
