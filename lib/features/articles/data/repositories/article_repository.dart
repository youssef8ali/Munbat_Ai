// lib/features/articles/data/repositories/article_repository.dart

import 'package:munbat_ai/features/articles/data/datasources/article_remote_datasource.dart';
import 'package:munbat_ai/features/articles/data/models/article_model.dart';

class ArticleRepository {
  final ArticleRemoteDataSource _dataSource;

  ArticleRepository({required ArticleRemoteDataSource dataSource})
      : _dataSource = dataSource;

  Future<List<ArticleModel>> getArticlesForPlant(String plantId) =>
      _dataSource.getArticlesForPlant(plantId);

  Future<List<ArticleModel>> getGeneralArticles() =>
      _dataSource.getGeneralArticles();

  Future<ArticleModel> getArticleById(String articleId) =>
      _dataSource.getArticleById(articleId);
}