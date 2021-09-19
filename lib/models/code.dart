import 'dart:math';

import 'package:flutter/cupertino.dart';

class Code {
  late final AlignmentGeometry alignmentGeometry;
  late final double position, fontSize, angle;
  late final Color color;
  late final bool isTop, isCaps, is3D;

  List<Color> colors = [];

  Code(
    this.alignmentGeometry,
    this.position,
    this.fontSize,
    this.angle,
    this.color,
    this.isTop,
    this.isCaps,
    this.is3D,
  );

  Code.fromJson(List values) {
    alignmentGeometry =
        values[0] == "t" ? Alignment.topCenter : Alignment.bottomCenter;
    isTop = values[0] == "t" ? true : false;
    position = double.parse(values[1]);
    fontSize = double.parse(values[2]);
    angle = double.parse(values[3]) * (pi / 180);
    is3D = values[5] == "3D" ? true : false;
    isCaps = values[6] == "A" ? true : false;

    if (is3D) {
      colors = splitColors(values[4]);
    } else {
      color = Color(
        int.parse("0xFF" + values[4]),
      );
    }
  }

  List<Color> splitColors(String value) {
    List<Color> colors = [];
    List temp = value.split("-");

    colors.add(
      Color(
        int.parse("0xFF" + temp[0]),
      ),
    );
    colors.add(
      Color(
        int.parse("0xFF" + temp[1]),
      ),
    );

    return colors;
  }
}
