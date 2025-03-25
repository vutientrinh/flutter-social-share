import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PostImgItem extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final int flex;
  final VoidCallback onTap;

  const PostImgItem({
    Key? key,
    required this.url,
    required this.width,
    required this.height,
    this.flex = 1,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: onTap,
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
