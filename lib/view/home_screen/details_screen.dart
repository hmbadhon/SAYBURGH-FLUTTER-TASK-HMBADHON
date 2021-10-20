import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:movie_app/controller/movie_fav_controller.dart';
import 'package:movie_app/controller/single_movie_controller.dart';
import 'package:movie_app/sheared/custom_loader.dart';
import 'package:movie_app/utils/constants.dart';
import 'package:movie_app/utils/size_config.dart';

class DetailsScreen extends StatelessWidget {
  static const routeName = 'details_screen';
  final String? movieId;
  DetailsScreen({
    Key? key,
    this.movieId,
  }) : super(key: key);
  final SingleMoviesController _singleMoviesController = Get.find();
  final MovieFavoriteController movieFavoriteController = Get.find();

  @override
  Widget build(BuildContext context) {
    _singleMoviesController.fetchSingleMovie(movieId: movieId);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () {
          if (_singleMoviesController.isLoading.isTrue) {
            return const Center(
              child: CustomLoader(),
            );
          } else {
            if (_singleMoviesController.singleMovie.isBlank!) {
              return Center(
                child: Text(
                  'No Movies Available',
                  style: kRegularText,
                ),
              );
            } else {
              return Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: SizeConfig.screenWidth / 1.5,
                        child: CachedNetworkImage(
                          imageUrl: kImageUrl +
                              _singleMoviesController.singleMovie.backdropPath,
                          fit: BoxFit.fill,
                          placeholder: (context, url) => SizedBox(
                            width: double.infinity,
                            height: SizeConfig.screenWidth / 1.5,
                            child: const CustomLoader(),
                          ),
                          errorWidget: (context, url, error) => SizedBox(
                            width: double.infinity,
                            height: SizeConfig.screenWidth / 1.5,
                            child: const Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 10,
                        child: SafeArea(
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: kWhiteColor,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 10,
                        child: SafeArea(
                          child: IconButton(
                            onPressed: () {
                              movieFavoriteController.addToFav(
                                _singleMoviesController.singleMovie,
                              );
                            },
                            icon: const Icon(
                              Icons.favorite_border,
                              color: kWhiteColor,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: getProportionateScreenWidth(-110),
                        left: getProportionateScreenWidth(25),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 2,
                              color: kPrimaryColor,
                            ),
                          ),
                          width: getProportionateScreenWidth(150),
                          height: getProportionateScreenWidth(200),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: kImageUrl +
                                  _singleMoviesController
                                      .singleMovie.posterPath,
                              fit: BoxFit.fill,
                              placeholder: (context, url) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 2,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                width: getProportionateScreenWidth(150),
                                height: getProportionateScreenWidth(200),
                                child: const CustomLoader(),
                              ),
                              errorWidget: (context, url, error) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 2,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                width: getProportionateScreenWidth(150),
                                height: getProportionateScreenWidth(200),
                                child: const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: _singleMoviesController
                                          .singleMovie.voteCount
                                          .toString(),
                                      style: kRegularText2.copyWith(
                                        color: kBlackColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' Peoples voted',
                                      style: kRegularText2.copyWith(
                                        color: kBlackColor.withOpacity(.6),
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Wrap(
                                children: [
                                  for (int i = 0;
                                      i <
                                          _singleMoviesController
                                              .singleMovie.genres.length;
                                      i++)
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: _singleMoviesController
                                                .singleMovie.genres[i].name,
                                            style: kRegularText2.copyWith(
                                              color:
                                                  kBlackColor.withOpacity(.6),
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          TextSpan(
                                            text: i ==
                                                    _singleMoviesController
                                                            .singleMovie
                                                            .genres
                                                            .length -
                                                        1
                                                ? ''
                                                : ', ',
                                            style: kRegularText2.copyWith(
                                              color:
                                                  kBlackColor.withOpacity(.6),
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text(
                                    _singleMoviesController
                                        .singleMovie.voteAverage
                                        .toString(),
                                    style: kRegularText2.copyWith(
                                      color: _singleMoviesController
                                                  .singleMovie.voteAverage >
                                              5
                                          ? kSuccessColor
                                          : kErrorColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  RatingBarIndicator(
                                    rating: _singleMoviesController
                                            .singleMovie.voteAverage /
                                        2,
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: _singleMoviesController
                                                  .singleMovie.voteAverage >
                                              5
                                          ? kSuccessColor
                                          : kErrorColor,
                                    ),
                                    itemCount: 5,
                                    itemSize: 18.0,
                                    direction: Axis.horizontal,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                _singleMoviesController.singleMovie.releaseDate,
                                style: kSmallText.copyWith(
                                  color: kBlackColor.withOpacity(.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 10,
                    ),
                    child: Text(
                      _singleMoviesController.singleMovie.overview,
                      style: kRegularText2.copyWith(
                        color: kBlackColor,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              );
            }
          }
        },
      ),
    );
  }
}
