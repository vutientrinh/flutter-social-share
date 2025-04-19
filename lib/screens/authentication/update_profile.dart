import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/state_provider/upload_provider.dart';
import 'package:flutter_social_share/providers/state_provider/user_provider.dart';
import 'package:flutter_social_share/screens/authentication/login_screen.dart';
import 'package:flutter_social_share/screens/home_screen/home_page.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfile extends ConsumerStatefulWidget {
  const UpdateProfile({super.key});

  @override
  ConsumerState<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends ConsumerState<UpdateProfile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _websiteUrl = TextEditingController();

  File? _avatarImage;
  File? _coverImage;

  Future<void> _pickImage(bool isAvatar) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (isAvatar) {
          _avatarImage = File(pickedFile.path);
        } else {
          _coverImage = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> _submit() async {
    final fileService = ref.read(uploadServiceProvider);
    final userService = ref.read(userServiceProvider);
    String avatar = '';
    String cover = '';
    if (!_formKey.currentState!.validate()) return;

    if (_avatarImage != null) {
      final response = await fileService.uploadFile(_avatarImage!);
      avatar = response.filename;
      print(avatar);
    }

    if (_coverImage != null) {
      final response = await fileService.uploadFile(_coverImage!);
      cover = response.filename;
      print(cover);
    }

    final response = userService.updateProfile(
      avatar,
      cover,
      _firstName.text.trim(),
      _lastName.text.trim(),
      _bio.text.trim(),
      _websiteUrl.text.trim(),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Cover Image with button
              Stack(
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _coverImage != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _coverImage!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                        : const Center(child: Text("Tap to pick cover image")),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.black45,
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: () => _pickImage(false),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Avatar Image with button
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                    _avatarImage != null ? FileImage(_avatarImage!) : null,
                    child: _avatarImage == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.blue,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                        onPressed: () => _pickImage(true),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Input fields inside Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildTextField(_firstName, 'First Name', true),
                      const SizedBox(height: 12),
                      _buildTextField(_lastName, 'Last Name', true),
                      const SizedBox(height: 12),
                      _buildTextField(_bio, 'Bio', false),
                      const SizedBox(height: 12),
                      _buildTextField(_websiteUrl, 'Website URL', false),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Update Profile'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      bool isRequired,
      ) {
    return TextFormField(
      controller: controller,
      validator: isRequired ? (val) => val!.isEmpty ? 'Required' : null : null,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
