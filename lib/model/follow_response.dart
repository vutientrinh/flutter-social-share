class FollowUserResponse {
  final String id;
  final String username;
  final String? firstName;
  final String? lastName;
  final String? avatar;
  final bool hasFollowedBack;
  final String followAt;

  FollowUserResponse({
    required this.id,
    required this.username,
    this.firstName,
    this.lastName,
    this.avatar,
    required this.hasFollowedBack,
    required this.followAt,
  });

  factory FollowUserResponse.fromJson(Map<String, dynamic> json) {
    return FollowUserResponse(
      id: json['id'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      avatar: json['avatar'],
      hasFollowedBack: json['hasFollowedBack'],
      followAt: json['followAt'],
    );
  }
}