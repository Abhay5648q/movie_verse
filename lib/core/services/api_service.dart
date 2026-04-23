import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/models/show_model.dart';

class ApiService {
  static const String baseUrl = "https://api.tvmaze.com";

  // Search shows
  Future<List<Show>> searchShows(String query) async {
  final response =
      await http.get(Uri.parse('$baseUrl/search/shows?q=$query'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    return data
        .where((item) => item['show'] != null) 
        .map<Show>((item) => Show.fromJson(item['show']))
        .toList();
  } else {
    throw Exception("Failed to load shows");
  }
}

  // Get show details
  Future<Show> getShowDetails(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/shows/$id'),
      );

      if (response.statusCode == 200) {
        return Show.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to load details");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // Fetch shows for home
    Future<List<Show>> fetchShows(int page) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/shows?page=$page'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data
            .map<Show>((item) => Show.fromJson(item))
            .toList();
      } else {
        throw Exception("Failed to load shows");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}