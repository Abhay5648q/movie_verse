import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smollan_movie_verse/providers/favorites_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: Consumer<FavoritesProvider>(
        builder: (_, provider, __) {
          if (provider.favorites.isEmpty) {
            return const Center(child: Text("No favorites yet"));
          }

          return ListView.builder(
            itemCount: provider.favorites.length,
            itemBuilder: (_, i) {
              final show = provider.favorites[i];

              return ListTile(
                title: Text(show.name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => provider.toggle(show),
                ),
              );
            },
          );
        },
      ),
    );
  }
}