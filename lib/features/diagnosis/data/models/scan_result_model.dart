// lib/features/diagnosis/data/models/scan_result_model.dart

//  نبتة المرض - من disease_ids array
class DiseaseModel {
  final String id;
  final String name;
  final String description;

  DiseaseModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory DiseaseModel.fromJson(Map<String, dynamic> json) {
    return DiseaseModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }
}

//  الـ PlantScan object
class PlantScan {
  final String id;
  final String imageUrl;
  final String status;
  final List<DiseaseModel> diseases;
  final DateTime scanDate;

  PlantScan({
    required this.id,
    required this.imageUrl,
    required this.status,
    required this.diseases,
    required this.scanDate,
  });

  bool get isHealthy => diseases.isEmpty;

  String get topDiseaseName =>
      diseases.isNotEmpty ? diseases.first.name : 'Healthy';

  factory PlantScan.fromJson(Map<String, dynamic> json) {
    final diseaseList = json['disease_ids'] as List? ?? [];

    return PlantScan(
      id: json['_id']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      diseases: diseaseList
          .map((e) => DiseaseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      scanDate: DateTime.tryParse(json['scan_date']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}

//  الـ Treatment object
class TreatmentModel {
  final String id;
  final String name;
  final String instructions;
  final List<String> diseaseIds;

  TreatmentModel({
    required this.id,
    required this.name,
    required this.instructions,
    required this.diseaseIds,
  });

  factory TreatmentModel.fromJson(Map<String, dynamic> json) {
    final ids = json['disease_ids'] as List? ?? [];
    return TreatmentModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      instructions: json['instructions']?.toString() ?? '',
      diseaseIds: ids.map((e) => e.toString()).toList(),
    );
  }
}

//  الـ Product object
class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String imageUrl;
  final String treatmentId;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.treatmentId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: (json['quantity'] ?? 0).toInt(),
      imageUrl: json['image_url']?.toString() ?? '',
      treatmentId: json['treatment_id']?.toString() ?? '',
    );
  }
}

//  الـ Response الكامل
class ScanResultModel {
  final PlantScan plantScan;
  final List<TreatmentModel> treatments;
  final List<ProductModel> products;

  ScanResultModel({
    required this.plantScan,
    required this.treatments,
    required this.products,
  });

  factory ScanResultModel.fromJson(Map<String, dynamic> json) {
    // لو جاي من scanImage: { "data": { "PlantScan": {}, "treatments": [], "Products": [] } }
    if (json.containsKey('data') &&
        json['data'] is Map<String, dynamic> &&
        (json['data'] as Map<String, dynamic>).containsKey('PlantScan')) {
      final data = json['data'] as Map<String, dynamic>;
      return ScanResultModel(
        plantScan:
            PlantScan.fromJson(data['PlantScan'] as Map<String, dynamic>),
        treatments: (data['treatments'] as List? ?? [])
            .map((e) => TreatmentModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        products: (data['Products'] as List? ?? [])
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    }

    // لو جاي من getAllScans: كل item هو الـ scan نفسه مع treatments جوه
    // { "_id": "...", "image_url": "...", "disease_ids": [...], "treatments": [...] }
    return ScanResultModel(
      plantScan: PlantScan.fromJson(json),
      treatments: (json['treatments'] as List? ?? [])
          .map((e) => TreatmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      products: [],
    );
  }
}