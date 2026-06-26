// lib/features/diagnosis/presentation/widgets/diagnosis_content_card.dart
import 'package:munbat_ai/features/store/data/models/store_models.dart';
import 'package:munbat_ai/features/store/presentation/pages/product_details_page.dart';
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
          DiagnosisTitleRow(
            diseaseName: scan.isHealthy
                ? 'Healthy Plant'
                : topDisease?.name ?? 'Disease Detected',
          ),

          SizedBox(height: AppConstants.paddingMedium),

          DiagnosisBadgeRow(
            confidence: 0,
            isHealthy: scan.isHealthy,
            diseaseCount: scan.diseases.length,
          ),

          SizedBox(height: AppConstants.paddingLarge),

          DiagnosisSectionHeader(),
          SizedBox(height: AppConstants.paddingSmall),

          if (scan.isHealthy)
            DiagnosisDescription(
              description:
                  'Your plant appears to be in great health! Keep up the good care and monitor it regularly.',
            )
          else
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

          if (!scan.isHealthy) ...[
            TreatmentPlanHeader(),
            SizedBox(height: AppConstants.paddingMedium),

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

            if (products.isNotEmpty) ...[
              Text('Recommended Products', style: AppTextStyles.h2),
              SizedBox(height: AppConstants.paddingMedium),
              ...products.map((p) => _buildProductItem(context, p)),
              SizedBox(height: AppConstants.paddingLarge),
            ],

            BuyTreatmentButton(onPressed: onBuyTreatment),
          ],
        ],
      ),
    );
  }

  Widget _buildProductItem(BuildContext context, ProductModel product) {
    final bool isOutOfStock = product.status.toLowerCase() == 'out_of_stock';
    final bool isLowStock = product.status.toLowerCase() == 'low_stock';
    final bool hasDiscount =
        product.discount > 0 && product.discountedPrice < product.price;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailsPage(product: product),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // ─── صورة المنتج + Discount Badge ───────────────────
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ColorFiltered(
                      colorFilter: isOutOfStock
                          ? const ColorFilter.matrix([
                              0.2126, 0.7152, 0.0722, 0, 0,
                              0.2126, 0.7152, 0.0722, 0, 0,
                              0.2126, 0.7152, 0.0722, 0, 0,
                              0,      0,      0,      1, 0,
                            ])
                          : const ColorFilter.mode(
                              Colors.transparent, BlendMode.multiply),
                      child: product.imageUrl.isNotEmpty
                          ? Image.network(
                              product.imageUrl,
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _buildPlaceholder(),
                            )
                          : _buildPlaceholder(),
                    ),
                  ),

                  // ─── Discount Badge فوق الصورة ───────────────────
                  if (hasDiscount)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: Text(
                          '-${product.discount}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 12),

              // ─── المعلومات ────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    // ─── السعر (مع الخصم أو بدونه) ──────────────────
                    if (hasDiscount) ...[
                      Text(
                        '\$${product.discountedPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.grey,
                        ),
                      ),
                    ] else ...[
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],

                    const SizedBox(height: 5),

                    // ─── Stock Status ─────────────────────────────────
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: isOutOfStock
                            ? const Color(0xFFFF3B30).withOpacity(0.1)
                            : isLowStock
                                ? const Color(0xFFFF9500).withOpacity(0.1)
                                : const Color(0xFF34C759).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isOutOfStock
                                ? Icons.remove_circle_outline_rounded
                                : isLowStock
                                    ? Icons.warning_amber_rounded
                                    : Icons.check_circle_outline_rounded,
                            size: 10,
                            color: isOutOfStock
                                ? const Color(0xFFFF3B30)
                                : isLowStock
                                    ? const Color(0xFFE08800)
                                    : const Color(0xFF2AA64A),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            isOutOfStock
                                ? 'Out of Stock'
                                : isLowStock
                                    ? 'Low Stock'
                                    : 'In Stock',
                            style: TextStyle(
                              color: isOutOfStock
                                  ? const Color(0xFFFF3B30)
                                  : isLowStock
                                      ? const Color(0xFFE08800)
                                      : const Color(0xFF2AA64A),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ─── سهم للدلالة على إمكانية الضغط ──────────────────
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.primary.withOpacity(0.5),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.medical_services_outlined,
        color: AppColors.primary.withOpacity(0.5),
        size: 28,
      ),
    );
  }
}