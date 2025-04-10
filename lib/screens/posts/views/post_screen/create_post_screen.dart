import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_social_share/services/auth_service.dart';
import 'package:flutter_social_share/services/post_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../model/post.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<File> _images = [];
  String? username;
  String? userId;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final data = await AuthService.getSavedData();
    setState(() {
      username = data['username'];
      userId = data['userId'];
    });
  }

  Future<void> _onPost() async {
    try {
      final postRequest = Post(
        content: "text status",
        images:
          "http://localhost:9001/api/v1/download-shared-object/aHR0cDovLzEyNy4wLjAuMTo5MDAwL3NhdGNoYXQvZGFyay1ibHVlLXBpbmstMzg0MHgyMTYwLTEyNjYxLmpwZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPVpKS0M3RjNNODkyMlNFN1FSRjRMJTJGMjAyNTA0MTAlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUwNDEwVDA2NTQxMlomWC1BbXotRXhwaXJlcz00MzE5OSZYLUFtei1TZWN1cml0eS1Ub2tlbj1leUpoYkdjaU9pSklVelV4TWlJc0luUjVjQ0k2SWtwWFZDSjkuZXlKaFkyTmxjM05MWlhraU9pSmFTa3RETjBZelRUZzVNakpUUlRkUlVrWTBUQ0lzSW1WNGNDSTZNVGMwTkRNeE1USTBNaXdpY0dGeVpXNTBJam9pYldsdWFXOWhaRzFwYmlKOS50VFI2ZHgzTk1zQ3JpVjUzTTdDY3BBS2VyMXIwU044Ry1WLS16aTRidWFQOEpOTkx3d1FMWjZrREFuZF90cmJoRjNkVC1hSG5KN2lzaURIUXZqRFFPUSZYLUFtei1TaWduZWRIZWFkZXJzPWhvc3QmdmVyc2lvbklkPW51bGwmWC1BbXotU2lnbmF0dXJlPWQ4M2E4MzQ3MjljMWFmODcxNTgwMzhkOTIzZDY1OGNiOTU0MDVhMmU1ZWY5ODVjYjg1N2NiOWM4YTk4NGJkNTE"
        ,
        authorId: "19b41e5a-f550-4ef2-b5e3-60d47688e55e", // Or whatever field you saved
        topicId:
            "5117162b-94af-45ec-a27e-6ab7664a7486", // Fill this appropriately
      );

      final response = await PostService().createPost(postRequest);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post created')),
        );
        setState(() {
          _controller.clear();
          _images.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${response.statusCode}')),
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error posting: $e')),
      );
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();

    // Request permissions depending on Android version
    if (Platform.isAndroid) {
      final sdkInt = (await Permission.mediaLibrary.status).isGranted
          ? 33
          : (await Permission.storage.status).isGranted
              ? 30
              : 0;

      if (sdkInt >= 33) {
        final status = await Permission.photos.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permission to access media denied')),
          );
          return;
        }
      } else {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Permission to access storage denied')),
          );
          return;
        }
      }
    }

    try {
      final picked = await picker.pickMultiImage(imageQuality: 85);

      if (picked.isNotEmpty) {
        setState(() {
          _images.addAll(picked.map((e) => File(e.path)));
        });
      }
    } catch (e) {
      debugPrint('Image pick error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick images: $e')),
      );
    }
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
            onPressed: userId == null ? null : _onPost,
            child: const Text(
              'Post',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(
                      'https://wallup.net/wp-content/uploads/2016/02/18/286966-nature-photography.jpg',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    username ?? "Not found",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: _controller,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          hintText: "What’s on your mind?",
                          border: InputBorder.none,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_images.isNotEmpty)
                        Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _images.map((img) {
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Image.file(
                                    img,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    gaplessPlayback: true,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: _pickImages,
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Add Images"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
