import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_movies_app/http_helper.dart';

import 'movie.dart';
import 'movie_detail.dart';

class MovieList extends StatefulWidget {
  const MovieList({Key? key}) : super(key: key);

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  List<dynamic> upcomingMovies = [];
  List<dynamic> searchedMovies = [];
  int moviesCount = 0;
  HttpHelper helper = HttpHelper();
  final String iconBase = 'https://image.tmdb.org/t/p/w92';
  final String defaultImage =
      'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';
  Icon visibleIcon = Icon(
    Icons.search,
    color: Colors.white,
  );
  Widget searchBarText = Text('Movies');
  TextEditingController _controller = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    helper = HttpHelper();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NetworkImage image;

    return Scaffold(
      appBar: buildAppBar(context),
      body: searchedMovies.length <= 0 || _controller.text.isEmpty
          ? ListView.builder(
              itemCount: this.moviesCount,
              itemBuilder: (BuildContext context, int position) {
                if (upcomingMovies[position].posterPath != null) {
                  image = NetworkImage(
                      iconBase + upcomingMovies[position].posterPath);
                } else {
                  image = NetworkImage(defaultImage);
                }
                return Card(
                  color: Colors.white,
                  elevation: 2.0,
                  child: ListTile(
                    onTap: () {
                      MaterialPageRoute route = MaterialPageRoute(
                        builder: (_) => MovieDetail(upcomingMovies[position]),
                      );
                      Navigator.push(context, route);
                    },
                    leading: CircleAvatar(
                      backgroundImage: image,
                    ),
                    title: Text(upcomingMovies[position].title),
                    subtitle: Text('Release: ' +
                        upcomingMovies[position].releaseDate +
                        ' - Vote: ' +
                        upcomingMovies[position].voteAverage),
                  ),
                );
              })
          : ListView.builder(
              itemCount: searchedMovies.length,
              itemBuilder: (BuildContext context, int position) {
                if (upcomingMovies[position].posterPath != null) {
                  image = NetworkImage(
                      iconBase + upcomingMovies[position].posterPath);
                } else {
                  image = NetworkImage(defaultImage);
                }
                return Card(
                  color: Colors.white,
                  elevation: 2.0,
                  child: ListTile(
                    onTap: () {
                      MaterialPageRoute route = MaterialPageRoute(
                        builder: (_) => MovieDetail(searchedMovies[position]),
                      );
                      Navigator.push(context, route);
                    },
                    leading: CircleAvatar(
                      backgroundImage: image,
                    ),
                    title: Text(searchedMovies[position].title),
                    subtitle: Text('Release: ' +
                        searchedMovies[position].releaseDate +
                        ' - Vote: ' +
                        searchedMovies[position].voteAverage),
                  ),
                );
              },
            ),
    );
  }
  /// build the custom AppBar widget
  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      title: this.searchBarText,
      centerTitle: true,
      actions: [
        IconButton(
          icon: visibleIcon,
          onPressed: () {
            setState(() {
              if (this.visibleIcon.icon == Icons.search) {
                this.visibleIcon = Icon(
                  Icons.close,
                  color: Colors.white,
                );
                this.searchBarText = TextField(
                  controller: _controller,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  onChanged: search,
                );
                startSearching();
              } else {
                endSearching();
                this.visibleIcon = Icon(Icons.search);
                this.searchBarText = Text('Movies');
              }
            });
          },
        ),
      ],
    );
  }

  /// add the event listener to the TextEditintController
  /// instance and check if the ccontroller text property
  /// is not empty. if it isn't, set to true the search flag
  void startSearching() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          isSearching = false;
        });
      } else {
        setState(() {
          isSearching = true;
        });
      }
    });
  }

  /// deactivate the search operation
  /// and resetting the search icon and title appbar
  void endSearching() {
    setState(() {
      _controller.clear();
      isSearching = false;
      visibleIcon = Icon(Icons.search, color: Colors.white);
      searchBarText = Text('Movies');
    });
  }

  /// GET all the upcoming movies from themoviedb.org with
  Future initialize() async {
    upcomingMovies = await helper.getUpcoming();
    setState(() {
      moviesCount = upcomingMovies.length;
      upcomingMovies = upcomingMovies;
    });
  }

  /// clear the previous searched movies first, next
  /// check if the search is set to true. if yes, then
  /// iterate the whole movie list, and adding to the
  /// searchedMovies list all movies of which titles contains
  /// the text that is being typed
  void search(text) {
    searchedMovies.clear();
    if (isSearching) {
      for (int i = 0; i < upcomingMovies.length; i++) {
        Movie movie = upcomingMovies[i];
        if (movie.title.toLowerCase().contains(text.toLowerCase())) {
          searchedMovies.add(movie);
        }
      }
    }
  }
}
