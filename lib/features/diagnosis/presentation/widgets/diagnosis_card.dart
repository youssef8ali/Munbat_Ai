// lib/features/diagnosis/presentation/widgets/diagnosis_card.dart

import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';
import 'package:munbat_ai/features/diagnosis/data/models/scan_result_model.dart';
import 'package:munbat_ai/features/diagnosis/presentation/pages/diagnosis_detail_page.dart';

class DiagnosisCard extends StatelessWidget {
  final ScanResultModel scan;

  const DiagnosisCard({super.key, required this.scan});

  String _getTimeText(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;

    if (diff == 0) {
      final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
      final period = date.hour >= 12 ? 'PM' : 'AM';
      return 'Today, $hour:${date.minute.toString().padLeft(2, '0')} $period';
    } else if (diff == 1) {
      return 'Yesterday';
    } else {
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final plantScan = scan.plantScan;
    final isHealthy = plantScan.isHealthy;
    final topDisease =
        plantScan.diseases.isNotEmpty ? plantScan.diseases.first : null;

    final statusColor =
        isHealthy ? AppColors.primary : const Color(0xFFE74C3C);
    final bgColor = isHealthy
        ? const Color(0xFFF0FAF0)
        : const Color(0xFFFFF5F5);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DiagnosisDetailPage(scan: scan),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.local_florist,
                      color: statusColor,
                      size: 32,
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isHealthy ? Icons.check : Icons.warning,
                        color: AppColors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isHealthy
                        ? 'Healthy Plant'
                        : topDisease?.name ?? 'Disease Detected',
                    style: AppTextStyles.h3.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isHealthy
                        ? 'No diseases detected'
                        : topDisease?.description ?? '',
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 12,
                      color: statusColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (!isHealthy && plantScan.diseases.length > 1)
                    Text(
                      '+${plantScan.diseases.length - 1} more disease(s)',
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),

            // Timestamp and Arrow
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _getTimeText(plantScan.scanDate),
                  style: AppTextStyles.caption.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 8),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary.withOpacity(0.4),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}