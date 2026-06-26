// lib/features/diagnosis/presentation/cubit/scan_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munbat_ai/features/diagnosis/data/repositories/scan_repository.dart';
import 'scan_state.dart';

class ScanCubit extends Cubit<ScanState> {
  final ScanRepository _scanRepository;

  ScanCubit(this._scanRepository) : super(ScanInitial());

  Future<void> scanImage(String imagePath) async {
    emit(ScanLoading());

    try {
      final result = await _scanRepository.scanImage(imagePath);

      if (result == null) {
        emit(ScanError('Could not analyze the image. Please try again.'));
        return;
      }

      emit(ScanSuccess(result));
    } on ScanException catch (e) {
      emit(ScanError(e.message));
    } catch (e) {
      emit(ScanError('Could not analyze the image. Please try again.'));
    }
  }

  void reset() => emit(ScanInitial());
}