import 'package:flutter/material.dart';
import 'package:flutter_social_share/utils/string_utils.dart';

class TextCountNumber extends StatelessWidget {
  final int number;
  final String subText;

  const TextCountNumber({
    Key? key,
    required this.number,
    required this.subText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(top: 2, right: 8, bottom: 4),
      child: Text(
        "${StringUtils.formatK(number)} $subText",
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
