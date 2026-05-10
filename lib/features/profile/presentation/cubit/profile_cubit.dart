// lib/features/profile/presentation/cubit/profile_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munbat_ai/features/profile/data/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;

  ProfileCubit(this._repository) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    final profile = await _repository.getProfile();
    if (profile != null) {
      emit(ProfileSuccess(profile));
    } else {
      emit(ProfileError('Failed to load profile'));
    }
  }

  Future<void> updateProfile({
    String? name,
    String? address,
    String? phone,
  }) async {
    final current = state;
    // نفضل الـ profile القديم عشان نعرضه وقت الـ loading
    if (current is ProfileSuccess) {
      emit(ProfileUpdateLoading(current.profile));
    }

    final updated = await _repository.updateProfile(
      name: name,
      address: address,
      phone: phone,
    );

    if (updated != null) {
      emit(ProfileUpdateSuccess(updated));
    } else {
      // لو فشل، نرجع للـ profile القديم
      if (current is ProfileSuccess) {
        emit(ProfileSuccess(current.profile));
      }
      emit(ProfileError('Failed to update profile'));
    }
  }
}