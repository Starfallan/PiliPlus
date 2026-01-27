import 'package:PiliPlus/common/widgets/only_layout_widget.dart';
import 'package:flutter/material.dart';

class SelfSizedHorizontalList extends StatefulWidget {
  const SelfSizedHorizontalList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.separatorBuilder,
    this.controller,
    this.padding,
  });

  final int itemCount;
  final EdgeInsets? padding;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder separatorBuilder;
  final ScrollController? controller;

  @override
  State<SelfSizedHorizontalList> createState() =>
      _SelfSizedHorizontalListState();
}

class _SelfSizedHorizontalListState extends State<SelfSizedHorizontalList> {
  final _key = GlobalKey();
  double? _height;

  @override
  Widget build(BuildContext context) {
    if (_height == null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          _height = (_key.currentContext!.findRenderObject() as RenderBox)
              .size
              .height;
          setState(() {});
        },
      );
      return OnlyLayoutWidget(
        key: _key,
        child: Padding(
          padding: widget.padding ?? .zero,
          child: widget.itemBuilder(context, 0),
        ),
      );
    }

    return SizedBox(
      height: _height,
      child: ListView.separated(
        scrollDirection: .horizontal,
        padding: widget.padding,
        itemCount: widget.itemCount,
        controller: widget.controller,
        itemBuilder: widget.itemBuilder,
        separatorBuilder: widget.separatorBuilder,
      ),
    );
  }
}
