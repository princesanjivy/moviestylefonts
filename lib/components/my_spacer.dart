import 'package:flutter/material.dart';

class VerticalSpacer extends StatelessWidget {
  final double space;

  VerticalSpacer(this.space);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: space,
    );
  }
}

class HorizontalSpacer extends StatelessWidget {
  final double space;

  HorizontalSpacer(this.space);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: space,
    );
  }
}
