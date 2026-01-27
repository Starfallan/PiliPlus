import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderProxyBox;

class OnlyLayoutWidget extends SingleChildRenderObjectWidget {
  const OnlyLayoutWidget({
    super.key,
    super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) => Layout();
}

class Layout extends RenderProxyBox {
  @override
  void paint(PaintingContext context, Offset offset) {}
}
