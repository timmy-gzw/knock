import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'knock.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // 延迟1秒进入后面
    startCountdownTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SvgPicture.asset(
          "assets/svg/icon.svg",
          width: 150,
          height: 150,
          colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
        ),
      ),
    );
  }

  void startCountdownTimer() {
    const timeout = Duration(milliseconds: 1500);
    Timer(timeout, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const KnockPage()),
      );
    });
  }
}
