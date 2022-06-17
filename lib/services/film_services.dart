import 'package:film_fan/services/global_variable.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'dart:convert';

class FilmServices {
  var fetchedMovies;

  var cast;

  //API Settings
  final String apikey = '772fb34ee950ed9ae38e9959a244c4e8';
  final readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3NzJmYjM0ZWU5NTBlZDlhZTM4ZTk5NTlhMjQ0YzRlOCIsInN1YiI6IjYyYTliZGQwNWE1ZWQwMzI2YTliNWVlNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.8Uak9iRBmxFt4OSsRvNIPkIQ1Py0CvzkzBWZqsKDKEE';

  Future<void> fetchNowPlaying() async {
    ''' 
    This function for fetching film from the API and returning  the film objects
    on the page requested
    ''';
    try {
      TMDB customtmdb = TMDB(ApiKeys(apikey, readaccesstoken),
          logConfig: const ConfigLogger(
            //to be deleted
            showLogs: true,
            showErrorLogs: true,
          ));

      fetchedMovies = await customtmdb.v3.movies.getNowPlaying();
    } catch (e) {
      fetchedMovies = null;
    }
  }

  Future<void> fetchSimilar(int movieId) async {
    ''' 
    This function for fetching film from the API and returning  the film objects
    on the page requested
    ''';
    try {
      TMDB customtmdb = TMDB(ApiKeys(apikey, readaccesstoken),
          logConfig: ConfigLogger(
            //to be deleted
            showLogs: true,
            showErrorLogs: true,
          ));

      fetchedMovies = await customtmdb.v3.movies.getSimilar(movieId);
    } catch (e) {
      fetchedMovies = null;
    }
  }

  Future<String> fetchGenre(List list) async {
    String movieGenre = "| ";
    List genreList = [];

    Response response = await get(Uri.parse(
        'https://api.themoviedb.org/3/genre/movie/list?api_key=$apikey&language=en-US&id=28'));
    Map results = jsonDecode(response.body);
    genreList = results['genres'];
    list.forEach((listItem) {
      genreList.forEach((element) {
        if (element['id'] == listItem) {
          movieGenre = "${movieGenre + element['name']} | ";
        }
      });
    });
    return movieGenre;
  }

  Future<List> fetchCast(int movieId) async {
    '''
    This function for fetching cast from the API and returning  the film objects
    on the page requested
    ''';
    Response response = await get(Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId/credits?api_key=$apikey&language=en-US&id=28'));
    Map results = jsonDecode(response.body);

    return results['cast'];
  }

  Future<bool> postRating(int movieId, double ratingValue) async {
    bool rated = false;
    '''
    This function for posting cast from the API and returning  the film objects
    on the page requested
    ''';

    Response response;
    Map result;

    //creating TMDB object

    TMDB customtmdb = TMDB(ApiKeys(apikey, readaccesstoken),
        logConfig: const ConfigLogger(
          //to be deleted
          showLogs: true,
          showErrorLogs: true,
        ));

    // check for if session is expired
    if (sessionId.isNotEmpty) {
      if (DateTime.now().isAfter(sessionExpiry)) {
        sessionId = "";
      }
    }

    if (sessionId.isEmpty) {
      response = await get(Uri.parse(
          'https://api.themoviedb.org/3/authentication/guest_session/new?api_key=$apikey'));
      result = jsonDecode(response.body);

      sessionId = result['guest_session_id'];

      sessionExpiry =
          DateTime.parse(result['expires_at'].toString().substring(0, 19));

      result = await customtmdb.v3.movies
          .rateMovie(movieId, ratingValue, guestSessionId: sessionId);

      rated = result['success'];
    } else {
      result = await customtmdb.v3.movies
          .rateMovie(movieId, ratingValue, guestSessionId: sessionId);

      rated = result['success'];
    }
    return rated;
  }
}
