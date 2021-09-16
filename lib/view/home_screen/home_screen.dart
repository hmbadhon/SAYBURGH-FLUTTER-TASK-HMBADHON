import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:movie_app/controller/movies_list_controller.dart';
import 'package:movie_app/sheared/custom_loader.dart';
import 'package:movie_app/utils/constants.dart';

import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'home_screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MoviesController _moviesController = Get.put(MoviesController());
  final _scrollController = ScrollController();
  int page = 1;

  @override
  void initState() {
    fetchMovies();
    _scrollController.addListener(addMovies);
    super.initState();
  }

  void fetchMovies() async {
    await _moviesController.fetchMovies();
  }

  void addMovies() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      log('Item added');
      page++;
      await _moviesController.fetchMoviesAdd(page: page.toString());
      if (_moviesController.noData == true) {
        Get.snackbar('No More Items', '', colorText: kWhiteColor);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie App'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.favorite_border,
            ),
          ),
        ],
      ),
      body: Obx(
        () {
          if (_moviesController.isLoading.isTrue) {
            return const Center(
              child: CustomLoader(),
            );
          } else {
            if (_moviesController.moviesList.results.isEmpty) {
              return const Center(
                child: Text('No Items Available'),
              );
            } else {
              return StaggeredGridView.countBuilder(
                controller: _scrollController,
                crossAxisCount: 2,
                shrinkWrap: true,
                itemCount: _moviesController.moviesList.results.length,
                physics: const ScrollPhysics(),
                staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, DetailsScreen.routeName);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              imageUrl: kImageUrl +
                                  _moviesController
                                      .moviesList.results[index].posterPath,
                              fit: BoxFit.fitHeight,
                              placeholder: (context, url) => const AspectRatio(
                                aspectRatio: 2 / 3,
                                child: CustomLoader(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const AspectRatio(
                                aspectRatio: 2 / 3,
                                child: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 5,
                            child: Chip(
                              backgroundColor: kWhiteColor,
                              label: Text(
                                _moviesController
                                    .moviesList.results[index].voteAverage
                                    .toString(),
                                style: kRegularText2.copyWith(
                                  color: _moviesController.moviesList
                                              .results[index].voteAverage! >
                                          5.0
                                      ? kSuccessColor
                                      : kErrorColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              avatar: const Icon(
                                Icons.star,
                                color: kGoldColor,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              _moviesController
                                  .moviesList.results[index].originalTitle,
                              style: kRegularText2.copyWith(
                                color: kWhiteColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
