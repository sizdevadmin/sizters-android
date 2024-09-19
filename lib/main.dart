// ignore_for_file: unused_catch_clause, empty_catches, must_be_immutable

import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:siz/Pages/ProductView.dart';
import 'LoginSignUp/Splash.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyAppLogin());
  
}

class MyAppLogin extends StatefulWidget {
  const MyAppLogin({super.key});
  @override
  State<MyAppLogin> createState() => _MyAppLoginState();
}

class _MyAppLoginState extends State<MyAppLogin> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    // Check initial link if app was in cold state (terminated)
    final appLink = await _appLinks.getInitialAppLink();
    if (appLink != null) {
      openAppLink(appLink);
    }

    // Handle link when app is in warm state (front or background)
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      openAppLink(uri);
    });
  }

  void openAppLink(Uri uri) {
    _navigatorKey.currentState!.pushAndRemoveUntil(
        PageTransition(
            duration: const Duration(milliseconds: 500),
            type: PageTransitionType.rightToLeft,
            child: ProductView(
                index: 0,
                id: uri.path.replaceAll("/product/", ""),
                fromCart: false,
                comesFrom: "uri"),
            isIos: true),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 0.9),
              child: child as Widget);
        },
        navigatorKey: _navigatorKey,
        color: Colors.black,
        theme: ThemeData(
          textTheme:
              GoogleFonts.lexendDecaTextTheme(Theme.of(context).textTheme),
          splashFactory: NoSplash.splashFactory,
          splashColor: Colors.transparent,
          primarySwatch: const MaterialColor(0xFFAF1010, {
            50: Color(0xFFAF1010),
            100: Color(0xFFAF1010),
            200: Color(0xFFAF1010),
            300: Color(0xFFAF1010),
            400: Color(0xFFAF1010),
            500: Color(0xFFAF1010),
            600: Color(0xFFAF1010),
            700: Color(0xFFAF1010),
            800: Color(0xFFAF1010),
            900: Color(0xFFAF1010),
          }),
        ),
        debugShowCheckedModeBanner: false,
        routes: {"/": (context) => Splash()});
  }
}

// FilterClothesSize

