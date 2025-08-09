import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_ott_app/controllers/movie_controller.dart';
import 'package:video_ott_app/models/video.dart';
import 'package:video_ott_app/services/video_service.dart';
import 'package:video_ott_app/views/detail_screen.dart';
import 'package:video_ott_app/views/listing_screen.dart';
import 'package:video_ott_app/views/video_detail_screen.dart';
import 'package:video_ott_app/views/widgets/movie_carousel.dart';
import 'package:video_ott_app/views/widgets/movie_rail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Video>> _videosFuture;

  @override
  void initState() {
    super.initState();

    // Call API once when screen loads
    Provider.of<MovieController>(context, listen: false).getMoviePosters(context);
    Provider.of<MovieController>(context, listen: false).getLatestMovies(context);
    _videosFuture = VideoService.loadVideos();
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
          // Title for video section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Watch Videos",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 8),

          FutureBuilder<List<Video>>(
            future: _videosFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text("Error loading videos"));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No videos found"));
              }

              final videos = snapshot.data!;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: videos.map((video) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VideoDetailScreen(video: video),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        width: 160,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                video.thumb, // Image URL from API
                                fit: BoxFit.cover,
                                height: 120,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 50),
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              video.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),

          const SizedBox(height: 16),
          // Title for collection section
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
