// lib/features/articles/data/models/article_model.dart
class ArticleModel {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final String readTime;
  final DateTime publishedDate;
  final String content;

  ArticleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.readTime,
    required this.publishedDate,
    required this.content,
  });
}
