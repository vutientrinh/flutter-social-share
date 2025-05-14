import '../user.dart';

class FriendConnection {
  final String connectionId;
  final String connectionUsername;
  final String convId;
  final User user;
  final int unSeen;
  final bool isOnline;

  FriendConnection({
    required this.connectionId,
    required this.connectionUsername,
    required this.convId,
    required this.user,
    required this.unSeen,
    required this.isOnline,
  });

  factory FriendConnection.fromJson(Map<String, dynamic> json) {
    return FriendConnection(
      connectionId: json['connectionId'],
      connectionUsername: json['connectionUsername'],
      convId: json['convId'],
      user: User.fromJson(json['user']),
      unSeen: json['unSeen'],
      isOnline: json['isOnline'],
    );
  }
}
