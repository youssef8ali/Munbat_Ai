// lib/features/home/presentation/widgets/category_tabs_widget.dart
import 'package:flutter/material.dart';
import 'package:munbat_ai/features/home/presentation/widgets/category_tab_item.dart';

class CategoryTabsWidget extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategoryChanged;

  const CategoryTabsWidget({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          CategoryTabItem(
            label: 'Fruits',
            value: 'fruits',
            isSelected: selectedCategory == 'fruits',
            onTap: () => onCategoryChanged('fruits'),
          ),
          CategoryTabItem(
            label: 'Vegetables',
            value: 'vegetables',
            isSelected: selectedCategory == 'vegetables',
            onTap: () => onCategoryChanged('vegetables'),
          ),
          CategoryTabItem(
            label: 'Other',
            value: 'other',
            isSelected: selectedCategory == 'other',
            onTap: () => onCategoryChanged('other'),
          ),
        ],
      ),
    );
  }
}