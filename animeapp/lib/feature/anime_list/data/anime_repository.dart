import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:animeapp/core/constants/api_constants.dart';
import 'package:animeapp/feature/anime_list/data/anime_model.dart';

class AnimeRepository {
  Future<List<Anime>> fetchTopAnime(int page) async {
    final response = await http.get(Uri.parse('${ApiConstants.baseUrl}${ApiConstants.topAnimeEndpoint}?page=$page'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List).map((anime) => Anime.fromJson(anime)).toList();
    } else {
      throw Exception('Failed to load anime');
    }
  }
}