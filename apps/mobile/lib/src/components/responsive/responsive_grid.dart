import 'package:flutter/material.dart';
import 'responsive_breakpoints.dart';
import '../../theme/design_tokens.dart';

/// Responsive Grid component that dynamically calculates column counts
/// based on minimum item width constraints instead of hardcoding static column counts.
class ResponsiveGrid extends StatelessWidget {
  final List<Widget>? children;
  final NullableIndexedWidgetBuilder? itemBuilder;
  final int? itemCount;
  final double minItemWidth;
  final double maxItemWidth;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ResponsiveGrid({
    super.key,
    this.children,
    this.itemBuilder,
    this.itemCount,
    this.minItemWidth = 280.0,
    this.maxItemWidth = 480.0,
    this.mainAxisSpacing = DesignTokens.space16,
    this.crossAxisSpacing = DesignTokens.space16,
    this.childAspectRatio = 1.0,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
  }) : assert(children != null || (itemBuilder != null && itemCount != null),
            'Must provide either children or itemBuilder + itemCount');

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final effectivePadding = padding ?? context.responsivePadding;

        final horizontalPadding = effectivePadding.horizontal;
        final usableWidth = availableWidth - horizontalPadding;

        int crossAxisCount = (usableWidth / (minItemWidth + crossAxisSpacing)).floor();
        if (crossAxisCount < 1) crossAxisCount = 1;

        final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          childAspectRatio: childAspectRatio,
        );

        if (children != null) {
          return GridView(
            gridDelegate: gridDelegate,
            padding: effectivePadding,
            shrinkWrap: shrinkWrap,
            physics: physics,
            children: children!,
          );
        }

        return GridView.builder(
          gridDelegate: gridDelegate,
          padding: effectivePadding,
          shrinkWrap: shrinkWrap,
          physics: physics,
          itemCount: itemCount!,
          itemBuilder: itemBuilder!,
        );
      },
    );
  }

  static SliverGridDelegateWithMaxCrossAxisExtent buildDelegate({
    double maxCrossAxisExtent = 320.0,
    double mainAxisSpacing = DesignTokens.space16,
    double crossAxisSpacing = DesignTokens.space16,
    double childAspectRatio = 1.0,
  }) {
    return SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: maxCrossAxisExtent,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: childAspectRatio,
    );
  }
}
