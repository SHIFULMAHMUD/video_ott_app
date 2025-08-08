import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_ott_app/controllers/movie_controller.dart';
import 'package:video_ott_app/views/detail_screen.dart';
import 'package:video_ott_app/views/listing_screen.dart';
import 'package:video_ott_app/views/widgets/movie_carousel.dart';
import 'package:video_ott_app/views/widgets/movie_rail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Call API once when screen loads
    Provider.of<MovieController>(context, listen: false).getMoviePosters(context);
    Provider.of<MovieController>(context, listen: false).getLatestMovies(context);
  }

  @override
  Widget build(BuildContext context) {
    final movieController = Provider.of<MovieController>(context);

    return Scaffold(
      appBar: AppBar(title: Text("OTT App")),
      body: movieController.loader
          ? Center(child: CircularProgressIndicator())
          : ListView(
        children: [
          MovieCarousel(
            movies: movieController.movies.length >= 5
                ? movieController.movies.take(5).toList()
                : movieController.movies,
            onTap: (movie) {
              // handle movie tap here
              final imdbId = movie.imdbId;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(imdbId: imdbId),
                ),
              );
            },
          ),
          MovieRail(
            title: "Latest Movies (2022)",
            movies: movieController.latestMovies,
            onTap: (movie) {
              final imdbId = movie.imdbId;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(imdbId: imdbId),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          // Title for Portrait section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Collection of Avengers",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ListingScreen embedded with fixed height
          SizedBox(
            height: 500, // You can adjust this height as needed
            child: ListingScreen(keyword: 'avengers'), // This must be a scrollable widget
          ),
        ],
      ),
    );
  }
}
