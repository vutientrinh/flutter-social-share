import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'icon': Icons.favorite,
        'content': 'Alice liked your photo.',
        'time': '5 mins ago'
      },
      {
        'icon': Icons.comment,
        'content': 'Bob commented on your post.',
        'time': '15 mins ago'
      },
      {
        'icon': Icons.group,
        'content': 'You have a new friend request.',
        'time': '30 mins ago'
      },
      {
        'icon': Icons.shopping_cart,
        'content': 'Your order has been shipped!',
        'time': '1 hour ago'
      },
      {
        'icon': Icons.shopping_cart,
        'content': 'Your order has been shipped!',
        'time': '1 hour ago'
      },
      {
        'icon': Icons.shopping_cart,
        'content': 'Your order has been shipped!',
        'time': '1 hour ago'
      },
      {
        'icon': Icons.shopping_cart,
        'content': 'Your order has been shipped!',
        'time': '1 hour ago'
      }


    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            leading: Icon(notification['icon'] as IconData, color: Colors.blue),
            title: Text(notification['content'] as String),
            subtitle: Text(notification['time'] as String),
            onTap: () {
              // Handle notification click
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Clicked: ${notification['content']}"))
              );
            },
          );
        },
      ),
    );
  }
}
