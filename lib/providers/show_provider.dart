import 'package:flutter/material.dart';
import '../core/enums/show_category.dart';
import '../core/enums/ui_state.dart';
import '../core/services/api_service.dart';
import '../data/models/show_model.dart';

class ShowProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  
  UIState homeState = UIState.idle;
  UIState searchState = UIState.idle;

  List<Show> homeShows = [];
  List<Show> searchResults = [];

  String errorMessage = '';

  int page = 0;
  bool isFetchingMore = false;

  ShowCategory currentCategory = ShowCategory.trending;

  //home

  Future<void> fetchHomeShows({bool loadMore = false}) async {
    if (isFetchingMore) return;

    if (!loadMore) {
      homeState = UIState.loading;
      homeShows.clear();
      page = _mapCategoryToPage(currentCategory);
      notifyListeners();
    }

    isFetchingMore = true;

    try {
      final newShows = await _api.fetchShows(page);

      if (loadMore) {
        homeShows.addAll(newShows);
      } else {
        homeShows = newShows;
      }

      homeState = UIState.success;
      page++;
    } catch (e) {
      errorMessage = e.toString();
      homeState = UIState.error;
    }

    isFetchingMore = false;
    notifyListeners();
  }

  int _mapCategoryToPage(ShowCategory category) {
    switch (category) {
      case ShowCategory.trending:
        return 0;
      case ShowCategory.popular:
        return 1;
      case ShowCategory.upcoming:
        return 2;
    }
  }

  void changeCategory(ShowCategory category) {
    currentCategory = category;
    fetchHomeShows();
  }

  //search

 Future<void> searchShows(String query) async {
  query = query.trim(); 

  if (query.isEmpty) {
    searchResults.clear();
    searchState = UIState.idle;
    notifyListeners();
    return;
  }

  searchState = UIState.loading;
  notifyListeners();

  try {
    final results = await _api.searchShows(query);

    searchResults = results;
    searchState = UIState.success;
  } catch (e) {
    errorMessage = e.toString();
    searchState = UIState.error;
  }

  notifyListeners();
}
}