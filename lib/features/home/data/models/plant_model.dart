// lib/features/home/data/models/plant_model.dart

import 'package:munbat_ai/core/services/api_service.dart';

enum PlantStatus { healthy, disease, pest, notScanned }

class PlantModel {
  final String id;
  final String name;
  final String scientificName;
  final String imageUrl;
  final String? categoryId;
  final String? categoryName;
  final PlantStatus status;
  final String statusText;

  PlantModel({
    required this.id,
    required this.name,
    this.scientificName = '',
    required this.imageUrl,
    this.categoryId,
    this.categoryName,
    this.status = PlantStatus.notScanned,
    this.statusText = 'Tap to Scan',
  });

  /// يحول path نسبي زي "images/banana.jpg" لرابط كامل على السيرفر،
  /// ويسيب الروابط الكاملة (http/https) كما هي.
  static String _resolveImageUrl(String raw) {
    if (raw.isEmpty) return '';
    if (raw.startsWith('http://') || raw.startsWith('https://')) {
      return raw;
    }
    final cleanPath = raw.startsWith('/') ? raw.substring(1) : raw;
    return '${ApiService.rootUrl}/$cleanPath';
  }

  /// من /api/plants أو /api/catalog/categories/:id/plants أو /api/catalog/plants/:id
  factory PlantModel.fromJson(Map<String, dynamic> json) {
    String? catId;
    String? catName;

    final cat = json['category_id'];
    if (cat is Map<String, dynamic>) {
      catId = cat['_id']?.toString();
      catName = cat['name']?.toString();
    } else if (cat != null) {
      catId = cat.toString();
    }

    return PlantModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      scientificName: json['scientific_name']?.toString() ?? '',
      imageUrl: _resolveImageUrl(json['image_url']?.toString() ?? ''),
      categoryId: catId,
      categoryName: catName,
    );
  }
}