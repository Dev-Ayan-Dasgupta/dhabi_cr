// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  const CustomShimmer({
    Key? key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  }) : super(key: key);

  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? const Color(0XFFEAE9E9),
      highlightColor: highlightColor ?? const Color(0XFFD7D7D7),
      child: child,
    );
  }
}

class ShimmerContainer extends StatelessWidget {
  const ShimmerContainer({
    super.key,
    required this.width,
    required this.height,
    this.color,
    this.borderRadius,
    this.shape,
  });

  final double width;
  final double height;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final BoxShape? shape;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: borderRadius,
        shape: shape ?? BoxShape.rectangle,
      ),
    );
  }
}
