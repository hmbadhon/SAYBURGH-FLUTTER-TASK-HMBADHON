import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:movie_app/model/rpmovies_model.dart';
import 'package:movie_app/model/rpsingle_movie_model.dart';

class NetworkServices {
  static const String baseUrl = "https://api.themoviedb.org/3/movie/";
  static const String apiKey = '?api_key=5c47dbfff6b4eb2c731bd11f1c1c83eb';
  static var client = http.Client();

  Future<RpMoviesModel> fetchMovies({String? page}) async {
    var uri = Uri.parse(baseUrl + 'popular' + apiKey + '&page=$page');
    http.Response response = await client.get(uri);
    if (response.statusCode == 200) {
      var posts = jsonDecode(response.body);
      log(response.statusCode.toString());
      return RpMoviesModel.fromJson(posts);
    } else {
      log(response.statusCode.toString());
      throw Exception('Fail to load');
    }
  }

  Future<RpSingleMoviesModel> fetchSingleMovie({String? movieId}) async {
    var uri = Uri.parse(baseUrl + movieId.toString() + apiKey);
    http.Response response = await client.get(uri);
    if (response.statusCode == 200) {
      var posts = jsonDecode(response.body);
      log(response.statusCode.toString());
      return RpSingleMoviesModel.fromJson(posts);
    } else {
      log(response.statusCode.toString());
      throw Exception('Fail to load');
    }
  }
}
