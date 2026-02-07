import 'package:PiliPlus/common/widgets/interactiveviewer_gallery/interactive_viewer.dart'
    as custom;
import 'package:flutter/material.dart';

/// https://github.com/qq326646683/interactiveviewer_gallery

/// A callback for the [InteractiveViewerBoundary] that is called when the scale
/// changed.
typedef ScaleChanged = void Function(double scale);

/// Builds an [InteractiveViewer] and provides callbacks that are called when a
/// horizontal boundary has been hit.
///
/// The callbacks are called when an interaction ends by listening to the
/// [InteractiveViewer.onInteractionEnd] callback.
class InteractiveViewerBoundary extends StatefulWidget {
  const InteractiveViewerBoundary({
    super.key,
    required this.child,
    required this.boundaryWidth,
    required this.controller,
    required this.maxScale,
    required this.minScale,
    this.onDismissed,
    this.dismissThreshold = 0.2,
    this.onInteractionEnd,
  });

  final double dismissThreshold;
  final VoidCallback? onDismissed;

  final Widget child;

  /// The max width this widget can have.
  ///
  /// If the [InteractiveViewer] can take up the entire screen width, this
  /// should be set to `MediaQuery.of(context).size.width`.
  final double boundaryWidth;

  /// The [TransformationController] for the [InteractiveViewer].
  final TransformationController controller;

  final double maxScale;

  final double minScale;

  final GestureScaleEndCallback? onInteractionEnd;

  @override
  InteractiveViewerBoundaryState createState() =>
      InteractiveViewerBoundaryState();
}

class InteractiveViewerBoundaryState extends State<InteractiveViewerBoundary>
    with SingleTickerProviderStateMixin {
  late TransformationController _controller;
  late AnimationController _animateController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Decoration> _opacityAnimation;

  Offset _offset = Offset.zero;
  bool _dragging = false;

  bool get _isActive => _dragging || _animateController.isAnimating;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;

    _animateController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _updateMoveAnimation();

    _scaleAnimation = _animateController.drive(
      Tween<double>(begin: 1.0, end: 0.25),
    );

    _opacityAnimation = _animateController.drive(
      DecorationTween(
        begin: const BoxDecoration(color: Colors.black),
        end: const BoxDecoration(color: Colors.transparent),
      ),
    );
  }

  @override
  void dispose() {
    _animateController.dispose();
    super.dispose();
  }

  void _updateMoveAnimation() {
    final double endX = _offset.dx.sign * (_offset.dx.abs() / _offset.dy.abs());
    final double endY = _offset.dy.sign;
    _slideAnimation = _animateController.drive(
      Tween<Offset>(
        begin: Offset.zero,
        end: Offset(endX, endY),
      ),
    );
  }

  void _handleDragStart(ScaleStartDetails details) {
    _dragging = true;

    if (_animateController.isAnimating) {
      _animateController.stop();
    } else {
      _offset = Offset.zero;
      _animateController.value = 0.0;
    }
    setState(_updateMoveAnimation);
  }

  void _handleDragUpdate(ScaleUpdateDetails details) {
    if (!_isActive || _animateController.isAnimating) {
      return;
    }

    _offset += details.focalPointDelta;

    setState(_updateMoveAnimation);

    if (!_animateController.isAnimating) {
      _animateController.value = _offset.dy.abs() / context.size!.height;
    }
  }

  void _handleDragEnd(ScaleEndDetails details) {
    if (!_isActive || _animateController.isAnimating) {
      return;
    }

    _dragging = false;

    if (_animateController.isCompleted) {
      return;
    }

    if (!_animateController.isDismissed) {
      // if the dragged value exceeded the dismissThreshold, call onDismissed
      // else animate back to initial position.
      if (_animateController.value > widget.dismissThreshold) {
        widget.onDismissed?.call();
      } else {
        _animateController.reverse();
      }
    }
  }

  Widget get content => DecoratedBoxTransition(
    decoration: _opacityAnimation,
    child: SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return custom.InteractiveViewer(
      maxScale: widget.maxScale,
      minScale: widget.minScale,
      transformationController: _controller,
      onPanStart: _handleDragStart,
      onPanUpdate: _handleDragUpdate,
      onPanEnd: _handleDragEnd,
      onInteractionEnd: widget.onInteractionEnd,
      isAnimating: () => _animateController.value != 0,
      child: content,
    );
  }
}
