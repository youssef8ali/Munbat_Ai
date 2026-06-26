// lib/features/home/data/repositories/catalog_repository.dart

import 'package:flutter/foundation.dart';
import 'package:munbat_ai/core/services/api_service.dart';
import 'package:munbat_ai/features/home/data/models/category_model.dart';
import 'package:munbat_ai/features/home/data/models/plant_model.dart';

class CatalogRepository {
  final ApiService _apiService = ApiService();

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _apiService.getCategories();
      final data = response.data['data'] as List<dynamic>? ?? [];
      return data
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('GET CATEGORIES ERROR => $e');
      return [];
    }
  }

  Future<List<PlantModel>> getPlantsByCategory(String categoryId) async {
    try {
      final response = await _apiService.getPlantsByCategory(categoryId);
      final data = response.data['data'] as List<dynamic>? ?? [];
      return data
          .map((e) => PlantModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('GET PLANTS BY CATEGORY ERROR => $e');
      return [];
    }
  }

  Future<List<PlantModel>> getAllPlants({
    String? search,
    int? limit,
    int? page,
  }) async {
    try {
      final response = await _apiService.getAllPlants(
        search: search,
        limit: limit,
        page: page,
      );
      final plants = response.data['data']?['plants'] as List<dynamic>? ?? [];
      return plants
          .map((e) => PlantModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('GET ALL PLANTS ERROR => $e');
      return [];
    }
  }

  Future<PlantModel?> getPlantById(String plantId) async {
    try {
      final response = await _apiService.getPlantById(plantId);
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      return PlantModel.fromJson(data);
    } catch (e) {
      debugPrint('GET PLANT BY ID ERROR => $e');
      return null;
    }
  }
}