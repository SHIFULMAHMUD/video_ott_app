import 'package:flutter/material.dart';
import 'package:video_ott_app/models/movie.dart';

class MovieRail extends StatelessWidget {
  final String title;
  final List<Search> movies;
  final void Function(Search) onTap;

  const MovieRail({
    super.key,
    required this.title,
    required this.movies,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,  // Align children to start horizontally
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () => onTap(movie),
                child: Container(
                  width: 120,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 2 / 3,  // Maintain poster aspect ratio (width:height)
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            movie.poster != 'N/A' ? movie.poster : 'https://placehold.co/400x600?text=No%20Image!',  // Placeholder image if no poster
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 6),  // Spacing between image and title
                      Text(
                        movie.title,
                        maxLines: 2,  // Limit title to 2 lines
                        overflow: TextOverflow.ellipsis,  // Ellipsis for overflow
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}