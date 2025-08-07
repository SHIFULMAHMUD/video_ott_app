import 'package:flutter/material.dart';
import 'package:video_ott_app/models/movie.dart';
import 'package:video_ott_app/services/api_service.dart';

class MovieController extends ChangeNotifier {
  Movie? item;
  List<Search> movies = [];
  List<Search> movieDetail = [];
  List<Search> selectedMovie = [];
  String selectedItemId = "";
  bool loading = false;
  bool loader = false;
  int page = 1;
  late int totalPages;

  getSelectedItem(String id) {
    selectedItemId = id;
    notifyListeners();
  }

  getMoviePosters(BuildContext context) async {
    loading = true;
    String apiUrl = '&s=batman&type=movie';
    final response = await ApiService().request(method:'GET',url: apiUrl);
    item = movieFromJson(response);
    movies.clear();
    movies.addAll(item!.search);
    loading = false;
    notifyListeners();
  }
}