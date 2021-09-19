import 'package:flutter/material.dart';

class Navigation {
  static Future changeScreen(BuildContext context, Widget screen) {
    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => screen));
  }

  static Future changeScreenReplacement(BuildContext context, Widget screen) {
    return Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => screen));
  }
}
