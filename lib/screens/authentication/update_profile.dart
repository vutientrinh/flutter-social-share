import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/state_provider/upload_provider.dart';
import 'package:flutter_social_share/providers/state_provider/user_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:mime/mime.dart';

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
    }

    if (_coverImage != null) {
      final response = await fileService.uploadFile(_coverImage!);
      cover = response.filename;
    }
    final response = userService.updateProfile(
      avatar,
      cover,
      _firstName.text.trim(),
      _lastName.text.trim(),
      _bio.text.trim(),
      _websiteUrl.text.trim(),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: () => _pickImage(true),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      _avatarImage != null ? FileImage(_avatarImage!) : null,
                  child: _avatarImage == null ? const Icon(Icons.person) : null,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _pickImage(false),
                child: Container(
                  height: 120,
                  color: Colors.grey[300],
                  child: _coverImage == null
                      ? const Center(child: Text("Tap to pick cover image"))
                      : Image.file(_coverImage!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _firstName,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _lastName,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _bio,
                decoration: const InputDecoration(labelText: 'Bio'),
              ),
              TextFormField(
                controller: _websiteUrl,
                decoration: const InputDecoration(labelText: 'Website URL'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Update Profile'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
