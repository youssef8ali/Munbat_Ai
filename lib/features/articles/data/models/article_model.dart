// lib/features/articles/data/models/article_model.dart

class ArticleModel {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final String? plantId;
  final List<String> tags;

  ArticleModel({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    this.plantId,
    this.tags = const [],
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['image_url'] ?? '',
      plantId: json['plant_id'] is Map
          ? json['plant_id']['_id']
          : json['plant_id'],
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  // Helper getters to keep UI code clean
  String get readTime {
    final words = content.split(' ').length;
    final minutes = (words / 200).ceil();
    return '$minutes min read';
  }

  String get category =>
      tags.isNotEmpty ? _capitalize(tags.first) : 'General';

  String get description {
    final sentences = content.split('. ');
    return sentences.isNotEmpty
        ? '${sentences.first}.'
        : content.substring(0, content.length.clamp(0, 100));
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}