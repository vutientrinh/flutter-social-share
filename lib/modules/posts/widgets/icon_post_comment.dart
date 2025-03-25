import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IconPostComment extends StatelessWidget {
  const IconPostComment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(8),
      child: const Icon(CupertinoIcons.conversation_bubble),
    );
  }
}
