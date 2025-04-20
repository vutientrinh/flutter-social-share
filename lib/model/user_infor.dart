class UserInfo {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String avatar;

  UserInfo({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      avatar: json['avatar'],
    );
  }
}
