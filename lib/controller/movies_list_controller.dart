import 'package:get/get.dart';
import 'package:movie_app/model/rpmovies_model.dart';
import 'package:movie_app/services/network_service.dart';

class MoviesController extends GetxController {
  late RpMoviesModel moviesList;
  var isLoading = false.obs;
  bool noData = false;

  Future<void> fetchMovies() async {
    noData = false;
    try {
      isLoading(true);
      var movies = await NetworkServices().fetchMovies(page: '1');

      moviesList = movies;
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchMoviesAdd({String? page}) async {
    var add = await NetworkServices().fetchMovies(page: page);

    if (add.results.isNotEmpty) {
      try {
        isLoading(true);
        noData = false;
        for (int i = 0; i < add.results.length; i++) {
          moviesList.results.add(add.results[i]);
        }
      } finally {
        isLoading(false);
      }
    } else {
      noData = true;
    }
  }
}
