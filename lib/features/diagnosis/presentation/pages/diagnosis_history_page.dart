// lib/features/diagnosis/presentation/pages/diagnosis_history_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munbat_ai/core/theme/app_color.dart';
import 'package:munbat_ai/core/theme/app_text_styles.dart';
import 'package:munbat_ai/features/diagnosis/data/models/scan_result_model.dart';
import 'package:munbat_ai/features/diagnosis/data/repositories/scan_repository.dart';
import 'package:munbat_ai/features/diagnosis/presentation/cubit/history_cubit.dart';
import 'package:munbat_ai/features/diagnosis/presentation/cubit/history_state.dart';
import 'package:munbat_ai/features/diagnosis/presentation/widgets/diagnosis_card.dart';

class DiagnosisHistoryPage extends StatelessWidget {
  const DiagnosisHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HistoryCubit(ScanRepository())..loadHistory(),
      child: const _DiagnosisHistoryView(),
    );
  }
}

class _DiagnosisHistoryView extends StatefulWidget {
  const _DiagnosisHistoryView();

  @override
  State<_DiagnosisHistoryView> createState() => _DiagnosisHistoryViewState();
}

class _DiagnosisHistoryViewState extends State<_DiagnosisHistoryView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Map<String, List<ScanResultModel>> _groupByDate(
      List<ScanResultModel> scans) {
    final now = DateTime.now();
    final Map<String, List<ScanResultModel>> grouped = {};

    for (var scan in scans) {
      final date = scan.plantScan.scanDate;
      final diff = now.difference(date).inDays;

      String key;
      if (diff < 7) {
        key = 'THIS WEEK';
      } else {
        const months = [
          'January', 'February', 'March', 'April', 'May', 'June',
          'July', 'August', 'September', 'October', 'November', 'December'
        ];
        key = '${months[date.month - 1].toUpperCase()} ${date.year}';
      }

      grouped.putIfAbsent(key, () => []).add(scan);
    }

    return grouped;
  }

  void _showFilterOptions(BuildContext context) {
    final cubit = context.read<HistoryCubit>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter by', style: AppTextStyles.h2),
            const SizedBox(height: 20),
            _FilterOption(
              label: 'All Diagnoses',
              onTap: () {
                cubit.filterByStatus('all');
                Navigator.pop(context);
              },
            ),
            _FilterOption(
              label: 'Diseases Only',
              onTap: () {
                cubit.filterByStatus('diseases');
                Navigator.pop(context);
              },
            ),
            _FilterOption(
              label: 'Healthy Plants',
              onTap: () {
                cubit.filterByStatus('healthy');
                Navigator.pop(context);
              },
            ),
            _FilterOption(
              label: 'This Week',
              onTap: () {
                cubit.filterByStatus('week');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

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
        title: Text(
          'Diagnosis History',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading || state is HistoryInitial) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is HistoryError) {
            return Center(
              child: Text(state.message,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textSecondary)),
            );
          }

          if (state is HistorySuccess) {
            if (state.scans.isEmpty) {
              return _buildEmptyState();
            }

            final grouped = _groupByDate(state.filteredScans);
            final groupKeys = grouped.keys.toList();

            return Column(
              children: [
                // Search + Filter
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (q) =>
                                context.read<HistoryCubit>().filter(q),
                            decoration: InputDecoration(
                              hintText: 'Search diseases...',
                              hintStyle: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary),
                              prefixIcon: Icon(Icons.search,
                                  color: AppColors.textSecondary
                                      .withOpacity(0.6)),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(Icons.tune,
                              color:
                                  AppColors.textSecondary.withOpacity(0.6)),
                          onPressed: () => _showFilterOptions(context),
                        ),
                      ),
                    ],
                  ),
                ),

                // List
                Expanded(
                  child: state.filteredScans.isEmpty
                      ? Center(
                          child: Text('No results found',
                              style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary)),
                        )
                      : ListView.builder(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: groupKeys.length * 2,
                          itemBuilder: (context, index) {
                            final groupIndex = index ~/ 2;
                            if (groupIndex >= groupKeys.length) {
                              return const SizedBox.shrink();
                            }

                            if (index.isEven) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 8, bottom: 16),
                                child: Text(
                                  groupKeys[groupIndex],
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              );
                            } else {
                              final scans =
                                  grouped[groupKeys[groupIndex]]!;
                              return Column(
                                children: scans.map((scan) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 12),
                                    child: DiagnosisCard(scan: scan),
                                  );
                                }).toList(),
                              );
                            }
                          },
                        ),
                ),

                const SizedBox(height: 60),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          Text('No scans yet', style: AppTextStyles.h2),
          const SizedBox(height: 8),
          Text(
            'Scan a plant to see your diagnosis history here.',
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FilterOption extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FilterOption({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label, style: AppTextStyles.bodyMedium),
      trailing:
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}