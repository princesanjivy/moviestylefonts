import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:msf/components/my_text.dart';
import 'package:msf/constants.dart';

saveImage(
  GlobalKey globalKey,
  String name,
  BuildContext context,
) async {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                  ),
                ),
                MyText("Processing image...")
              ],
            ),
          ));

  final platform = const MethodChannel('com.princewebstudio.msfonts/save');

  final RenderRepaintBoundary boundary =
      globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  final ui.Image image = await boundary.toImage(pixelRatio: 3);
  final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List pngBytes = byteData!.buffer.asUint8List();

  try {
    await platform.invokeMethod(
      "image",
      {
        "bytes": pngBytes,
        "name": name,
      },
    ).then((value) {
      print(value);
    });
  } on PlatformException catch (e) {
    print(e.message);
  }

  Navigator.pop(context);
}
