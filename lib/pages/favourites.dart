import 'package:film_fan/services/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:film_fan/services/film_fan_database.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: const Text('My Favourite Movies'),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<List<favouriteMovie>>(
          future: FilmFanDatabase.instance.getFavourites(),
          builder: (BuildContext context,
              AsyncSnapshot<List<favouriteMovie>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Text('No Movie added '),
              );
            }
            return snapshot.data!.isEmpty
                ? const Center(child: Text('No Movie Added'))
                : ListView(
                    children: snapshot.data!.map((favouriteMovie) {
                      return Card(
                        child: ListTile(
                            title: Text(favouriteMovie.title),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://image.tmdb.org/t/p/w500/${favouriteMovie.imagePath}'),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    favouriteMovie.releaseDate.substring(0, 4)),
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        FilmFanDatabase.instance
                                            .remove(favouriteMovie.id);
                                      });
                                    },
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ))
                              ],
                            )),
                      );
                    }).toList(),
                  );
          },
        ),
      ),
    );
  }
}
