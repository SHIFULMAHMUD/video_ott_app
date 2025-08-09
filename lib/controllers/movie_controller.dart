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

    movies.clear(); // Clear existing movie list
    movies.addAll(item!.search);  // Add new movie search results

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
    if (isFetching || !hasMore) return; // Prevent multiple simultaneous fetches or fetching if no more data

    isFetching = true; // Indicate that fetching has started
    notifyListeners(); // Notify UI to show loading state

    final response = await ApiService().request(
      method: 'GET',
      url: '&s=$keyword&type=movie&page=$currentPage',
    ); // Make the API request with the search keyword, type, and current page number

    final movieData = movieFromJson(response); // Parse the JSON response into movie data model

    if (movieData.search.isEmpty) {
      hasMore = false; // No more results, mark hasMore as false to stop further requests
    } else {
      pagedMovies.addAll(movieData.search); // Append newly fetched movies to the existing list
      currentPage++; // Increment page number for next fetch
    }

    isFetching = false; // Fetching is complete
    notifyListeners(); // Notify UI to update with new data or state
  }

  Future<void> getMovieDetail(String imdbId) async {
    final url = '&i=$imdbId&plot=full'; // Construct URL with IMDb ID and request full plot details
    final response = await ApiService().request(method: 'GET', url: url);

    selectedMovieDetail = movieDetailFromJson(response); // Parse response and update selected movie detail
    notifyListeners();
  }

}