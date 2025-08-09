class Video {
  final int id;
  final String title;
  final String description;
  final String thumb;
  final String sources;

  Video({
    required this.id,
    required this.title,
    required this.description,
    required this.thumb,
    required this.sources,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      thumb: json['thumb'],
      sources: json['sources'],
    );
  }
}
