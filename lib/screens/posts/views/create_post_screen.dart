import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/social/post_update_request.dart';
import 'package:flutter_social_share/model/social/topic.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import 'package:flutter_social_share/providers/state_provider/topic_provider.dart';
import 'package:flutter_social_share/utils/uidata.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../model/social/post.dart';
import '../../../model/social/post_request.dart';
import '../../../providers/async_provider/post_async_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:another_flushbar/flushbar.dart';


class CreatePostScreen extends ConsumerStatefulWidget {
  final String? avatar;
  final Post? post;

  const CreatePostScreen({super.key, this.avatar, this.post});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final TextEditingController _controllerContent = TextEditingController();
  List<File> _newImages = []; // For newly picked images
  List<String> _existingImages = []; // For existing image URLs from post
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
    if (widget.post != null) {
      _controllerContent.text = widget.post!.content;
      _existingImages =
          List.from(widget.post!.images); // Load existing image URLs
      selectedTopicId = widget.post!.topicId; // Preselect topic
      for (String imageUrl in widget.post!.images) {
        final file = await _downloadImageToFile(imageUrl);
        if (file != null) {
          _newImages.add(file);
        }
      }
    }
    setState(() {
      username = data['username'];
      userId = data['userId'];
      topics = listAllTopics;
    });
  }

  int _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
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

    final createPost = ref.read(postAsyncNotifierProvider.notifier);
    final newPost = PostRequest(
      content: _controllerContent.text,
      images: _newImages, // Only new images for upload
      authorId: userId!,
      topicId: selectedTopicId!,
    );
    print(newPost.topicId);

    await createPost.addPost(newPost);

    await Flushbar(
      titleText: const Text(
        'Success',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      messageText: Text(
        'New post is created!',
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

    setState(() {
      _controllerContent.clear();
      _newImages.clear();
      _existingImages.clear();
    });
    Navigator.pop(context);
  }
  Future<File?> _downloadImageToFile(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(LINK_IMAGE.publicImage(imageUrl)));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        // Extract the file name from the URL
        final fileName = imageUrl.split('/').last;
        // Ensure the file name is valid; fallback to timestamp if empty/invalid
        final safeFileName = fileName.isNotEmpty && fileName.contains('.')
            ? fileName
            : '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final file = File('${tempDir.path}/$safeFileName');
        await file.writeAsBytes(response.bodyBytes);
        return file;
      }
    } catch (e) {
      debugPrint('Error downloading image: $e');
    }
    return null;
  }

  Future<void> _updatePost() async {
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
      final updatePost = ref.read(postAsyncNotifierProvider.notifier);
      // Assuming PostRequest can handle existing image URLs separately
      final updatedPost = PostUpdateRequest(
        content: _controllerContent.text,
        images: _newImages, // New images to upload
        topicId: selectedTopicId!,
        status: "PUBLIC",
        type: "TEXT"
      );

      await updatePost.updatePost(widget.post!.id, updatedPost);

      await Flushbar(
        titleText: const Text(
          'Success',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        messageText: Text(
          'Update successfully!!!',
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

      setState(() {
        _controllerContent.clear();
        _newImages.clear();
        _existingImages.clear();
      });

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating post: $e')),
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
          _newImages.addAll(picked.map((e) => File(e.path)));
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
        title: Text(widget.post == null ? 'Create Post' : 'Edit Post'),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          TextButton(
            onPressed: widget.post == null ? _onPost : _updatePost,
            child: Text(
              widget.post == null ? 'Post' : 'Update',
              style: const TextStyle(
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
                  const SizedBox(width: 20),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedTopicId,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Select Topic',
                        border: OutlineInputBorder(),
                      ),
                      items: topics
                          .map((topic) => DropdownMenuItem<String>(

                                value: topic.id,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      margin: const EdgeInsets.only(left: 8),
                                      decoration: BoxDecoration(
                                        color: Color(_hexToColor(topic.color)),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
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
                        controller: _controllerContent,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          hintText: "What’s on your mind?",
                          border: InputBorder.none,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_newImages.isNotEmpty)
                        Column(
                          children: _newImages.asMap().entries.map((entry) {
                            final index = entry.key;
                            final img = entry.value;
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Image.file(
                                    img,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    gaplessPlayback: true,
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _newImages.removeAt(index);
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
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
                    backgroundColor: Colors.blueAccent,
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
