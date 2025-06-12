import 'package:flutter/material.dart';
import 'package:talent_mesh/common/widgets/custom_painter/dashed_borer_painter.dart';

class ContainerWithDashedBorder extends StatelessWidget {
  final Color bgColor;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double borderRadius;
  final Widget child;
  final double width;
  final double height;
  final Color borderColor;
  final double borderWidth;
  const ContainerWithDashedBorder({
    this.bgColor = Colors.white,
    required this.child,
    required this.width,
    required this.height,
    this.margin,
    this.padding,
    this.borderRadius = 12,
    this.borderColor = Colors.grey,
    this.borderWidth = 1,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius),
        ),
        color: bgColor,
      ),
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: borderColor,
          strokeWidth: borderWidth,
          dashWidth: 8,
          dashSpace: 4,
          borderRadius: borderRadius,
        ),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      ),
    );
  }
}
