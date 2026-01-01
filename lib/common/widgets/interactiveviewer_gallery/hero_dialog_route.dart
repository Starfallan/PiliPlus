import 'package:flutter/material.dart';

/// https://github.com/qq326646683/interactiveviewer_gallery

/// A [PageRoute] with a semi transparent background.
///
/// Similar to calling [showDialog] except it can be used with a [Navigator] to
/// show a [Hero] animation.
class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({
    required this.pageBuilder,
  });

  final RoutePageBuilder pageBuilder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color? get barrierColor => null;

  CurvedAnimation? _curvedAnimation;

  void _setAnimation(Animation<double> animation) {
    if (_curvedAnimation?.parent != animation) {
      _curvedAnimation?.dispose();
      _curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    _setAnimation(animation);
    return FadeTransition(
      opacity: _curvedAnimation!,
      child: child,
    );
  }

  @override
  void dispose() {
    _curvedAnimation?.dispose();
    super.dispose();
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: pageBuilder(context, animation, secondaryAnimation),
    );
  }
}
