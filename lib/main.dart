import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:msf/constants.dart';
import 'package:msf/firebase_keys.dart' as creds;
import 'package:msf/helpers/show_interstitial_ad.dart';
import 'package:msf/pages/home.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();

  // MobileAds.instance.updateRequestConfiguration(
  //   RequestConfiguration(
  //     testDeviceIds: ["44C21CA2B517E5E19D6F9D510C330CA2"],
  //   ),
  // );
  MobileAds.instance.initialize();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: creds.apiKey,
      appId: creds.appId,
      messagingSenderId: creds.messagingSenderId,
      projectId: creds.projectId,
    ),
  );
  FirebaseMessaging.instance.subscribeToTopic("all"); // For Notification

  FullScreenAd object = FullScreenAd(); // Load Ad

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: primaryColor,
        // hintColor: primaryColor,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: secondaryColor,
          selectionHandleColor: secondaryColor,
          selectionColor: Colors.grey.withOpacity(0.5),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
            color: secondaryColor,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(secondaryColor),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ),
      home: Home(),
    );
  }
}
