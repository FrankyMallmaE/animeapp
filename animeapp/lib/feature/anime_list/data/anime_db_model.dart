import 'package:animeapp/feature/anime_list/data/anime_model.dart';

class AnimeDbModel {
  final int malId;
  final String title;
  final String imageUrl;
  final int? year;
  final int? episodes;
  final int? members;

  AnimeDbModel({
    required this.malId,
    required this.title,
    required this.imageUrl,
    this.year,
    this.episodes,
    this.members,
  });

  factory AnimeDbModel.fromJson(Map<String, dynamic> json) {
    return AnimeDbModel(
      malId: json['malId'],
      title: json['title'],
      imageUrl: json['imageUrl'],
      year: json['year'],
      episodes: json['episodes'],
      members: json['members'],
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

  factory AnimeDbModel.fromAnime(Anime anime) {
    return AnimeDbModel(
      malId: anime.malId,
      title: anime.title,
      imageUrl: anime.imageUrl,
      year: anime.year,
      episodes: anime.episodes,
      members: anime.members,
    );
  }
}