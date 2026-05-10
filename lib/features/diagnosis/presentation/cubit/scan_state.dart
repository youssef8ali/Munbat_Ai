// lib/features/diagnosis/presentation/cubit/scan_state.dart

import 'package:munbat_ai/features/diagnosis/data/models/scan_result_model.dart';

abstract class ScanState {}

class ScanInitial extends ScanState {}

class ScanLoading extends ScanState {}

class ScanSuccess extends ScanState {
  final ScanResultModel result;
  ScanSuccess(this.result);
}

class ScanError extends ScanState {
  final String message;
  ScanError(this.message);
}