import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'splash.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: FToastBuilder(),
      home: SplashPage(),
      navigatorKey: navigatorKey,
    );
  }
}
