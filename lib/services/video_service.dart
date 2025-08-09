import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:video_ott_app/models/video.dart';


class VideoService {
  static Future<List<Video>> loadVideos() async {
    final jsonString = await rootBundle.loadString('assets/media.json');  // Load JSON file from assets as a string
    final data = json.decode(jsonString);  // Decode JSON string into a dynamic map
    final videosList = data['categories'][0]['videos'] as List;  // Extract the list of videos from the first category
    return videosList.map((v) => Video.fromJson(v)).toList();  // Convert each video JSON object into a Video model instance
  }
}
