import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smollan_movie_verse/core/utils/html_utils.dart';
import 'package:smollan_movie_verse/data/models/show_model.dart';
import 'package:smollan_movie_verse/providers/favorites_provider.dart';

class DetailsScreen extends StatelessWidget {
  final Show show;

  const DetailsScreen({super.key, required this.show});

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<FavoritesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(show.name),
        actions: [
          IconButton(
            icon: Icon(
              favProvider.isFavorite(show.id)
                  ? Icons.favorite
                  : Icons.favorite_border,
            ),
            onPressed: () => favProvider.toggle(show),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
         Hero(
  tag: show.id.toString(), 
  child: Image.network(
    show.image?.isNotEmpty == true
        ? show.image!
        : 'https://via.placeholder.com/300x400', 
    fit: BoxFit.cover,
    errorBuilder: (_, __, ___) =>
        const Icon(Icons.broken_image, size: 100),
  ),
),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(
  show.name.isNotEmpty ? show.name : "No Title",
  style: Theme.of(context).textTheme.titleLarge,
),

const SizedBox(height: 8),

Text("⭐ ${show.rating ?? 'N/A'}"),

const SizedBox(height: 8),

Text(
  show.genres.isNotEmpty
      ? "Genres: ${show.genres.join(', ')}"
      : "Genres: N/A",
  style: const TextStyle(fontWeight: FontWeight.w500),
),

const SizedBox(height: 16),

const Text(
  "Description",
  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
),

const SizedBox(height: 8),

                  const SizedBox(height: 8),

                  Text(
                    parseHtml(show.summary),
                    style: const TextStyle(height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
