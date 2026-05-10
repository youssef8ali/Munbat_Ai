// lib/features/home/presentation/widgets/plant_grid_widget.dart
import 'package:flutter/material.dart';
import 'package:munbat_ai/features/home/data/models/plant_model.dart';
import 'package:munbat_ai/features/home/presentation/widgets/plant_card_widget.dart';


class PlantGridWidget extends StatelessWidget {
  final List<PlantModel> plants;
  final Function(PlantModel) onPlantTap;

  const PlantGridWidget({
    super.key,
    required this.plants,
    required this.onPlantTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: plants.length,
      itemBuilder: (context, index) {
        return PlantCardWidget(
          plant: plants[index],
          onTap: () => onPlantTap(plants[index]),
        );
      },
    );
  }
}