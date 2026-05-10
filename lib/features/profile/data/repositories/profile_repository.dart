// lib/features/profile/data/repositories/profile_repository.dart

import 'package:flutter/foundation.dart';
import 'package:munbat_ai/core/services/api_service.dart';
import 'package:munbat_ai/features/profile/data/models/user_profile_model.dart';

class ProfileRepository {
  final ApiService _apiService = ApiService();

  // GET /user/profile
  Future<UserProfileModel?> getProfile() async {
    try {
      final response = await _apiService.getProfile();
      debugPrint('GET PROFILE RESPONSE => ${response.data}');

      // response: { "message": "...", "data": { "_id": "...", "name": "...", ... } }
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      return UserProfileModel.fromJson(data);
    } catch (e) {
      debugPrint('GET PROFILE ERROR => $e');
      return null;
    }
  }

  // PUT /user/profile
  Future<UserProfileModel?> updateProfile({
    String? name,
    String? address,
    String? phone,
  }) async {
    try {
      final response = await _apiService.updateProfile(
        name: name,
        address: address,
        phone: phone,
      );
      debugPrint('UPDATE PROFILE RESPONSE => ${response.data}');

      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      return UserProfileModel.fromJson(data);
    } catch (e) {
      debugPrint('UPDATE PROFILE ERROR => $e');
      return null;
    }
  }
}