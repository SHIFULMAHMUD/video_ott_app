import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_ott_app/controllers/movie_controller.dart';
import 'package:video_ott_app/models/movie.dart';
import 'package:video_ott_app/views/detail_screen.dart';

class ListingScreen extends StatefulWidget {
  final String keyword; // Search keyword to filter movies, e.g., "avengers"

  const ListingScreen({super.key, required this.keyword});

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    // Get the MovieController instance without listening for rebuilds here
    final provider = Provider.of<MovieController>(context, listen: false);

    // Reset pagination state for new search
    provider.pagedMovies.clear();
    provider.currentPage = 1;
    provider.hasMore = true;

    // Load the first page of movies for the given keyword
    provider.getMoviesWithPagination(widget.keyword);

    // Initialize scroll controller to detect when user scrolls near bottom
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  // Detect when user scrolls near bottom to load more movies (pagination)
  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !Provider.of<MovieController>(context, listen: false).isFetching)
    {
      Provider.of<MovieController>(context, listen: false).getMoviesWithPagination(widget.keyword);  // Fetch next page if not already fetching
    }
  }

  // Dispose the scroll controller to free resources
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieController = Provider.of<MovieController>(context);  // Listen for changes to movie data and loading state

    return Scaffold(
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
            return GestureDetector(
              onTap: () {
                final imdbId = movie.imdbId;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(imdbId: imdbId),
                  ),
                );
              },
              child: Column(
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
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());  // Show loading indicator at the bottom while more data is loading
          }
        },
      ),
    );
  }
}
