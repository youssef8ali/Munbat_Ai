// lib/features/home/presentation/widgets/status_badge.dart
import 'package:flutter/material.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/widgets/svg_icon.dart';

class StatusBadge extends StatelessWidget {
  final Color statusColor;
  final String statusIcon;

  const StatusBadge({
    super.key,
    required this.statusColor,
    required this.statusIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.background,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgIcon(assetPath: statusIcon , color: statusColor,),
        )
      ),
    );
  }
}
