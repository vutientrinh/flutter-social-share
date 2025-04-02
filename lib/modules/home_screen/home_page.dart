import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_share/modules/ecommerce_screen/ecommerce_home_screen.dart';
import 'package:flutter_social_share/modules/friend_screen/friend_screen.dart';
import 'package:flutter_social_share/modules/notification_screen/notification_screen.dart';
import 'package:flutter_social_share/modules/profile_screen/profile_screen.dart';

import '../posts/views/post_screen/post_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  var navbarItems = [
    const BottomNavigationBarItem(
        icon: Icon(Icons.home, size: 26), label: "Home"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.shopping_cart, size: 26), // Added Shopping Icon
        label: "Shopping"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.group, size: 26), label: "Friends"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.circle_notifications_outlined, size: 26),
        label: "Notifications"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.person, size: 26), label: "Profile")
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _pages = [
    ListPostsScreen(),
    EcommerceHomeScreen(),
    FriendScreen(),
    NotificationScreen(),
    ProfileScreen(followerName: "Vu tien trinh"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: navbarItems,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
        ));
  }
}
