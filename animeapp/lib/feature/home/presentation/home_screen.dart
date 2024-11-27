import 'package:flutter/material.dart';
import 'package:animeapp/feature/anime_list/presentation/anime_list_screen.dart';
import 'package:animeapp/feature/anime_list/presentation/anime_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anime App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon/animeicon.png',
              width: 300,
              height: 300,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AnimeListScreen()),
                );
              },
              child: Text('View Anime List'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AnimeDetailScreen()),
                );
              },
              child: Text('View Saved Animes'),
            ),
          ],
        ),
      ),
    );
  }
}