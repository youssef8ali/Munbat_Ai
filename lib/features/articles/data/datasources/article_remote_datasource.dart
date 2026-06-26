// lib/features/articles/data/datasources/article_remote_datasource.dart

import 'package:munbat_ai/core/services/api_service.dart';
import 'package:munbat_ai/features/articles/data/models/article_model.dart';

class ArticleRemoteDataSource {
  final ApiService _api = ApiService();

  ArticleRemoteDataSource({String token = ''});

  /// GET /api/articles/plants/{plantId}
  Future<List<ArticleModel>> getArticlesForPlant(String plantId) async {
    final response = await _api.getArticlesForPlant(plantId);
    final articles = response.data['data']['articles'] as List<dynamic>;
    return articles
        .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /api/articles/general
  Future<List<ArticleModel>> getGeneralArticles() async {
    final response = await _api.getGeneralArticles();
    final articles = response.data['data']['articles'] as List<dynamic>;
    return articles
        .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /api/articles/{articleId}
  Future<ArticleModel> getArticleById(String articleId) async {
    final response = await _api.getArticleById(articleId);
    return ArticleModel.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }
}