// lib/features/diagnosis/presentation/pages/diagnosis_detail_page.dart

import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';
import 'package:munbat_ai/features/diagnosis/data/models/scan_result_model.dart';

class DiagnosisDetailPage extends StatelessWidget {
  final ScanResultModel scan;

  const DiagnosisDetailPage({super.key, required this.scan});

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '${months[date.month - 1]} ${date.day}, ${date.year}  •  $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final plantScan = scan.plantScan;
    final isHealthy = plantScan.isHealthy;
    final statusColor = isHealthy ? AppColors.primary : const Color(0xFFE74C3C);
    final bgColor = isHealthy ? const Color(0xFFF0FAF0) : const Color(0xFFFFF5F5);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ─── AppBar with Image ───────────────────────────────────────
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text('Scan Details', style: AppTextStyles.h2),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              background: plantScan.imageUrl.isNotEmpty
                  ? Image.network(
                      plantScan.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: bgColor,
                        child: Center(
                          child: Icon(Icons.local_florist,
                              size: 80, color: statusColor),
                        ),
                      ),
                    )
                  : Container(
                      color: bgColor,
                      child: Center(
                        child: Icon(Icons.local_florist,
                            size: 80, color: statusColor),
                      ),
                    ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Status Badge ────────────────────────────────────
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isHealthy ? Icons.check_circle : Icons.warning_rounded,
                              color: statusColor,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isHealthy ? 'Healthy Plant' : 'Disease Detected',
                              style: AppTextStyles.caption.copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatDate(plantScan.scanDate),
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ─── Diseases Section ────────────────────────────────
                  if (!isHealthy) ...[
                    _SectionHeader(
                      icon: Icons.coronavirus_outlined,
                      title: 'Detected Diseases',
                      color: const Color(0xFFE74C3C),
                    ),
                    const SizedBox(height: 12),
                    ...plantScan.diseases.map((disease) => _DiseaseCard(
                          disease: disease,
                        )),
                    const SizedBox(height: 24),
                  ],

                  // ─── Treatments Section ──────────────────────────────
                  if (scan.treatments.isNotEmpty) ...[
                    _SectionHeader(
                      icon: Icons.medical_services_outlined,
                      title: 'Recommended Treatments',
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 12),
                    ...scan.treatments.asMap().entries.map((entry) =>
                        _TreatmentCard(
                          index: entry.key + 1,
                          treatment: entry.value,
                        )),
                    const SizedBox(height: 24),
                  ],

                  // ─── Healthy Message ─────────────────────────────────
                  if (isHealthy)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FAF0),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.eco,
                              color: AppColors.primary, size: 48),
                          const SizedBox(height: 12),
                          Text('Your plant looks great!',
                              style: AppTextStyles.h2),
                          const SizedBox(height: 8),
                          Text(
                            'No diseases were detected. Keep up the good care!',
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: AppColors.textSecondary),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Header ──────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 10),
        Text(title,
            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }
}

// ─── Disease Card ─────────────────────────────────────────────────────────────
class _DiseaseCard extends StatelessWidget {
  final DiseaseModel disease;

  const _DiseaseCard({required this.disease});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFE5E5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFE74C3C),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                disease.name,
                style: AppTextStyles.h3.copyWith(
                  fontSize: 15,
                  color: const Color(0xFFE74C3C),
                ),
              ),
            ],
          ),
          if (disease.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              disease.description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Treatment Card ───────────────────────────────────────────────────────────
class _TreatmentCard extends StatelessWidget {
  final int index;
  final TreatmentModel treatment;

  const _TreatmentCard({required this.index, required this.treatment});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$index',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  treatment.name,
                  style: AppTextStyles.h3.copyWith(fontSize: 15),
                ),
                if (treatment.instructions.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    treatment.instructions,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}