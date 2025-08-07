import 'package:flutter/material.dart';
import 'package:video_ott_app/models/movie.dart';
import 'package:video_ott_app/services/api_service.dart';

class MovieController extends ChangeNotifier {
  Movie? item;
  List<Search> movies = [];
  List<Search> movieDetail = [];
  List<Search> latestMovies = [];
  List<Search> pagedMovies = [];
  bool loader = false;


  getMoviePosters(BuildContext context) async {
    loader = true;
    String apiUrl = '&s=batman&type=movie'; // filter by title
    final response = await ApiService().request(method:'GET',url: apiUrl);
    item = movieFromJson(response);
    movies.clear();
    movies.addAll(item!.search);
    loader = false;
    notifyListeners();
  }

  getLatestMovies(BuildContext context) async {
    loader = true;
    String apiUrl = '&s=movie&type=movie&y=2022'; // filter by year
    final response = await ApiService().request(method: 'GET', url: apiUrl);
    Movie result = movieFromJson(response);
    latestMovies.clear();
    latestMovies.addAll(result.search);
    loader = false;
    notifyListeners();
  }

}