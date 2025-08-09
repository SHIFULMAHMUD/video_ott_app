import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_ott_app/models/video.dart';

class VideoDetailScreen extends StatefulWidget {
  final Video video;
  const VideoDetailScreen({super.key, required this.video});

  @override
  State<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  late VideoPlayerController _controller;

  // Static map to hold last positions per video ID
  static final Map<int, Duration> _lastPositions = {};

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.video.sources))
      ..initialize().then((_) {
        // Seek to last saved position if available
        final lastPos = _lastPositions[widget.video.id];
        if (lastPos != null && lastPos != Duration.zero) {
          _controller.seekTo(lastPos);
        }
        setState(() {});
      });

    _controller.addListener(() {
      if (_controller.value.isPlaying) {
        _lastPositions[widget.video.id] = _controller.value.position;
      }
    });
  }

  @override
  void dispose() {
    // Save last position before dispose
    _lastPositions[widget.video.id] = _controller.value.position;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.video.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _controller.value.isInitialized
                ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
                : const Center(child: CircularProgressIndicator()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(_controller.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow),
                  onPressed: () {
                    setState(() {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: () {
                    setState(() {
                      _controller.pause();
                      _controller.seekTo(_lastPositions[widget.video.id] ?? Duration.zero);
                    });
                  },
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Description:", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: Text(widget.video.description, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
