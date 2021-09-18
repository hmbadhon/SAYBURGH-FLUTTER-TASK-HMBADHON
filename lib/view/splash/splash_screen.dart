import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_app/utils/constants.dart';
import 'package:movie_app/utils/size_config.dart';
import 'package:movie_app/view/home_screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = 'splash_screen';
  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  @override
  void initState() {
    // TODO: implement initState
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _animation.addListener(() => setState(() {}));
    _animationController.forward();
    Timer(
      const Duration(seconds: 2),
      () => Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.routeName, (route) => false),
    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: RotationTransition(
          turns: _animation,
          child: Image.asset(
            kImageDir + 'logo.png',
            width: _animation.value * 250,
            height: _animation.value * 250,
          ),
        ),
      ),
    );
  }
}
