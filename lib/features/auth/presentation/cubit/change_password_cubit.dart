import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munbat_ai/features/auth/data/repositories/auth_repository.dart';
import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final AuthRepository _repository;

  ChangePasswordCubit(this._repository) : super(ChangePasswordInitial());

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(ChangePasswordLoading());

    final result = await _repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    if (result.success) {
      emit(ChangePasswordSuccess(result.message ?? 'Password changed successfully'));
    } else {
      emit(ChangePasswordError(result.message ?? 'Failed to change password'));
    }
  }
}