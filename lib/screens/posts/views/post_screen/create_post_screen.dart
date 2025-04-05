import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_social_share/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<File> _images = [];
  String? username;
  String _layout = 'grid'; // options: grid, horizontal, vertical

  void _onPost() {
    final content = _controller.text.trim();
    if (content.isNotEmpty || _images.isNotEmpty) {
      // Send post logic here
      print('Posting: $content');
      print('Images count: ${_images.length}');
      Navigator.pop(context);
    }
  }
  void loadData() async {
    final data = await AuthService.getSavedData();
    setState(() {
      username = data['username'];
    });
  }
  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        _images.addAll(picked.map((e) => File(e.path)));
      });
    }
  }

  Widget _buildImageLayout() {
    if (_images.isEmpty) return const SizedBox();

    if (_images.length == 1) {
      return Image.file(_images.first, width: double.infinity, fit: BoxFit.cover);
    }

    if (_images.length == 2) {
      return Row(
        children: _images.map((img) {
          return Expanded(child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.file(img, fit: BoxFit.cover),
          ));
        }).toList(),
      );
    }

    if (_layout == 'horizontal') {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _images.map((img) => Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.file(img, width: 120, height: 120, fit: BoxFit.cover),
          )).toList(),
        ),
      );
    }

    if (_layout == 'vertical') {
      return Column(
        children: _images.map((img) => Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.file(img, width: double.infinity, height: 200, fit: BoxFit.cover),
        )).toList(),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _images.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _images.length <= 4 ? 2 : 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemBuilder: (context, index) => Image.file(_images[index], fit: BoxFit.cover),
    );
  }

  Widget _layoutSelector() {
    if (_images.length < 2) return const SizedBox();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLayoutButton('grid', Icons.grid_view),
        _buildLayoutButton('horizontal', Icons.view_week),
        _buildLayoutButton('vertical', Icons.view_agenda),
      ],
    );
  }

  Widget _buildLayoutButton(String type, IconData icon) {
    final isSelected = _layout == type;
    return IconButton(
      icon: Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
      onPressed: () {
        setState(() {
          _layout = type;
        });
      },
    );
  }


  @override
  void initState() {
    super.initState();
    loadData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          TextButton(
            onPressed: _onPost,
            child: const Text(
              'Post',
              style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(
                      'https://wallup.net/wp-content/uploads/2016/02/18/286966-nature-photography.jpg'),  // Use NetworkImage if needed
                ),
                const SizedBox(width: 10),
                Text(
                  username?? "Not found",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: "What’s on your mind?",
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildImageLayout(),
            const SizedBox(height: 10),
            _layoutSelector(),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImages,
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Add Images"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}