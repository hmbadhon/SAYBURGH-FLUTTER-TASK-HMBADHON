import 'package:get/get.dart';
import 'package:movie_app/helper/db_helper.dart';
import 'package:movie_app/model/rpmovie_fav_model.dart';
import 'package:movie_app/model/rpsingle_movie_model.dart';
import 'package:movie_app/utils/constants.dart';

class MovieFavoriteController extends GetxController {
  var products = [].obs();
  var isLoading = false.obs;
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  void onInit() {
    // TODO: implement onInit
    queryAllFav();
    super.onInit();
  }

  Future<void> addToFav(RpSingleMoviesModel rpSingleMoviesModel) async {
    //for adding existing items to the fav
    var isExist =
        products.indexWhere((element) => element.id == rpSingleMoviesModel.id);
    if (isExist >= 0) {
      Get.snackbar(
        'Already in Favorite',
        '',
        colorText: kWhiteColor,
      );
    } else {
      RpMovieFavModel rpMovieFavModel = RpMovieFavModel(
        id: rpSingleMoviesModel.id,
        originalTitle: rpSingleMoviesModel.originalTitle,
        posterPath: rpSingleMoviesModel.posterPath,
        voteAverage: rpSingleMoviesModel.voteAverage,
      );
      _databaseHelper.insertFav(rpMovieFavModel);
      Get.snackbar(
        'Added to favorite',
        '',
        colorText: kWhiteColor,
      );
      var result = await _databaseHelper.queryAllFav();
      if (result.isNotEmpty) {
        products.assignAll(result);
      }
    }
  }

  void removeFromFav(int id) async {
    try {
      isLoading(true);
      await _databaseHelper.deleteFav(id);
      await queryAllFav();
    } finally {
      isLoading(false);
    }
  }

  Future<void> queryAllFav() async {
    try {
      isLoading(true);
      var product = await _databaseHelper.queryAllFav();
      products.assignAll(product);
    } finally {
      isLoading(false);
    }
  }
}
