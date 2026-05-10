// lib/features/diagnosis/presentation/widgets/diagnosis_content_card.dart

import 'package:flutter/material.dart';
import 'package:munbat_ai/core/constants/app_constants.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';
import 'package:munbat_ai/features/diagnosis/data/models/scan_result_model.dart';
import 'package:munbat_ai/features/diagnosis/presentation/widgets/buy_treatment_button.dart';
import 'package:munbat_ai/features/diagnosis/presentation/widgets/diagnosis_badge_row.dart';
import 'package:munbat_ai/features/diagnosis/presentation/widgets/diagnosis_description.dart';
import 'package:munbat_ai/features/diagnosis/presentation/widgets/diagnosis_section_header.dart';
import 'package:munbat_ai/features/diagnosis/presentation/widgets/diagnosis_title_row.dart';
import 'package:munbat_ai/features/diagnosis/presentation/widgets/treatment_Item.dart';
import 'package:munbat_ai/features/diagnosis/presentation/widgets/treatment_plan_header.dart';

class DiagnosisContentCard extends StatelessWidget {
  final ScanResultModel scanResult;
  final VoidCallback onBuyTreatment;

  const DiagnosisContentCard({
    super.key,
    required this.scanResult,
    required this.onBuyTreatment,
  });

  @override
  Widget build(BuildContext context) {
    final scan = scanResult.plantScan;
    final treatments = scanResult.treatments;
    final products = scanResult.products;
    final topDisease = scan.diseases.isNotEmpty ? scan.diseases.first : null;

    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ اسم المرض الحقيقي من الـ API
          DiagnosisTitleRow(
            diseaseName: scan.isHealthy
                ? 'Healthy Plant'
                : topDisease?.name ?? 'Disease Detected',
          ),

          SizedBox(height: AppConstants.paddingMedium),

          // ✅ badge — لو في أكتر من مرض بيعرض عددهم
          DiagnosisBadgeRow(
            confidence: 0, // مفيش confidence في الـ response
            isHealthy: scan.isHealthy,
            diseaseCount: scan.diseases.length,
          ),

          SizedBox(height: AppConstants.paddingLarge),

          // ✅ كل الأمراض المكتشفة
          DiagnosisSectionHeader(),
          SizedBox(height: AppConstants.paddingSmall),

          if (scan.isHealthy)
            DiagnosisDescription(
              description:
                  'Your plant appears to be in great health! Keep up the good care and monitor it regularly.',
            )
          else
            // ✅ بيعرض كل مرض باسمه ووصفه من الـ API
            ...scan.diseases.map(
              (disease) => Padding(
                padding:
                    const EdgeInsets.only(bottom: AppConstants.paddingMedium),
                child: DiagnosisDescription(
                  description: '• ${disease.name}: ${disease.description}',
                ),
              ),
            ),

          SizedBox(height: AppConstants.paddingLarge),

          // ✅ Treatment Plan
          if (!scan.isHealthy) ...[
            TreatmentPlanHeader(),
            SizedBox(height: AppConstants.paddingMedium),

            // ✅ الـ treatments من الـ API باسم العلاج والـ instructions
            ...treatments.map(
              (t) => Padding(
                padding:
                    const EdgeInsets.only(bottom: AppConstants.paddingMedium),
                child: TreatmentItem(
                  icon: Icons.medical_services,
                  iconColor: AppColors.categoryPests,
                  title: t.name,
                  description: t.instructions,
                ),
              ),
            ),

            if (treatments.isEmpty) ...[
              TreatmentItem(
                icon: Icons.cut,
                iconColor: AppColors.categoryPests,
                title: 'Prune Infected Leaves',
                description:
                    'Remove infected leaves immediately to stop spread.',
              ),
            ],

            SizedBox(height: AppConstants.paddingLarge),

            // ✅ Products من الـ API
            if (products.isNotEmpty) ...[
              Text('Recommended Products', style: AppTextStyles.h2),
              SizedBox(height: AppConstants.paddingMedium),
              ...products.map((p) => _buildProductItem(p)),
              SizedBox(height: AppConstants.paddingLarge),
            ],

            // Buy button
            BuyTreatmentButton(onPressed: onBuyTreatment),
          ],
        ],
      ),
    );
  }

  Widget _buildProductItem(ProductModel product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          // ✅ صورة المنتج من Cloudinary
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: product.imageUrl.isNotEmpty
                ? Image.network(
                    product.imageUrl,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholder(),
                  )
                : _buildPlaceholder(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${product.quantity} in stock',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.medical_services_outlined,
        color: AppColors.textSecondary,
        size: 28,
      ),
    );
  }
}