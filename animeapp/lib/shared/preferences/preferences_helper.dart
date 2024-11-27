import 'package:shared_preferences/shared_preferences.dart';
import 'package:animeapp/shared/database/database_helper.dart';
import 'package:animeapp/feature/anime_list/data/anime_db_model.dart';

class PreferencesHelper {
  static const String _episodesKey = 'episodes';
  static const String _membersKey = 'members';

  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<Map<String, int>> getTotals() async {
    List<AnimeDbModel> animes = await _dbHelper.getAnimes();
    int totalEpisodes = 0;
    int totalMembers = 0;

    for (var anime in animes) {
      totalEpisodes += anime.episodes ?? 0;
      totalMembers += anime.members ?? 0;
    }

    return {'episodes': totalEpisodes, 'members': totalMembers};
  }
}