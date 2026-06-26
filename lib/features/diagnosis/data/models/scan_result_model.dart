// lib/features/diagnosis/data/models/scan_result_model.dart
import 'package:munbat_ai/features/store/data/models/store_models.dart';

// ─── Disease ──────────────────────────────────────────────────────────────
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

// ─── Treatment ────────────────────────────────────────────────────────────
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
      // ممكن تيجي string IDs أو objects فيها _id/name حسب الـ endpoint
      diseaseIds: ids
          .map((e) => e is Map ? (e['_id']?.toString() ?? '') : e.toString())
          .where((e) => e.isNotEmpty)
          .toList(),
    );
  }
}

// ─── Detected Disease (disease + its treatment + recommended products) ─────
class DetectedDiseaseModel {
  final DiseaseModel disease;
  final TreatmentModel? treatment;
  final List<ProductModel> products;
  final bool hasProducts;

  DetectedDiseaseModel({
    required this.disease,
    required this.treatment,
    required this.products,
    required this.hasProducts,
  });

  factory DetectedDiseaseModel.fromJson(Map<String, dynamic> json) {
    return DetectedDiseaseModel(
      disease: DiseaseModel.fromJson(
        json['disease'] as Map<String, dynamic>? ?? {},
      ),
      treatment: json['treatment'] != null
          ? TreatmentModel.fromJson(json['treatment'] as Map<String, dynamic>)
          : null,
      products: (json['products'] as List? ?? [])
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasProducts: json['hasProducts'] as bool? ?? false,
    );
  }
}

// ─── PlantScan ────────────────────────────────────────────────────────────
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
          .whereType<Map>()
          .map((e) => DiseaseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      scanDate: DateTime.tryParse(json['scan_date']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}

// ─── Full Scan Response ─────────────────────────────────────────────────────
class ScanResultModel {
  final PlantScan plantScan;
  final List<DetectedDiseaseModel> detectedDiseases;
  final List<TreatmentModel> treatments; // flattened (لكل disease treatment واحد)
  final List<ProductModel> products; // flattened من كل detectedDiseases

  ScanResultModel({
    required this.plantScan,
    required this.detectedDiseases,
    required this.treatments,
    required this.products,
  });

  factory ScanResultModel.fromJson(Map<String, dynamic> json) {
    // لو الـ response جاي بشكل { "message":..., "data": {...} } نفك data
    final Map<String, dynamic> data =
        (json['data'] is Map<String, dynamic>) ? json['data'] as Map<String, dynamic> : json;

    // الحالتين الممكنتين:
    // 1) scanImage / getScanById -> data = { "scan": {...}, "detectedDiseases": [...] , "summary": {...} }
    // 2) getAllScans (كل عنصر) -> data = { _id, image_url, disease_ids, ..., "detectedDiseases": [...] }
    final Map<String, dynamic> scanJson =
        (data['scan'] is Map<String, dynamic>) ? data['scan'] as Map<String, dynamic> : data;

    final List detectedRaw = (data['detectedDiseases'] as List?) ??
        (scanJson['detectedDiseases'] as List?) ??
        [];

    final detected = detectedRaw
        .whereType<Map>()
        .map((e) => DetectedDiseaseModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return ScanResultModel(
      plantScan: PlantScan.fromJson(scanJson),
      detectedDiseases: detected,
      treatments: detected
          .where((d) => d.treatment != null)
          .map((d) => d.treatment!)
          .toList(),
      products: detected.expand((d) => d.products).toList(),
    );
  }
}