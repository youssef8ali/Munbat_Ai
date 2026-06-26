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
    String? imagePath,
    bool removeImage = false, // ✅ جديد
  }) async {
    final current = state;
    if (current is ProfileSuccess) {
      emit(ProfileUpdateLoading(current.profile));
    }

    final updated = await _repository.updateProfile(
      name: name,
      address: address,
      phone: phone,
      imagePath: imagePath,
      removeImage: removeImage, // ✅ تمريرها
    );

    if (updated != null) {
      emit(ProfileUpdateSuccess(updated));
    } else {
      if (current is ProfileSuccess) {
        emit(ProfileSuccess(current.profile));
      }
      emit(ProfileError('Failed to update profile'));
    }
  }
}