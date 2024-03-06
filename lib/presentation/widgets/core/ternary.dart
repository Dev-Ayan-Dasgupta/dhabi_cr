import 'package:flutter/material.dart';

class Ternary extends StatelessWidget {
  const Ternary({
    super.key,
    required this.condition,
    required this.truthy,
    required this.falsy,
  });

  final bool condition;
  final Widget truthy;
  final Widget falsy;

  @override
  Widget build(BuildContext context) {
    return condition ? truthy : falsy;
  }
}
