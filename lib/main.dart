import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_social_share/screens/authentication/login_screen.dart';
import 'package:flutter_social_share/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  print("🌍 API Base URL: ${dotenv.env['API_BASE_URL']}");

  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home:  AuthCheck(),

    );
  }
}
class AuthCheck extends StatefulWidget {
  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool _isAuthenticated = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  // Method to check if the token exists and is valid
  Future<void> _checkAuthStatus() async {
    final authService = AuthService();

    bool isValid = await authService.introspect();

    if (isValid) {
      setState(() {
        _isAuthenticated = true;
      });
    } else {
      setState(() {
        _isAuthenticated = false;
      });
    }

    setState(() {
      _isLoading = false;
    });

    if (!_isAuthenticated) {
      _navigateToLoginScreen();
    }
  }

  // Navigate to the login screen
  void _navigateToLoginScreen() {
    // Using Navigator to redirect to the login screen if not authenticated
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // If the user is authenticated, show the main content
    return Scaffold(
      body: Center(
        child: _isAuthenticated
            ? Text("Authenticated!") // Main screen or Home page
            : ElevatedButton(
          onPressed: () {
            // Manually trigger login if necessary
            _navigateToLoginScreen();
          },
          child: Text("Go to Login"),
        ),
      ),
    );
  }
}