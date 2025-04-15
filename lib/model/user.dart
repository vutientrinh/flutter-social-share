class User {
  final String id;
  final String username;
  final String avatar;
  final String? firstName;
  final String? lastName;
  final List<dynamic>? roles;
  final String? bio;
  final String? websiteUrl;
  final int? followerCount;
  final int? friendsCount;
  final int? postCount;

  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.username,
    required this.avatar,
    required this.firstName,
    required this.lastName,
    this.roles,
    this.bio,
    this.websiteUrl,
    this.followerCount,
    this.friendsCount,
    this.postCount,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      avatar: json['avatar'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      roles: json['roles']??[],
      bio: json['bio'],
      websiteUrl: json['websiteUrl'],
      followerCount: json['followerCount'],
      friendsCount: json['friendsCount'],
      postCount: json['postCount'],
      status: json['status'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}
