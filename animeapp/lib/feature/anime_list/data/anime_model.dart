class Anime {
  final int malId;
  final String title;
  final String imageUrl;
  final int? year; // Permitir que year sea nulo
  final int? episodes; // Permitir que episodes sea nulo
  final int? members; // Permitir que members sea nulo

  Anime({
    required this.malId,
    required this.title,
    required this.imageUrl,
    this.year,
    this.episodes,
    this.members,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      malId: json['mal_id'],
      title: json['title'],
      imageUrl: json['images']['jpg']['image_url'],
      year: json['year'] != null ? json['year'] as int : null,
      episodes: json['episodes'] != null ? json['episodes'] as int : null,
      members: json['members'] != null ? json['members'] as int : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'malId': malId,
      'title': title,
      'imageUrl': imageUrl,
      'year': year,
      'episodes': episodes,
      'members': members,
    };
  }
}