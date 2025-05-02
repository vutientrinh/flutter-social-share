import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/social/post.dart';
import 'package:flutter_social_share/providers/async_provider/post_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/post_provider.dart';

class SavedPostsScreen extends ConsumerStatefulWidget {
  const SavedPostsScreen({super.key});


  @override
  ConsumerState<SavedPostsScreen> createState() => _SavedPostsScreenState();
}

class _SavedPostsScreenState extends ConsumerState<SavedPostsScreen> {
  List<Post>? listPosts;
  @override
  void initState(){
    super.initState();
    loadData();
  }
  void loadData() async{
    final response = await ref.read(postServiceProvider).getSavedPosts();
    setState(() {
      listPosts = response;
    });
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
