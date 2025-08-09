import 'package:flutter/material.dart';
import 'package:video_ott_app/models/movie.dart';
import 'package:video_ott_app/services/api_service.dart';
import 'package:video_ott_app/models/movie_detail.dart';

class MovieController extends ChangeNotifier {
  Movie? item;
  List<Search> movies = [];
  List<Search> movieDetail = [];
  List<Search> latestMovies = [];
  List<Search> pagedMovies = [];
  int currentPage = 1;
  bool loader = false;
  bool isFetching = false;
  bool hasMore = true;
  MovieDetail? selectedMovieDetail;


  getMoviePosters(BuildContext context) async {
    loader = true;
    String apiUrl = '&s=batman&type=movie'; // filter by title

    final response = await ApiService().request(method:'GET',url: apiUrl, context: context);
    item = movieFromJson(response);

    movies.clear();
    movies.addAll(item!.search);

    loader = false;
    notifyListeners();
  }

  getLatestMovies(BuildContext context) async {
    loader = true;
    String apiUrl = '&s=movie&type=movie&y=2022'; // filter by year

    final response = await ApiService().request(method: 'GET', url: apiUrl, context: context);
    Movie result = movieFromJson(response);

    latestMovies.clear();
    latestMovies.addAll(result.search);

    loader = false;
    notifyListeners();
  }

  Future<void> getMoviesWithPagination(String keyword) async {
    if (isFetching || !hasMore) return;

    isFetching = true;
    notifyListeners();

    final response = await ApiService().request(
      method: 'GET',
      url: '&s=$keyword&type=movie&page=$currentPage',
    );

    final movieData = movieFromJson(response);

    if (movieData.search.isEmpty) {
      hasMore = false;
    } else {
      pagedMovies.addAll(movieData.search);
      currentPage++;
    }

    isFetching = false;
    notifyListeners();
  }

  Future<void> getMovieDetail(String imdbId) async {
    final url = '&i=$imdbId&plot=full';
    final response = await ApiService().request(method: 'GET', url: url);

    selectedMovieDetail = movieDetailFromJson(response);
    notifyListeners();
  }

}