import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/controller/movie_fav_controller.dart';
import 'package:movie_app/sheared/custom_loader.dart';
import 'package:movie_app/utils/constants.dart';
import 'package:movie_app/view/home_screen/details_screen.dart';

class FavoriteScreen extends StatelessWidget {
  static const routeName = 'favorite_screen';
  FavoriteScreen({Key? key}) : super(key: key);
  final movieFavoriteController = Get.put(MovieFavoriteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Favorites'),
      ),
      body: Obx(
        () {
          if (movieFavoriteController.isLoading.isFalse) {
            if (movieFavoriteController.products.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.favorite),
                    Text(
                      'Empty Favorites!',
                      style: kHeadLine3,
                    ),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                itemCount: movieFavoriteController.products.length,
                itemBuilder: (context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsScreen(
                            movieId: movieFavoriteController.products[index].id
                                .toString(),
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        elevation: 3,
                        child: ListTile(
                          leading: CachedNetworkImage(
                            imageUrl: kImageUrl +
                                movieFavoriteController
                                    .products[index].posterPath,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const CustomLoader(),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                          ),
                          title: Text(
                            movieFavoriteController
                                .products[index].originalTitle,
                            maxLines: 2,
                          ),
                          subtitle: Text(
                            '${movieFavoriteController.products[index].voteAverage}/10',
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              Get.defaultDialog(
                                title: 'Are you sure?',
                                content: const Text('It will delete this item'),
                                actions: <Widget>[
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: kPrimaryColor,
                                    ),
                                    onPressed: () {
                                      movieFavoriteController.removeFromFav(
                                          movieFavoriteController
                                              .products[index].id);
                                      Navigator.of(context).pop(true);
                                      Get.snackbar(
                                        'Deleted',
                                        '',
                                        colorText: kWhiteColor,
                                      );
                                    },
                                    child: const Text("Confirm"),
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(color: kPrimaryColor),
                                    ),
                                  ),
                                ],
                              );
                            },
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          } else {
            return const Center(
              child: CustomLoader(),
            );
          }
        },
      ),
    );
  }
}
