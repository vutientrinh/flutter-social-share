import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import 'package:flutter_social_share/providers/state_provider/upload_provider.dart';
import 'package:flutter_social_share/providers/state_provider/user_provider.dart';
import 'package:flutter_social_share/screens/authentication/login_screen.dart';
import 'package:flutter_social_share/screens/home_screen/home_page.dart';
import 'package:flutter_social_share/screens/profile_screen/profile_screen.dart';
import 'package:flutter_social_share/utils/uidata.dart';
import 'package:image_picker/image_picker.dart';
import 'package:another_flushbar/flushbar.dart';



import '../../model/user.dart';

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
  User? user;
  String avatar = '';
  String cover = '';

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

  Future<void> loadData() async {
    final userData = await ref.read(authServiceProvider).getSavedData();
    final response =
    await ref.read(userServiceProvider).getProfileById(userData['userId']);
      setState(() {
        user = response;
        _firstName.text = user?.firstName ?? '';
        _lastName.text = user?.lastName ?? '';
        _bio.text = user?.bio ?? '';
        _websiteUrl.text = user?.websiteUrl ?? '';
        avatar = user?.avatar ?? '';
        cover = user?.cover ?? '';
      });

  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> _submit() async {
    final fileService = ref.read(uploadServiceProvider);
    final userService = ref.read(userServiceProvider);

    if (!_formKey.currentState!.validate()) return;

    String updatedAvatar = avatar;
    String updatedCover = cover;

    // Upload new avatar if changed
    if (_avatarImage != null) {
      final response = await fileService.uploadFile(_avatarImage!);
      updatedAvatar = response.filename;
    }

    // Upload new cover if changed
    if (_coverImage != null) {
      final response = await fileService.uploadFile(_coverImage!);
      updatedCover = response.filename;
    }

    final String updatedFirstName =
    _firstName.text.trim().isEmpty ? user?.firstName ?? '' : _firstName.text.trim();
    final String updatedLastName =
    _lastName.text.trim().isEmpty ? user?.lastName ?? '' : _lastName.text.trim();
    final String updatedBio =
    _bio.text.trim().isEmpty ? user?.bio ?? '' : _bio.text.trim();
    final String updatedWebsiteUrl =
    _websiteUrl.text.trim().isEmpty ? user?.websiteUrl ?? '' : _websiteUrl.text.trim();

    await userService.updateProfile(
      updatedAvatar,
      updatedCover,
      updatedFirstName,
      updatedLastName,
      updatedBio,
      updatedWebsiteUrl,
    );

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
        'Successfully!',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white.withOpacity(0.9),
        ),
      ),
      backgroundColor: Colors.green.shade600,
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(seconds: 1),
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
      animationDuration: const Duration(milliseconds: 100),
      icon: const Icon(
        Icons.check_circle_outline,
        color: Colors.white,
        size: 28,
      ),
    ).show(context);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>  ProfileScreen(userId: user!.id)),
    );
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _bio.dispose();
    _websiteUrl.dispose();
    super.dispose();
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
                        : (cover.isNotEmpty
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        LINK_IMAGE.publicImage(user!.avatar),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                        : const Center(child: Text("Tap to pick cover image"))),
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
                        _avatarImage != null ? FileImage(_avatarImage!) : ((user?.avatar != null && user!.avatar!.isNotEmpty
                            ? NetworkImage(LINK_IMAGE.publicImage(user!.avatar!))
                            : null)),
                    child: (_avatarImage == null && avatar.isEmpty)
                        ? const Icon(Icons.person, size: 40, color: Colors.white)
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
                        icon: const Icon(Icons.edit,
                            size: 16, color: Colors.white),
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
                  label: const Text('Saved Profile'),
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
