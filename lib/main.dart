import 'package:flutter/material.dart';
import 'package:film_fan/pages/loading.dart';
import 'package:film_fan/pages/home.dart';
import 'package:film_fan/pages/favourites.dart';
import 'package:film_fan/pages/movie.dart';
import 'package:film_fan/pages/similar_movies.dart';
import 'package:film_fan/pages/error.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => const Loading(),
      '/home': (context) => const Home(),
      '/favourites': (context) => const Favourites(),
      '/movie': (context) => const Movie(),
      '/similar': (context) => const Similar_Movies(),
      '/error': (context) => const ErrorPage(),
    },
  ));
}
