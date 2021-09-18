import 'package:flutter/material.dart';
import 'package:movie_app/view/favorite/favorite_screen.dart';
import 'package:movie_app/view/home_screen/details_screen.dart';
import 'package:movie_app/view/home_screen/home_screen.dart';
import 'package:movie_app/view/splash/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
};
