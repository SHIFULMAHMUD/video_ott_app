import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:video_ott_app/models/video.dart';


class VideoService {
  static Future<List<Video>> loadVideos() async {
    final jsonString = await rootBundle.loadString('assets/media.json');
    final data = json.decode(jsonString);
    final videosList = data['categories'][0]['videos'] as List;
    return videosList.map((v) => Video.fromJson(v)).toList();
  }
}
