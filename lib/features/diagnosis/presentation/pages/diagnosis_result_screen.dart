// lib/features/diagnosis/presentation/pages/diagnosis_result_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';
import 'package:munbat_ai/features/checkout/presentation/pages/checkout_screen.dart';
import 'package:munbat_ai/features/diagnosis/data/repositories/scan_repository.dart';
import 'package:munbat_ai/features/diagnosis/presentation/cubit/scan_cubit.dart';
import 'package:munbat_ai/features/diagnosis/presentation/cubit/scan_state.dart';
import 'package:munbat_ai/features/diagnosis/presentation/widgets/diagnosis_Image_section.dart';
import 'package:munbat_ai/features/diagnosis/presentation/widgets/diagnosis_content_card.dart';

class DiagnosisResultScreen extends StatelessWidget {
  final String imagePath;

  const DiagnosisResultScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScanCubit(ScanRepository())..scanImage(imagePath),
      child: _DiagnosisResultView(imagePath: imagePath),
    );
  }
}

class _DiagnosisResultView extends StatelessWidget {
  final String imagePath;

  const _DiagnosisResultView({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Scan Result', style: AppTextStyles.h2),
        centerTitle: true,
      ),
      body: BlocBuilder<ScanCubit, ScanState>(
        builder: (context, state) {
          if (state is ScanLoading || state is ScanInitial) {
            return _buildLoadingView();
          }
          if (state is ScanError) {
            return _buildErrorView(context, state.message);
          }
          if (state is ScanSuccess) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  DiagnosisImageSection(imagePath: imagePath),
                  DiagnosisContentCard(
                    scanResult: state.result,
                    onBuyTreatment: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CheckoutScreen()),
                      );
                    },
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 24),
          Text('Analyzing your plant...',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Text('This may take a few seconds',
              style: AppTextStyles.caption
                  .copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline,
                color: AppColors.categoryDisease, size: 64),
            const SizedBox(height: 16),
            Text('Scan Failed', style: AppTextStyles.h2),
            const SizedBox(height: 8),
            Text(message,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () =>
                  context.read<ScanCubit>().scanImage(imagePath),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Try Again',
                  style: TextStyle(color: AppColors.white)),
            ),
          ],
        ),
      ),
    );
  }
}