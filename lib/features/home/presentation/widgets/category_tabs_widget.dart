// lib/features/home/presentation/widgets/category_tabs_widget.dart
import 'package:flutter/material.dart';
import 'package:munbat_ai/features/home/data/models/category_model.dart';
import 'package:munbat_ai/features/home/presentation/widgets/category_tab_item.dart';

class CategoryTabsWidget extends StatelessWidget {
  final List<CategoryModel> categories;
  final String? selectedCategoryId;
  final Function(String) onCategoryChanged;

  const CategoryTabsWidget({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return CategoryTabItem(
            label: category.name,
            value: category.id,
            isSelected: category.id == selectedCategoryId,
            onTap: () => onCategoryChanged(category.id),
          );
        }).toList(),
      ),
    );
  }
}