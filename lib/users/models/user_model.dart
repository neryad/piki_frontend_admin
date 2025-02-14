class User {
  final int id;
  final String name;
  final String lastName;
  final String email;
  final String phone;
  final int roleId;
  final String createdAt;

  User({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.roleId,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      roleId: json['role_id'],
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'role': roleId == 2 ? 'Admin' : 'Usuario',
    };
  }
}
