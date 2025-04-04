import 'package:flutter/material.dart';
import 'package:flutter_social_share/services/auth_service.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _controller = TextEditingController();
  String? username;
  void _onPost() {
    final content = _controller.text.trim();
    if (content.isNotEmpty) {
      // Send post logic here
      print('Posting: $content');
      Navigator.pop(context);
    }
  }
  void loadData() async {
    final data = await AuthService.getSavedData();
    setState(() {
      username = data['username'];
    });
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
            const Divider(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _MediaButton(icon: Icons.photo, label: 'Photo', color: Colors.green),
                _MediaButton(icon: Icons.videocam, label: 'Video', color: Colors.red),
                _MediaButton(icon: Icons.location_on, label: 'Check in', color: Colors.pink),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _MediaButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MediaButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        // TODO: Handle media action
      },
      icon: Icon(icon, color: color),
      label: Text(label, style: TextStyle(color: color)),
    );
  }
}
