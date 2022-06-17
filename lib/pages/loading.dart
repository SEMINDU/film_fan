import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:film_fan/services/film_services.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    fetch();
    super.initState();
  }

  FilmServices filmServices_instance = FilmServices();

  List nowPlaying = [];

  void fetch() async {
    ''' 
    This function for fetching film from the API and returning  the film objects
    on the page requested
    ''';
    Future.delayed(const Duration(seconds: 12), () {
      if (nowPlaying.isEmpty) {
        Navigator.pushNamed(context, '/error');
      }
    });
    await filmServices_instance.fetchNowPlaying();

    setState(() {
      nowPlaying = filmServices_instance.fetchedMovies['results'];
    });

    Navigator.pushReplacementNamed(context, '/home', arguments: nowPlaying);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[900],
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            //loading animation
            SpinKitCubeGrid(
              color: Colors.white,
              size: 80.0,
            ),
            SizedBox(height: 5.0),
            Text(
              'Film Fan',
              style: TextStyle(
                  letterSpacing: 1.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0),
            )
          ],
        )));
  }
}
