// lib/features/profile/presentation/cubit/profile_state.dart

import 'package:munbat_ai/features/profile/data/models/user_profile_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final UserProfileModel profile;
  ProfileSuccess(this.profile);
}

class ProfileUpdateLoading extends ProfileState {
  final UserProfileModel profile; // نفضل نعرض البيانات القديمة وقت الـ loading
  ProfileUpdateLoading(this.profile);
}

class ProfileUpdateSuccess extends ProfileState {
  final UserProfileModel profile;
  ProfileUpdateSuccess(this.profile);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}