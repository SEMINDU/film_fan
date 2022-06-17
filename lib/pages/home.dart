import 'package:flutter/material.dart';
import 'package:film_fan/services/film_services.dart';
import 'package:film_fan/customWidget/cool_list_view.dart';
import 'package:film_fan/services/film_fan_database.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FilmServices filmServices = FilmServices();
  var nowPlaying; // variable to receive a list of plaing movies from the loading page
  bool liked = false;

  @override
  Widget build(BuildContext context) {
    nowPlaying = ModalRoute.of(context)?.settings.arguments;

    // nowPlaying.sort( (a, b) => a.compareTo(b[]));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: const Text(
          'Film Fan',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0),
        ),
        actions: [
          TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/favourites');
              },
              label: const Text(
                ' Favourites',
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(
                Icons.favorite,
                color: Colors.white,
              ))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              'Now Playing',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.blueGrey[900],
                  fontWeight: FontWeight.bold),
            ),
          ),
          coolListView(movies: nowPlaying, filmServices: filmServices)
        ],
      ),
    );
  }
}
