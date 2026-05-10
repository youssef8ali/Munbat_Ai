class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? address;
  final String? phone;
  final String? createdAt;
 
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.address,
    this.phone,
    this.createdAt,
  });
 
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      address: json['address'],
      phone: json['phone'],
      createdAt: json['created_at'],
    );
  }
 
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'address': address,
      'phone': phone,
    };
  }
}