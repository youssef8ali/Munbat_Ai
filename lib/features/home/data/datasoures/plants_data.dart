// lib/data/plants_data.dart
import 'package:munbat_ai/features/home/data/models/plant_model.dart';

class PlantsData {
  static final List<PlantModel> fruits = [
    PlantModel(
      id: 1,
      name: 'Apple',
      scientificName: 'Malus domestica',
      imageUrl: "assets/images/plants_images/apples-tree.jpg",
      status: PlantStatus.healthy,
      statusText: 'Healthy',
    ),
    PlantModel(
      id: 2,
      name: 'Tomato',
      scientificName: 'Solanum lycopersicum',
      imageUrl: "assets/images/plants_images/tomatoes.jpg",
      status: PlantStatus.disease,
      statusText: '3 Diseases',
    ),
    PlantModel(
      id: 3,
      name: 'Grape',
      scientificName: 'Vitis vinifera',
      imageUrl: "assets/images/plants_images/red-grapes.jpg",
      status: PlantStatus.healthy,
      statusText: 'Healthy',
    ),
    PlantModel(
      id: 4,
      name: 'Lemon',
      scientificName: 'Citrus limon',
      imageUrl: "assets/images/plants_images/lemons.jpg",
      status: PlantStatus.healthy,
      statusText: 'Healthy',
    ),
  ];

  static final List<PlantModel> vegetables = [
    PlantModel(
      id: 6,
      name: 'Potato',
      scientificName: 'Solanum tuberosum',
      imageUrl: "assets/images/plants_images/potatoes.jpg",
      status: PlantStatus.pest,
      statusText: '1 Pest Detected',
    ),
    PlantModel(
      id: 7,
      name: 'Corn',
      scientificName: 'Zea mays',
      imageUrl: "assets/images/plants_images/corn.jpg",
      status: PlantStatus.healthy,
      statusText: 'Healthy',
    ),
    PlantModel(
      id: 8,
      name: 'Spinach',
      scientificName: 'Spinacia oleracea',
      imageUrl: "assets/images/plants_images/spinach.jpg",
      status: PlantStatus.notScanned,
      statusText: 'Not Scanned',
    ),
    PlantModel(
      id: 9,
      name: 'Rice',
      scientificName: 'Oryza sativa',
      imageUrl: "assets/images/plants_images/rice.jpg",
      status: PlantStatus.healthy,
      statusText: 'Healthy',
    ),
    PlantModel(
      id: 10,
      name: 'Bell Pepper',
      scientificName: 'Capsicum annuum',
      imageUrl: "assets/images/plants_images/bell-pepper.jpg",
      status: PlantStatus.notScanned,
      statusText: 'Not Scanned',
    ),
  ];

  static final List<PlantModel> other = [
    PlantModel(
      id: 12,
      name: 'Rice',
      scientificName: 'Oryza sativa',
      imageUrl: "assets/images/plants_images/rice.jpg",
      status: PlantStatus.notScanned,
      statusText: 'Not Scanned',
    ),
    PlantModel(
      id: 13,
      name: 'Wheat',
      scientificName: 'Triticum',
      imageUrl: "assets/images/plants_images/wheat.jpg",
      status: PlantStatus.notScanned,
      statusText: 'Not Scanned',
    ),
    PlantModel(
      id: 14,
      name: 'Cotton',
      scientificName: 'Gossypium',
      imageUrl: "assets/images/plants_images/cotton.jpg",
      status: PlantStatus.disease,
      statusText: 'Potential Disease',
    ),
    PlantModel(
      id: 15,
      name: 'Sugarcane',
      scientificName: 'Saccharum',
      imageUrl: "assets/images/plants_images/bamboo.jpg",
      status: PlantStatus.notScanned,
      statusText: 'Not Scanned',
    ),
    PlantModel(
      id: 16,
      name: 'Tea',
      scientificName: 'Camellia sinensis',
      imageUrl: "assets/images/plants_images/apples-tree.jpg",
      status: PlantStatus.healthy,
      statusText: 'Healthy',
    ),
  ];

  static List<PlantModel> getPlantsByCategory(String category) {
    switch (category.toLowerCase()) {
      case 'fruits':
        return fruits;
      case 'vegetables':
        return vegetables;
      case 'other':
        return other;
      default:
        return [];
    }
  }
}
