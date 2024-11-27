import 'package:flutter/material.dart';
import 'package:animeapp/feature/anime_list/data/anime_model.dart';
import 'package:animeapp/feature/anime_list/data/anime_repository.dart';
import 'package:animeapp/shared/database/database_helper.dart';
import 'package:animeapp/shared/preferences/preferences_helper.dart';
import 'package:animeapp/feature/anime_list/data/anime_db_model.dart';

class AnimeListScreen extends StatefulWidget {
  @override
  _AnimeListScreenState createState() => _AnimeListScreenState();
}

class _AnimeListScreenState extends State<AnimeListScreen> {
  final AnimeRepository _repository = AnimeRepository();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final PreferencesHelper _prefsHelper = PreferencesHelper();
  final ScrollController _scrollController = ScrollController();
  List<Anime> _animes = [];
  List<int> _savedAnimeIds = [];
  int _page = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAnimes();
    _loadSavedAnimes();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading) {
      _page++;
      _fetchAnimes();
    }
  }

  Future<void> _fetchAnimes() async {
    setState(() {
      _isLoading = true;
    });
    List<Anime> animes = await _repository.fetchTopAnime(_page);
    setState(() {
      _animes.addAll(animes);
      _isLoading = false;
    });
  }

  Future<void> _loadSavedAnimes() async {
    List<AnimeDbModel> savedAnimes = await _dbHelper.getAnimes();
    setState(() {
      _savedAnimeIds = savedAnimes.map((anime) => anime.malId).toList();
    });
  }

  Future<void> _toggleAnime(Anime anime) async {
    if (_savedAnimeIds.contains(anime.malId)) {
      await _dbHelper.deleteAnime(anime.malId);
      setState(() {
        _savedAnimeIds.remove(anime.malId);
      });
    } else {
      AnimeDbModel animeDbModel = AnimeDbModel.fromAnime(anime);
      await _dbHelper.insertAnime(animeDbModel);
      setState(() {
        _savedAnimeIds.add(anime.malId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anime List'),
      ),
      body: _isLoading && _animes.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: _animes.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _animes.length) {
                  return Center(child: CircularProgressIndicator());
                }
                final anime = _animes[index];
                final isSaved = _savedAnimeIds.contains(anime.malId);
                return ListTile(
                  leading: Image.network(anime.imageUrl),
                  title: Text(anime.title),
                  subtitle: Text('Year: ${anime.year ?? 'N/A'}'),
                  trailing: IconButton(
                    icon: Icon(
                      isSaved ? Icons.favorite : Icons.favorite_border,
                      color: isSaved ? Colors.red : null,
                    ),
                    onPressed: () => _toggleAnime(anime),
                  ),
                );
              },
            ),
    );
  }
}