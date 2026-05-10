
enum PlantStatus { healthy, disease, pest, notScanned }

class PlantModel {
  final int id;
  final String name;
  final String scientificName;
  final String imageUrl;
  final PlantStatus status;
  final String statusText;

  PlantModel({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.imageUrl,
    required this.status,
    required this.statusText,
  });
}