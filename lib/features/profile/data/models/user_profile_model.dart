// lib/features/profile/data/models/user_profile_model.dart

class UserProfileModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String address;
  final String phone;
  final DateTime? createdAt;

  UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.address,
    required this.phone,
    this.createdAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? 'user',
      address: json['address']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'email': email,
        'role': role,
        'address': address,
        'phone': phone,
      };

  UserProfileModel copyWith({
    String? name,
    String? address,
    String? phone,
  }) {
    return UserProfileModel(
      id: id,
      name: name ?? this.name,
      email: email,
      role: role,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      createdAt: createdAt,
    );
  }
}