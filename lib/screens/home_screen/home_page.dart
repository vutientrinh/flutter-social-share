import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/screens/ecommerce_screen/ecommerce_home_screen.dart';
import 'package:flutter_social_share/screens/friend_screen/friend_screen.dart';
import 'package:flutter_social_share/screens/notification_screen/notification_screen.dart';
import 'package:flutter_social_share/screens/profile_screen/profile_screen.dart';

import '../../providers/state_provider/auth_provider.dart';
import '../posts/views/post_screen.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;
  late String authorId;
  bool isLoading = true;
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

  Future<void> loadData() async {
    final authService = ref.read(authServiceProvider);
    final data = await authService.getSavedData();
    setState(() {
      authorId = data['userId'];
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final List<Widget> _pages = [
      const ListPostsScreen(),
      const EcommerceHomeScreen(),
      const FriendScreen(),
      const NotificationScreen(),
      ProfileScreen(
        userId: authorId,
      ),
    ];
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
