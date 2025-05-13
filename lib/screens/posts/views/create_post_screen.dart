import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/social/topic.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import 'package:flutter_social_share/providers/state_provider/topic_provider.dart';
import 'package:flutter_social_share/screens/home_screen/home_page.dart';
import 'package:flutter_social_share/utils/uidata.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../model/social/post_request.dart';
import '../../../providers/async_provider/post_async_provider.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  final String? avatar;

  const CreatePostScreen({super.key, required this.avatar});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final TextEditingController _controllerContent = TextEditingController();
  final TextEditingController _controllerTopic = TextEditingController();
  final List<File> _images = [];
  String? username;
  String? userId;
  List<Topic> topics = [];
  String? selectedTopicId;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final authService = ref.read(authServiceProvider);
    final data = await authService.getSavedData();
    final listAllTopics = await ref.read(topicServiceProvider).getAllTopics();
    setState(() {
      username = data['username'];
      userId = data['userId'];
      topics = listAllTopics;
    });
  }

  int _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex'; // add alpha if not present
    return int.parse(hex, radix: 16);
  }

  Future<void> _onPost() async {
    if (_controllerContent.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post content missing')),
      );
      return;
    }
    if (selectedTopicId == null || selectedTopicId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a topic')),
      );
      return;
    }

    try {
      final createPost = ref.read(postAsyncNotifierProvider.notifier);

      final newPost = PostRequest(
        content: _controllerContent.text,
        images: _images,
        authorId: userId!,
        topicId: selectedTopicId ?? "",
      );

      await createPost.addPost(newPost);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post created')),
      );

      setState(() {
        _controllerContent.clear();
        _images.clear();
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error posting: $e')),
      );
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();

    if (Platform.isAndroid || Platform.isIOS) {
      final status = await Permission.photos.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission denied to access photos')),
        );
        return;
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
            onPressed: _onPost,
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
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(
                          LINK_IMAGE.publicImage(widget.avatar!),
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
                  const SizedBox(
                    width: 100,
                  ),
                  Expanded(
                    child: DropdownButtonFormField<String>(

                      value: selectedTopicId,
                      isExpanded: true,
                      // Allows better control of width
                      decoration: const InputDecoration(
                        labelText: 'Select Topic',
                        border: OutlineInputBorder(),
                      ),
                      items: topics
                          .map((topic) => DropdownMenuItem<String>(
                                value: topic.id,
                                child: Row(
                                  children: [
                                    // Colored Dot
                                    Container(
                                      width: 10,
                                      height: 10,
                                      margin: const EdgeInsets.only(left: 8),
                                      decoration: BoxDecoration(
                                        color: Color(_hexToColor(topic.color)),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(topic.name),
                                  ],
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedTopicId = value;
                        });
                      },
                    ),
                  )
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
                        controller: _controllerContent,
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
              padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: _pickImages,
                  icon: const Icon(Icons.photo_library, color: Colors.white),
                  label: const Text(
                    "Add Images",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B46C1),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
