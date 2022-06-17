import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class favouriteMovie {
  final int id;
  final String title;
  final String releaseDate;
  final String imagePath;

  favouriteMovie(
      {required this.title,
      required this.releaseDate,
      required this.imagePath,
      required this.id});

  factory favouriteMovie.fromMap(Map<String, dynamic> json) => favouriteMovie(
      title: json['title'],
      releaseDate: json['releaseDate'],
      imagePath: json['imagePath'],
      id: json['id']);

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'releaseDate': releaseDate,
      'imagePath': imagePath,
      'id': id
    };
  }
}

class FilmFanDatabase {
  FilmFanDatabase.privateConstructor();
  static final FilmFanDatabase instance = FilmFanDatabase.privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ?? await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory filmFanDocDir = await getApplicationDocumentsDirectory();
    String path = join(filmFanDocDir.path, 'filmfan.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
     CREATE TABLE favourites(
     id INTEGER PRIMARY KEY,
     title TEXT,
      releaseDate TEXT,
      imagePath  TEXT)
      ''');
  }

  Future<List<favouriteMovie>> getFavourites() async {
    Database db = await instance.database;
    var favouriteMovies = await db.query('favourites');
    List<favouriteMovie> listOfFavouritesMoveis = favouriteMovies.isNotEmpty
        ? favouriteMovies.map((e) => favouriteMovie.fromMap(e)).toList()
        : [];
    return listOfFavouritesMoveis;
  }

  Future<void> add(favouriteMovie favMov) async {
    Database db = await instance.database;
    await db.insert('favourites', favMov.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('favourites', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> checkIfLiked(int id) async {
    Database db = await instance.database;
    var fetched =
        await db.query('favourites', where: 'id = ?', whereArgs: [id]);
    if (fetched.isEmpty) {
      return false;
    }
    return true;
  }
}
