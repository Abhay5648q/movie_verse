import 'package:hive/hive.dart';
part 'show_model.g.dart';

@HiveType(typeId: 0)
class Show {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? image;

  @HiveField(3)
  final double? rating;

  @HiveField(4)
  final String summary;

  @HiveField(5)
  final List<String> genres;

  Show({
    required this.id,
    required this.name,
    this.image,
    this.rating,
    required this.summary,
    required this.genres,
  });

 factory Show.fromJson(Map<String, dynamic>? json) {
  if (json == null) {
    return Show(
      id: 0,
      name: '',
      summary: '',
      genres: [],
    );
  }

  return Show(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    image: json['image']?['medium'],
    rating: json['rating']?['average']?.toDouble(),
    summary: json['summary'] ?? '',
    genres: List<String>.from(json['genres'] ?? []),
  );
}
}