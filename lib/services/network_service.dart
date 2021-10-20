import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/model/rpmovies_model.dart';
import 'package:movie_app/model/rpsingle_movie_model.dart';
import 'package:movie_app/sheared/custom_loader.dart';
import 'package:movie_app/utils/constants.dart';

import '../main.dart';

class NetworkServices {
  static const String baseUrl = "https://api.themoviedb.org/3/movie/";
  static const String wpBaseUrl = "https://apptest.dokandemo.com/wp-json/";
  static const String register = "wp/v2/users/register";
  static const String logIn = "jwt-auth/v1/token";
  static const String updateProfile = "wp/v2/users/me";
  static const String apiKey = '?api_key=5c47dbfff6b4eb2c731bd11f1c1c83eb';
  static var client = http.Client();

  ///auth start here ///
  Future createUser({
    BuildContext? context,
    String? username,
    String? email,
    String? password,
  }) async {
    showDialog(
      context: context!,
      barrierDismissible: false,
      builder: (_) => CustomLoader(
        color: kWhiteColor,
      ),
    );
    var body = json.encode({
      "username": username,
      "email": email,
      "password": password,
    });
    var uri = Uri.parse(wpBaseUrl + register);
    http.Response response = await client.post(
      uri,
      body: body,
      headers: {
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      var posts = jsonDecode(response.body);
      log(response.statusCode.toString());
      log(response.body.toString());
      return posts;
    } else if (response.statusCode == 400) {
      var posts = jsonDecode(response.body);
      log(response.statusCode.toString());
      log(response.body.toString());
      return posts;
    } else {
      log(response.statusCode.toString());
      log(response.body.toString());
      throw Exception('Fail to load');
    }
  }

  Future logInUser({
    BuildContext? context,
    String? username,
    String? password,
  }) async {
    showDialog(
      context: context!,
      barrierDismissible: false,
      builder: (_) => CustomLoader(
        color: kWhiteColor,
      ),
    );
    var uri =
        Uri.parse(wpBaseUrl + logIn + '?username=$username&password=$password');
    http.Response response = await client.post(
      uri,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
    );
    if (response.statusCode == 200) {
      var posts = jsonDecode(response.body);
      log(response.statusCode.toString());
      log(response.body.toString());
      return posts;
    } else {
      var posts = jsonDecode(response.body);
      log(response.statusCode.toString());
      log(response.body.toString());
      return posts;
    }
  }

  Future updateUserProfile({
    BuildContext? context,
    String? firstName,
    String? lastName,
  }) async {
    showDialog(
      context: context!,
      barrierDismissible: false,
      builder: (_) => CustomLoader(
        color: kWhiteColor,
      ),
    );
    var uri = Uri.parse(wpBaseUrl +
        updateProfile +
        '?first_name=$firstName&last_name=$lastName');
    http.Response response = await client.post(
      uri,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${prefs!.getString('token')}',
      },
    );
    if (response.statusCode == 200) {
      var posts = jsonDecode(response.body);
      log(response.statusCode.toString());
      log(response.body.toString());
      return posts;
    } else {
      log(response.statusCode.toString());
      log(response.body.toString());
      return response.statusCode;
    }
  }

  Future getUserProfile({
    BuildContext? context,
  }) async {
    showDialog(
      context: context!,
      barrierDismissible: false,
      builder: (_) => CustomLoader(
        color: kWhiteColor,
      ),
    );
    var uri = Uri.parse(wpBaseUrl + updateProfile);
    http.Response response = await client.post(
      uri,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${prefs!.getString('token')}',
      },
    );
    if (response.statusCode == 200) {
      var posts = jsonDecode(response.body);
      log(response.statusCode.toString());
      log(response.body.toString());
      return posts;
    } else {
      log(response.statusCode.toString());
      log(response.body.toString());
      return response.statusCode;
    }
  }

  ///auth end here ///

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
