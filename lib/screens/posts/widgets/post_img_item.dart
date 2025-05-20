import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PostImgItem extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final VoidCallback onTap;

  const PostImgItem({
    Key? key,
    required this.url,
    required this.width,
    required this.height,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: GestureDetector(
        onTap: onTap,
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.fitHeight,
          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}