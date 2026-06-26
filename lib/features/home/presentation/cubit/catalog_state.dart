// lib/features/home/presentation/cubit/catalog_state.dart

import 'package:munbat_ai/features/home/data/models/category_model.dart';
import 'package:munbat_ai/features/home/data/models/plant_model.dart';

abstract class CatalogState {}

class CatalogInitial extends CatalogState {}

class CatalogLoading extends CatalogState {}

class CatalogLoaded extends CatalogState {
  final List<CategoryModel> categories;
  final List<PlantModel> plants;
  final String? selectedCategoryId;
  final bool isLoadingPlants;

  CatalogLoaded({
    required this.categories,
    required this.plants,
    this.selectedCategoryId,
    this.isLoadingPlants = false,
  });

  CatalogLoaded copyWith({
    List<CategoryModel>? categories,
    List<PlantModel>? plants,
    String? selectedCategoryId,
    bool? isLoadingPlants,
  }) {
    return CatalogLoaded(
      categories: categories ?? this.categories,
      plants: plants ?? this.plants,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      isLoadingPlants: isLoadingPlants ?? this.isLoadingPlants,
    );
  }
}

class CatalogError extends CatalogState {
  final String message;
  CatalogError(this.message);
}