import 'dart:convert';
import 'dart:io';

import 'package:flutter_movies_app/movie.dart';
import 'package:http/http.dart' as http;

class HttpHelper {
  final String urlKey = 'api_key=ebf6040a7c30098f252359872d594f31';
  final String urlBase = 'https://api.themoviedb.org/3/movie';
  final String urlUpcoming = '/upcoming?';
  final String urlLanguage = '&language=en-US';
  final String urlSearchBase =
      'https://api.themoviedb.org/3/search/movie?api_key=ebf6040a7c30098f252359872d594f31&query=';

  /// Get all the up coming movies from
  /// the https://api.themoviedb.com/3
  Future<List> getUpcoming() async {
    // parse the string and return a Uri object of it
    final Uri upcoming =
        Uri.parse(urlBase + urlUpcoming + urlKey + urlLanguage);

    // GET all the up coming movies from the url 'upcoming'
    http.Response result = await http.get(upcoming);

    // check if the HTTP GET request was successfully
    if (result.statusCode == HttpStatus.ok) {
      // convert the resources into json format
      final jsonResponse = json.decode(result.body);

      // Extract the list of all the movies in json format
      final moviesMap = jsonResponse['results'];

      /// Iterate the list of all the json
      /// movie objects and convert all into
      /// a list of movie objects
      List movies = moviesMap.map((i) {
        i['vote_average'] = i['vote_average'] is String
            ? i['vote_average']
            : i['vote_average'].toString();
        return Movie.fromJson(i);
      }).toList();
      return movies;
    } else {
      return [];
    }
  }

}
