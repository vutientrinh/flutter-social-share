class User {
  final String id;
  final String username;
  final String? avatar;
  final String? firstName;
  final String? lastName;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.username,
    this.avatar,
    this.firstName,
    this.lastName,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      avatar: json['avatar'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
