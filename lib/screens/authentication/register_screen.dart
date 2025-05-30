import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/screens/authentication/login_screen.dart';
import 'package:flutter_social_share/screens/authentication/update_profile.dart';

import '../../providers/state_provider/auth_provider.dart';
import '../home_screen/home_page.dart';
import 'package:another_flushbar/flushbar.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _isLoading = false;

  // Replace with your service class name

  void _registerWithGoogle() async {
    // Placeholder: Add Google Sign-In logic using `google_sign_in` or Firebase Auth
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Google Sign-In not implemented")),
    );
  }

  Future<void> _handleRegister() async {
    final _authService =
        ref.read(authServiceProvider); // Create instance of AuthService

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final name = _usernameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      final response = await _authService.register(name, email, password);

      setState(() => _isLoading = false);

      if (response != null) {
        final response = await _authService.login(name, password);
        setState(() {
          _isLoading = false;
        });

        if (response != null && response.statusCode == 200) {
          await _authService.saveLoginData(response.data);

          await Flushbar(
            title: 'Success',
            message: 'Create new account successfully!',
            backgroundColor: Colors.green,
            flushbarPosition: FlushbarPosition.TOP,
            duration: const Duration(seconds: 1),
            margin: const EdgeInsets.all(8),
            borderRadius: BorderRadius.circular(8),
            animationDuration: const Duration(milliseconds: 200),
          ).show(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UpdateProfile()),
          );
        }
      } else {
        await Flushbar(
          title: 'Error',
          message: "The Email or Usename is existed, try again!!",
          backgroundColor: Colors.red,
          flushbarPosition: FlushbarPosition.TOP,
          duration: const Duration(seconds: 1),
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          animationDuration: const Duration(milliseconds: 200),
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Tell us about you',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 30),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  validator: (value) =>
                      value!.contains('@') ? null : 'Enter a valid email',
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _usernameController,
                  label: 'Username',
                  icon: Icons.person_outline,
                  validator: (value) =>
                      value!.isNotEmpty ? null : 'Username is required',
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  isObscure: _isObscure,
                  toggleObscure: () {
                    setState(() => _isObscure = !_isObscure);
                  },
                  validator: (value) => value!.length >= 6
                      ? null
                      : 'Password must be at least 6 characters',
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 80),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _handleRegister,
                        child: const Text(
                          'Create',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                const SizedBox(height: 16),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      'Back to login',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool isObscure = false,
    VoidCallback? toggleObscure,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? isObscure : false,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
                onPressed: toggleObscure,
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
