import 'package:get/get.dart';
import 'package:movie_app/model/rpsingle_movie_model.dart';
import 'package:movie_app/services/network_service.dart';

class SingleMoviesController extends GetxController {
  late RpSingleMoviesModel singleMovie;

  var isLoading = false.obs;

  Future<void> fetchSingleMovie({String? movieId}) async {
    try {
      isLoading(true);
      var movies = await NetworkServices().fetchSingleMovie(movieId: movieId);
      singleMovie = movies;
    } finally {
      isLoading(false);
    }
  }
}
