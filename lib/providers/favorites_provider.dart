import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smollan_movie_verse/data/models/show_model.dart';

class FavoritesProvider extends ChangeNotifier {
  final box = Hive.box<Show>('favorites');

  List<Show> get favorites => box.values.toList();

  void toggle(Show show) {
    if (box.containsKey(show.id)) {
      box.delete(show.id);
    } else {
      box.put(show.id, show);
    }
    notifyListeners();
  }

  bool isFavorite(int id) => box.containsKey(id);
}