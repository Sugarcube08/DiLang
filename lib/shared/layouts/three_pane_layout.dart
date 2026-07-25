import 'package:flutter/material.dart';

class ThreePaneLayout extends StatelessWidget {
  final Widget leftPane;
  final Widget centerPane;
  final Widget rightPane;
  final double leftWidth;
  final double rightWidth;

  const ThreePaneLayout({
    super.key,
    required this.leftPane,
    required this.centerPane,
    required this.rightPane,
    this.leftWidth = 260.0,
    this.rightWidth = 320.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: leftWidth, child: leftPane),
        Expanded(child: centerPane),
        SizedBox(width: rightWidth, child: rightPane),
      ],
    );
  }
}
