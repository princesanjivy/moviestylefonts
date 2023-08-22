import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:msf/components/my_text.dart';
import 'package:msf/constants.dart';
import 'package:shared_storage/shared_storage.dart' as saf;

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

  final RenderRepaintBoundary boundary =
      globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  final ui.Image image = await boundary.toImage(pixelRatio: 3);
  final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List pngBytes = byteData!.buffer.asUint8List();

  final Uri? grantedUri =
      await saf.openDocumentTree(grantWritePermission: true);

  if (grantedUri != null) {
    print('Now I have permission over this Uri: $grantedUri');

    saf.createFileAsBytes(
      grantedUri,
      mimeType: "image/png",
      displayName: name,
      bytes: pngBytes,
    );
  }

  Navigator.pop(context);
}
