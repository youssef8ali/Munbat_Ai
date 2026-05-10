// lib/features/diagnosis/presentation/cubit/history_state.dart

import 'package:munbat_ai/features/diagnosis/data/models/scan_result_model.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistorySuccess extends HistoryState {
  final List<ScanResultModel> scans;
  final List<ScanResultModel> filteredScans;

  HistorySuccess({
    required this.scans,
    required this.filteredScans,
  });

  HistorySuccess copyWith({
    List<ScanResultModel>? scans,
    List<ScanResultModel>? filteredScans,
  }) {
    return HistorySuccess(
      scans: scans ?? this.scans,
      filteredScans: filteredScans ?? this.filteredScans,
    );
  }
}

class HistoryError extends HistoryState {
  final String message;
  HistoryError(this.message);
}