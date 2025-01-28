class User {
  final int id;
  final String username, email, department, role;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.department,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> data) {
    return User(
      id: data['id'],
      username: data['username'],
      email: data['email'],
      department: data['department'],
      role: data['role'],
    );
  }
}
