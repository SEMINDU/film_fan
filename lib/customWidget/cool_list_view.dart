import 'package:flutter/material.dart';
import 'package:film_fan/services/film_services.dart';
import 'package:film_fan/services/film_fan_database.dart';

class coolListView extends StatefulWidget {
  coolListView({
    Key? key,
    required this.movies,
    required this.filmServices,
  }) : super(key: key);
  List liked = [];
  List movies;
  FilmServices filmServices;

  @override
  State<coolListView> createState() => _coolListViewState();
}

class _coolListViewState extends State<coolListView> {
  @override
  Widget build(BuildContext context) {
    void likeToggle(int index) async {
      if (widget.liked.contains(index)) {
        await FilmFanDatabase.instance.remove(widget.movies[index]['id']);
        widget.liked.remove(index);
      } else {
        await FilmFanDatabase.instance.add(favouriteMovie(
            title: widget.movies[index]['original_title'],
            releaseDate: widget.movies[index]['release_date'],
            imagePath: widget.movies[index]['poster_path'],
            id: widget.movies[index]['id']));
        widget.liked.add(index);
      }
    }

    return Expanded(
        child: ListView.builder(
            itemCount: widget.movies.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () async {
                  // Fetch selected movie genre
                  widget.movies[index]['genre'] = await widget.filmServices
                      .fetchGenre(widget.movies[index]['genre_ids']);
                  widget.movies[index]['cast'] = await widget.filmServices
                      .fetchCast(widget.movies[index]['id']);
                  //once pressed will redirect to a single move page
                  Navigator.pushNamed(context, '/movie',
                      arguments: widget.movies[index]);
                },
                child: Container(
                  height: 150.0,
                  margin: const EdgeInsets.all(20.0),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                              'https://image.tmdb.org/t/p/w500/${widget.movies[index]['poster_path']}',
                              fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.9),
                                    Colors.transparent
                                  ])),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.movies[index]['original_title'],
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Release Date: ${widget.movies[index]['release_date']}',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 5),
                                  Column(
                                    children: [
                                      Text(
                                        'Average Voting: ${widget.movies[index]['vote_average']}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  likeToggle(index);
                                },
                                icon: (widget.liked.contains(index)
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      )
                                    : const Icon(
                                        Icons.favorite,
                                        color: Colors.white,
                                        size: 30,
                                      )),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }));
  }
}
