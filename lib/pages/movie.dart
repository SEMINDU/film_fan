import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:film_fan/services/film_services.dart';
import 'package:film_fan/services/film_fan_database.dart';

class Movie extends StatefulWidget {
  const Movie({Key? key}) : super(key: key);

  @override
  State<Movie> createState() => _MovieState();
}

class _MovieState extends State<Movie> {
  FilmServices filmServices = FilmServices();
  var selectedMovie;
  List similarMovies = [];
  double rating = 0.0;
  List castList = [];
  bool liked = false; //for checking if movie is liked or not by the user
  bool rated = false;

  void fetchLikeStatus(int Id) async {
    var result = await FilmFanDatabase.instance.checkIfLiked(Id);
    setState(() {
      liked = result;
    });
  }

  //function to show dialog
  void showRatingDialog(String movieTitle) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(movieTitle),
            content: SizedBox(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(rated
                      ? 'You Rated :$rating'
                      : 'Tap on star to select the movie rating'),
                  RatingBar.builder(
                    initialRating: rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 10,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    maxRating: 10,
                    itemSize: 40, //max rating
                    updateOnDrag: true,
                    onRatingUpdate: (rating) {
                      this.rating = rating;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    bool r = await filmServices.postRating(
                        selectedMovie['id'], rating);

                    setState(() {
                      rated = r;
                    });

                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    });
                  },
                  child: const Text('Submit')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    selectedMovie = ModalRoute.of(context)?.settings.arguments;
    castList = selectedMovie['cast'];

    fetchLikeStatus(selectedMovie['id']);

    // Added to favourite or not toggle functionality

    void likeToggle() async {
      if (liked) {
        await FilmFanDatabase.instance.remove(selectedMovie['id']);
      } else {
        await FilmFanDatabase.instance.add(favouriteMovie(
            title: selectedMovie['original_title'],
            releaseDate: selectedMovie['release_date'],
            imagePath: selectedMovie['poster_path'],
            id: selectedMovie['id']));
      }

      setState(() {
        if (liked) {
          liked = false;

          print('Unliked');
        } else {
          liked = true;

          print('Liked');
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.blueGrey[900],
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(24),
                child: Container(
                    color: Colors.white,
                    width: double.maxFinite,
                    child: Card(
                        child: Column(children: [
                      ListTile(
                        leading: const Icon(Icons.movie),
                        title: Text(selectedMovie['original_title'],
                            style: const TextStyle(fontSize: 18)),
                        subtitle: Text(
                          selectedMovie['release_date']
                              .toString()
                              .substring(0, 4),
                          style: const TextStyle(fontSize: 18),
                        ),
                      )
                    ])))),
            pinned: true,
            expandedHeight: 450,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                'https://image.tmdb.org/t/p/w500/${selectedMovie['poster_path']}',
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Card(
                child: Column(
              children: [
                Row(
                  children: [
                    TextButton.icon(
                        onPressed: () {
                          likeToggle();
                        },
                        icon: (liked
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_border,
                                color: Colors.black45,
                              )),
                        label: Text(
                          liked ? 'Added to favourites' : 'Add to favourites',
                          style: TextStyle(
                              color: liked ? Colors.red : Colors.black45),
                        )),
                    TextButton.icon(
                        onPressed: () async {
                          await filmServices.fetchSimilar(selectedMovie['id']);
                          setState(() {
                            similarMovies =
                                filmServices.fetchedMovies['results'];
                          });

                          // print(similarMovies);
                          Navigator.pushNamed(context, '/similar',
                              arguments: similarMovies);
                        },
                        icon: (const Icon(
                          Icons.view_carousel_outlined,
                          color: Colors.black45,
                        )),
                        label: const Text(
                          'View Similar',
                          style: TextStyle(color: Colors.black45),
                        ))
                  ],
                ),
                ListTile(
                  title: const Text('Overview', style: TextStyle(fontSize: 18)),
                  subtitle: Text(selectedMovie['overview'],
                      style: const TextStyle(fontSize: 18)),
                ),
                ListTile(
                  leading: const Icon(Icons.category),
                  title: const Text('Genre'),
                  subtitle: Text(selectedMovie['genre']),
                ),
                Container(),
                const ListTile(
                  leading: Icon(Icons.people),
                  title: Text('Cast'),
                )
              ],
            )),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(childCount: castList.length,
                (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                  child: Card(
                    child: ListTile(
                      title: Text(castList[index]['name']),
                      subtitle: Text('As ${castList[index]['character']}'),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://image.tmdb.org/t/p/w500/${castList[index]['profile_path']}'),
                      ),
                    ),
                  ),
                ),
              );
            }),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 500,
                mainAxisSpacing: 2,
                crossAxisSpacing: 1,
                childAspectRatio: 4),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        //for rating
        onPressed: () => showRatingDialog(selectedMovie['original_title']),
        icon: const Icon(Icons.star_rate),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.blueGrey[900],
        label: const Text('Rate'),
      ),
    );
  }
}
