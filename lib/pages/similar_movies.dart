import 'package:flutter/material.dart';
import 'package:film_fan/services/film_services.dart';
import 'package:film_fan/customWidget/cool_list_view.dart';

class Similar_Movies extends StatefulWidget {
  const Similar_Movies({Key? key}) : super(key: key);

  @override
  State<Similar_Movies> createState() => _Similar_MoviesState();
}

class _Similar_MoviesState extends State<Similar_Movies> {
  FilmServices filmServices = FilmServices();

  var similarMovies; // variable to receive a list of playing movies from the loading page

  @override
  Widget build(BuildContext context) {
    similarMovies = ModalRoute.of(context)?.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: const Text(
          'Similar Movies',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          coolListView(movies: similarMovies, filmServices: filmServices)
        ],
      ),
    );
  }
}
