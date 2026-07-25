import 'package:flutter/material.dart';

class TwoPaneLayout extends StatelessWidget {
  final Widget primaryPane;
  final Widget secondaryPane;
  final double secondaryWidth;

  const TwoPaneLayout({
    super.key,
    required this.primaryPane,
    required this.secondaryPane,
    this.secondaryWidth = 320.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: primaryPane),
        SizedBox(
          width: secondaryWidth,
          child: secondaryPane,
        ),
      ],
    );
  }
}
