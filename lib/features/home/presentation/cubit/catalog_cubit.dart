// lib/features/home/presentation/cubit/catalog_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munbat_ai/features/home/data/repositories/catalog_repository.dart';
import 'catalog_state.dart';

class CatalogCubit extends Cubit<CatalogState> {
  final CatalogRepository _repository;

  CatalogCubit(this._repository) : super(CatalogInitial());

  Future<void> loadCategories() async {
    emit(CatalogLoading());

    final categories = await _repository.getCategories();
    if (categories.isEmpty) {
      emit(CatalogError('Failed to load categories'));
      return;
    }

    final firstCategory = categories.first;
    final plants = await _repository.getPlantsByCategory(firstCategory.id);

    emit(CatalogLoaded(
      categories: categories,
      plants: plants,
      selectedCategoryId: firstCategory.id,
    ));
  }

  /// يستخدم في Pull-to-refresh
  Future<void> refresh() async {
    final current = state;
    if (current is CatalogLoaded && current.selectedCategoryId != null) {
      emit(current.copyWith(isLoadingPlants: true));
      final plants =
          await _repository.getPlantsByCategory(current.selectedCategoryId!);

      final latest = state;
      if (latest is CatalogLoaded) {
        emit(latest.copyWith(plants: plants, isLoadingPlants: false));
      }
    } else {
      await loadCategories();
    }
  }

  Future<void> selectCategory(String categoryId) async {
    final current = state;
    if (current is! CatalogLoaded) return;
    if (current.selectedCategoryId == categoryId) return;

    // نغير التاب فورًا ونعرض لودينج محلي بس على منطقة النباتات
    emit(current.copyWith(
      selectedCategoryId: categoryId,
      isLoadingPlants: true,
    ));

    final plants = await _repository.getPlantsByCategory(categoryId);

    final latest = state;
    if (latest is CatalogLoaded && latest.selectedCategoryId == categoryId) {
      emit(latest.copyWith(plants: plants, isLoadingPlants: false));
    }
  }
}