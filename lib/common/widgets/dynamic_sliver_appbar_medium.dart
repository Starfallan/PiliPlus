import 'package:PiliPlus/common/widgets/only_layout_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DynamicSliverAppBarMedium extends StatefulWidget {
  const DynamicSliverAppBarMedium({
    this.flexibleSpace,
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.bottom,
    this.elevation,
    this.scrolledUnderElevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.forceElevated = false,
    this.backgroundColor,
    this.backgroundGradient,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.collapsedHeight,
    this.expandedHeight,
    this.floating = false,
    this.pinned = false,
    this.snap = false,
    this.stretch = false,
    this.stretchTriggerOffset = 100.0,
    this.onStretchTrigger,
    this.shape,
    this.toolbarHeight = kToolbarHeight,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.forceMaterialTransparency = false,
    this.clipBehavior,
    this.appBarClipper,
    this.afterCalc,
  });

  final ValueChanged<double>? afterCalc;
  final Widget? flexibleSpace;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Widget? title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final double? scrolledUnderElevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final bool forceElevated;
  final Color? backgroundColor;

  /// If backgroundGradient is non null, backgroundColor will be ignored
  final LinearGradient? backgroundGradient;
  final Color? foregroundColor;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final bool primary;
  final bool? centerTitle;
  final bool excludeHeaderSemantics;
  final double? titleSpacing;
  final double? expandedHeight;
  final double? collapsedHeight;
  final bool floating;
  final bool pinned;
  final ShapeBorder? shape;
  final double toolbarHeight;
  final double? leadingWidth;
  final TextStyle? toolbarTextStyle;
  final TextStyle? titleTextStyle;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool forceMaterialTransparency;
  final Clip? clipBehavior;
  final bool snap;
  final bool stretch;
  final double stretchTriggerOffset;
  final AsyncCallback? onStretchTrigger;
  final CustomClipper<Path>? appBarClipper;

  @override
  State<DynamicSliverAppBarMedium> createState() =>
      _DynamicSliverAppBarMediumState();
}

class _DynamicSliverAppBarMediumState extends State<DynamicSliverAppBarMedium> {
  final GlobalKey _key = GlobalKey();
  double? _height;
  double? _width;
  late double _topPadding;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _topPadding = MediaQuery.viewPaddingOf(context).top;
    final width = MediaQuery.widthOf(context);
    if (_width != width) {
      _width = width;
      _height = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_height == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _height =
            (_key.currentContext!.findRenderObject() as RenderBox).size.height;
        widget.afterCalc?.call(_height!);
        setState(() {});
      });
      return SliverToBoxAdapter(
        child: OnlyLayoutWidget(
          child: UnconstrainedBox(
            alignment: Alignment.topLeft,
            child: SizedBox(
              key: _key,
              width: _width,
              child: widget.flexibleSpace,
            ),
          ),
        ),
      );
    }

    return SliverAppBar.medium(
      leading: widget.leading,
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      title: widget.title,
      actions: widget.actions,
      bottom: widget.bottom,
      elevation: widget.elevation,
      scrolledUnderElevation: widget.scrolledUnderElevation,
      shadowColor: widget.shadowColor,
      surfaceTintColor: widget.surfaceTintColor,
      forceElevated: widget.forceElevated,
      backgroundColor: widget.backgroundColor,
      foregroundColor: widget.foregroundColor,
      iconTheme: widget.iconTheme,
      actionsIconTheme: widget.actionsIconTheme,
      primary: widget.primary,
      centerTitle: widget.centerTitle,
      excludeHeaderSemantics: widget.excludeHeaderSemantics,
      titleSpacing: widget.titleSpacing,
      floating: widget.floating,
      pinned: widget.pinned,
      snap: widget.snap,
      stretch: widget.stretch,
      stretchTriggerOffset: widget.stretchTriggerOffset,
      onStretchTrigger: widget.onStretchTrigger,
      shape: widget.shape,
      toolbarHeight: kToolbarHeight,
      collapsedHeight: kToolbarHeight + _topPadding + 1,
      expandedHeight: _height! - _topPadding,
      leadingWidth: widget.leadingWidth,
      toolbarTextStyle: widget.toolbarTextStyle,
      titleTextStyle: widget.titleTextStyle,
      systemOverlayStyle: widget.systemOverlayStyle,
      forceMaterialTransparency: widget.forceMaterialTransparency,
      clipBehavior: widget.clipBehavior,
      flexibleSpace: FlexibleSpaceBar(background: widget.flexibleSpace),
    );
  }
}
