import 'package:flutter/material.dart';
import 'package:flutter_social_share/screens/authentication/login_screen.dart';
import 'package:flutter_social_share/screens/home_screen/home_page.dart';
import 'package:flutter_social_share/services/auth_service.dart';
import 'package:flutter_social_share/services/user_service.dart';
import '../providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'model/user.dart';

class AuthCheck extends ConsumerStatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends ConsumerState<AuthCheck> {
  String userId = "";

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  // Method to check if the token exists and is valid
  Future<void> _checkAuthStatus() async {
    bool isValid = await AuthService().introspect();
    final savedData = await AuthService.getSavedData();
    final user = await UserService().getProfileById(savedData['userId']);

    // Navigate to the appropriate screen based on authentication status
    if (!isValid) {
      _navigateToLoginScreen();
    }
    ref.read(userProvider.notifier).state = user;
    _navigateToHomeScreen();
  }

  // Navigate to the login screen
  void _navigateToLoginScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  // Navigate to the home screen
  void _navigateToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
