import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_ott_app/models/movie.dart';

class MovieCarousel extends StatelessWidget {
  final List<Search> movies;
  final void Function(Search) onTap;

  const MovieCarousel({
    super.key,
    required this.movies,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();  // If there are no movies, return an empty widget (no space taken)

    return CarouselSlider(
      options: CarouselOptions(
        height: 180,
        autoPlay: true, // Enable automatic sliding
        enlargeCenterPage: true, // Make the center item larger for emphasis
        enableInfiniteScroll: true, // Loop infinitely through items
        viewportFraction: 0.9, // Show 90% of item width, leaving some padding
      ),
      items: movies.take(5).map((movie) {
        return GestureDetector(
          onTap: () => onTap(movie),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,  // Make all children fill the container
              children: [
                CachedNetworkImage(
                  imageUrl: movie.poster != 'N/A' ? movie.poster : '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: Colors.grey.shade300),
                  errorWidget: (context, url, error) => Container(color: Colors.grey.shade300),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [Colors.black54, Colors.transparent],
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  bottom: 12,
                  right: 12,
                  child: Text(
                    movie.title,
                    maxLines: 1,  // Limit title to one line
                    overflow: TextOverflow.ellipsis,  // Ellipsis for long titles
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 6, color: Colors.black)],  // Text shadow for readability
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
