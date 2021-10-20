import 'package:flutter/material.dart';
import 'package:movie_app/view/auth/login_screen.dart';
import 'package:movie_app/view/auth/signup_screen.dart';
import 'package:movie_app/view/favorite/favorite_screen.dart';
import 'package:movie_app/view/home_screen/details_screen.dart';
import 'package:movie_app/view/home_screen/home_screen.dart';
import 'package:movie_app/view/root/main_screen.dart';
import 'package:movie_app/view/splash/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  MainScreen.routeName: (context) => const MainScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  FavoriteScreen.routeName: (context) => FavoriteScreen(),
};
