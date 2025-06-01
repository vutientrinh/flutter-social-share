import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import 'package:flutter_social_share/screens/authentication/forgot_password_screen.dart';
import 'package:flutter_social_share/screens/authentication/register_screen.dart';
import '../home_screen/home_page.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true; // State to track password visibility
  bool _isLoading = false; // Track login state

  Future<void> _handleLogin() async {
    final _authService =
        ref.read(authServiceProvider); // Create instance of AuthService

    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    final response = await _authService.login(username, password);
    setState(() {
      _isLoading = false;
    });
    final noti = response.data;
    if (response.statusCode == 200) {
      await _authService.saveLoginData(response.data);
      // Navigate to HomePage on successful login
      await Flushbar(
        titleText: const Text(
          '✅ Success',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        messageText: Text(
          "Login successfully",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        backgroundColor: Colors.green.shade600,
        flushbarPosition: FlushbarPosition.TOP,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        borderRadius: BorderRadius.circular(12),
        boxShadows: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
        animationDuration: const Duration(milliseconds: 200),
        icon: const Icon(
          Icons.check_circle_outline,
          color: Colors.white,
          size: 28,
        ),
      ).show(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      await Flushbar(
        title: 'Error',
        message: noti['message'].toString(),
        backgroundColor: Colors.red,
        flushbarPosition: FlushbarPosition.TOP,
        duration: const Duration(seconds: 1),
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        animationDuration: const Duration(milliseconds: 100),
      ).show(context);
    }
  }
  Future<void> _handleGoogleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var baseUrl = dotenv.env['API_BASE_URL']; // Replace with your domain
      final googleLoginUrl = Uri.parse('${baseUrl}oauth2/authorization/google');

      // Launch the Google login URL in the browser
      if (await canLaunchUrl(googleLoginUrl)) {
        await launchUrl(
          googleLoginUrl,
          mode: LaunchMode.externalApplication, // Opens in external browser
        );
      } else {
        throw 'Could not launch $googleLoginUrl';
      }

      setState(() {
        _isLoading = false;
      });

    } catch (e, stackTrace) {
      setState(() {
        _isLoading = false;
      });


      if (context.mounted) {
        await Flushbar(
          titleText: const Text(
            'Error',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          messageText: Text(
            'Failed to redirect to Google login: ${e.toString()}',
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          backgroundColor: Colors.red.shade600,
          flushbarPosition: FlushbarPosition.TOP,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          borderRadius: BorderRadius.circular(12),
          animationDuration: const Duration(milliseconds: 300),
          icon: const Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 28,
          ),
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 5),
          SizedBox(
            height: 160.0,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/image2/login.png',
            ),
          ),
          const Center(
            child: Text(
              'Welcome back!',
              style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.w900),
            ),
          ),
          Center(
            child: Text(
              'Log into your account and get started!',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w300,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure =
                              !_isObscure; // Toggle password visibility
                        });
                      },
                    ),
                  ),
                  obscureText: _isObscure,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotPasswordScreen()),
                        );
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),

                          minimumSize: const Size(double.infinity, 56), // Match text field height
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                        ),
                        onPressed: _handleLogin, // Call login function
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.grey),
                    ),
                    minimumSize: const Size(double.infinity, 56), // Match text field height
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                  ),
                  onPressed: _handleGoogleLogin,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://www.google.com/favicon.ico',
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Login with Google',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account?'),
                    const SizedBox(width: 5.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
