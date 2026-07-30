class ProfileData {
  final String id;
  final String role;
  final String email;
  final String name;

  ProfileData({
    required this.id,
    required this.role,
    required this.email,
    required this.name,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'] ?? '',
      role: json['role'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'email': email,
      'name': name,
    };
  }
}
