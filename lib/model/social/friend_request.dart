class FriendRequest {
  final String id;
  final String requestId;
  final String username;
  final String? firstName;
  final String? lastName;
  final String? avatar;
  final String? createdAt;

  FriendRequest({
    required this.id,
    required this.requestId,
    required this.username,
    this.firstName,
    this.lastName,
    this.avatar,
    this.createdAt,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      id: json['id'],
      requestId: json['requestId'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      avatar: json['avatar'],
      createdAt: json['createdAt'],
    );
  }
}
