import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_ott_app/controllers/movie_controller.dart';

class DetailScreen extends StatefulWidget {
  final String imdbId;
  const DetailScreen({super.key, required this.imdbId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<MovieController>(context, listen: false).getMovieDetail(widget.imdbId);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<MovieController>(context);
    final movie = controller.selectedMovieDetail;

    return Scaffold(
      appBar: AppBar(title: Text(movie?.title ?? "Loading...")),
      body: movie == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(movie.poster, height: 300),
            ),
            SizedBox(height: 16),
            Text("Title: ${movie.title}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Year: ${movie.year}", style: TextStyle(fontSize: 16)),
            Text("Rated: ${movie.rated}", style: TextStyle(fontSize: 16)),
            Text("Runtime: ${movie.runtime}", style: TextStyle(fontSize: 16)),
            Text("Genre: ${movie.genre}", style: TextStyle(fontSize: 16)),
            Text("Director: ${movie.director}", style: TextStyle(fontSize: 16)),
            Text("Writer: ${movie.writer}", style: TextStyle(fontSize: 16)),
            Text("Actors: ${movie.actors}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Plot:\n${movie.plot}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Language: ${movie.language}", style: TextStyle(fontSize: 16)),
            Text("Country: ${movie.country}", style: TextStyle(fontSize: 16)),
            Text("Awards: ${movie.awards}", style: TextStyle(fontSize: 16)),
            Text("IMDB Rating: ${movie.imdbRating} (${movie.imdbVotes} votes)", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
