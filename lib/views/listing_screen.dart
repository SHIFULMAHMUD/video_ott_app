import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_ott_app/controllers/movie_controller.dart';
import 'package:video_ott_app/models/movie.dart';

class ListingScreen extends StatefulWidget {
  final String keyword; // example: "avengers"

  const ListingScreen({super.key, required this.keyword});

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<MovieController>(context, listen: false);
    provider.pagedMovies.clear();
    provider.currentPage = 1;
    provider.hasMore = true;
    provider.fetchPagedMovies(widget.keyword);

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !Provider.of<MovieController>(context, listen: false).isFetching) {
      Provider.of<MovieController>(context, listen: false)
          .fetchPagedMovies(widget.keyword);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieController = Provider.of<MovieController>(context);

    return Scaffold(
      // appBar: AppBar(title: Text("Movies: ${widget.keyword}")),
      body: movieController.pagedMovies.isEmpty && movieController.isFetching
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(12),
        itemCount: movieController.pagedMovies.length +
            (movieController.hasMore ? 1 : 0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.65,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          if (index < movieController.pagedMovies.length) {
            Search movie = movieController.pagedMovies[index];
            return Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      movie.poster != 'N/A'
                          ? movie.poster
                          : 'https://placehold.co/400x600?text=No%20Image!',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  movie.title,
                  style: TextStyle(fontSize: 12),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
