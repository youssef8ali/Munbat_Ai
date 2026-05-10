
// lib/features/articles/data/datasources/articles_data.dart
import 'package:munbat_ai/features/articles/data/models/article_model.dart';

class ArticlesData {
  static List<ArticleModel> getArticlesForPlant(String plantName) {
    return [
      ArticleModel(
        id: 1,
        title: 'How to Grow Healthy $plantName',
        description:
            'Complete guide to growing and maintaining $plantName plants.',
        imageUrl: '🌱',
        category: 'Growing Guide',
        readTime: '5 min read',
        publishedDate: DateTime.now().subtract(const Duration(days: 2)),
        content: 'Detailed content about growing $plantName...',
      ),
      ArticleModel(
        id: 2,
        title: 'Common $plantName Diseases',
        description:
            'Identify and treat diseases that affect $plantName plants.',
        imageUrl: '🦠',
        category: 'Disease Control',
        readTime: '7 min read',
        publishedDate: DateTime.now().subtract(const Duration(days: 5)),
        content: 'Information about common diseases...',
      ),
      ArticleModel(
        id: 3,
        title: '$plantName Pest Management',
        description: 'Learn how to protect your $plantName from pests.',
        imageUrl: '🐛',
        category: 'Pest Control',
        readTime: '6 min read',
        publishedDate: DateTime.now().subtract(const Duration(days: 8)),
        content: 'Guide to managing pests...',
      ),
      ArticleModel(
        id: 4,
        title: 'Best Fertilizers for $plantName',
        description:
            'Choose the right nutrients for optimal $plantName growth.',
        imageUrl: '🌿',
        category: 'Nutrition',
        readTime: '4 min read',
        publishedDate: DateTime.now().subtract(const Duration(days: 12)),
        content: 'Fertilizer recommendations...',
      ),
    ];
  }
}

