import 'package:get/get.dart';
import 'package:movie_app/controller/movie_fav_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controller/movies_list_controller.dart';
import 'controller/single_movie_controller.dart';
import 'main.dart';

Future<void> init() async {
  prefs = await SharedPreferences.getInstance();
  Get.lazyPut(
    () => MoviesController(),
    fenix: true,
  );
  Get.lazyPut(
    () => SingleMoviesController(),
    fenix: true,
  );
  Get.lazyPut(
    () => MovieFavoriteController(),
    fenix: true,
  );
}
