import 'package:flutter/material.dart';
import 'package:animeapp/feature/anime_list/data/anime_db_model.dart';
import 'package:animeapp/shared/database/database_helper.dart';
import 'package:animeapp/shared/preferences/preferences_helper.dart';

class AnimeDetailScreen extends StatefulWidget {
  @override
  _AnimeDetailScreenState createState() => _AnimeDetailScreenState();
}

class _AnimeDetailScreenState extends State<AnimeDetailScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final PreferencesHelper _prefsHelper = PreferencesHelper();
  List<AnimeDbModel> _animes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnimes();
  }

  Future<void> _loadAnimes() async {
    setState(() {
      _isLoading = true;
    });
    List<AnimeDbModel> animes = await _dbHelper.getAnimes();
    setState(() {
      _animes = animes;
      _isLoading = false;
    });
  }

  Future<void> _deleteAnime(AnimeDbModel anime) async {
    await _dbHelper.deleteAnime(anime.malId);
    _loadAnimes();
  }

  Future<void> _showTotals() async {
    final totals = await _prefsHelper.getTotals();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Totals'),
          content: Text('Episodes: ${totals['episodes']}\nMembers: ${totals['members']}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Animes'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _showTotals,
            child: Text('Preferences'),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _animes.length,
                    itemBuilder: (context, index) {
                      final anime = _animes[index];
                      return ListTile(
                        leading: Image.network(anime.imageUrl),
                        title: Text(anime.title),
                        subtitle: Text('Year: ${anime.year ?? 'N/A'}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteAnime(anime),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}