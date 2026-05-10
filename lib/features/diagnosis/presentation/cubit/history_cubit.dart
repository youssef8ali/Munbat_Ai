// lib/features/diagnosis/presentation/cubit/history_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munbat_ai/features/diagnosis/data/models/scan_result_model.dart';
import 'package:munbat_ai/features/diagnosis/data/repositories/scan_repository.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final ScanRepository _scanRepository;

  HistoryCubit(this._scanRepository) : super(HistoryInitial());

  Future<void> loadHistory() async {
    emit(HistoryLoading());

    final scans = await _scanRepository.getAllScans();

    emit(HistorySuccess(scans: scans, filteredScans: scans));
  }

  void filter(String query) {
    final current = state;
    if (current is! HistorySuccess) return;

    if (query.isEmpty) {
      emit(current.copyWith(filteredScans: current.scans));
      return;
    }

    // ✅ FIX: تحديد النوع صراحة List<ScanResultModel>
    final List<ScanResultModel> filtered = current.scans.where((scan) {
      return scan.plantScan.diseases.any(
        (d) => d.name.toLowerCase().contains(query.toLowerCase()),
      );
    }).toList();

    emit(current.copyWith(filteredScans: filtered));
  }

  void filterByStatus(String type) {
    final current = state;
    if (current is! HistorySuccess) return;

    // ✅ FIX: تحديد النوع صراحة List<ScanResultModel>
    final List<ScanResultModel> filtered;

    switch (type) {
      case 'diseases':
        filtered =
            current.scans.where((s) => !s.plantScan.isHealthy).toList();
        break;
      case 'healthy':
        filtered =
            current.scans.where((s) => s.plantScan.isHealthy).toList();
        break;
      case 'week':
        final now = DateTime.now();
        filtered = current.scans
            .where((s) =>
                now.difference(s.plantScan.scanDate).inDays < 7)
            .toList();
        break;
      default:
        filtered = current.scans;
    }

    emit(current.copyWith(filteredScans: filtered));
  }
}