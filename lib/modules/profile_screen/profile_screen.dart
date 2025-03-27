import 'package:flutter/material.dart';

import '../posts/blocs/list_posts_rxdart_bloc.dart';
import '../posts/models/post.dart';
import '../posts/widgets/post_item_remake.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _postsBloc = ListPostsRxDartBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Ink.image(
                    image: const NetworkImage(
                        'https://wallup.net/wp-content/uploads/2016/02/18/286966-nature-photography.jpg'),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const Positioned(
                    // bottom: 25,
                    child: CircleAvatar(
                        radius: 50,
                        foregroundImage: NetworkImage(
                            "https://th.bing.com/th/id/OIP.G-H-NFz2OoXJ2GkK74dX4wHaH_?rs=1&pid=ImgDetMain")),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 220),
                    // Moves the column down
                    child: Column(
                      children: [
                        Text(
                          'Vu Tien Trinh',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '@vutientrinh',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Bio:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                  'Passionate about coding, design, and technology.'),
                              SizedBox(height: 10),
                              Text('Followers: 1.2K   Following: 200'),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  )
                ],
              ),
            ),
            StreamBuilder<List<Post>?>(
              stream: _postsBloc.postsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                return Column(
                  children: snapshot.data
                          ?.map((post) => PostItem(post: post))
                          .toList() ??
                      [],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _postsBloc.getPosts();
  }
}
