import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_share/common/widgets/stateful/react_button/reactive_button.dart';
import 'package:flutter_social_share/common/widgets/stateful/react_button/reactive_icon_definition.dart';
import 'package:flutter_social_share/utils/uidata.dart';

import '../../../model/comment.dart';

class CommentItemBubble extends StatefulWidget {
  final Comment cmt;
  final Function(int, bool) onReact;

  const CommentItemBubble({
    Key? key,
    required this.cmt,
    required this.onReact,
  }) : super(key: key);

  @override
  State<CommentItemBubble> createState() => _CommentItemBubbleState();
}

class _CommentItemBubbleState extends State<CommentItemBubble> {
  late final Comment cmt;
  int? yourReact = 0;
  double sizeAvatar = 32;

  @override
  void initState() {
    super.initState();

    cmt = widget.cmt;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: sizeAvatar,
            height: sizeAvatar,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(sizeAvatar / 2),
              child: CachedNetworkImage(
                imageUrl: "https://th.bing.com/th/id/OIP.YoTUWMoKovQT0gCYOYMwzwHaHa?rs=1&pid=ImgDetMain",
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cmt.author!.username,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      cmt.content!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.grey[600]),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  buildReactButton(),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    'Reply',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildReactButton() {
    late final Text textWidget;
    switch (yourReact) {
      case 1:
        textWidget = Text(
          'Like',
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
        );
        break;
      case 2:
        textWidget = Text(
          'Haha',
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
              ),
        );
        break;
      case 3:
        textWidget = Text(
          'Heart',
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Colors.pink,
                fontWeight: FontWeight.bold,
              ),
        );
        break;
      case 4:
        textWidget = Text(
          'Sad',
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
        );
        break;
      case 5:
        textWidget = Text(
          'Wow',
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
              ),
        );
        break;
      case 6:
        textWidget = Text(
          'Angry',
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
        );
        break;
      default:
        textWidget = Text(
          'Like',
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        );
    }
    return ReactiveButton(
      icons: <ReactiveIconDefinition>[
        ReactiveIconDefinition(
          assetIcon: UIData.likeGif,
          code: '1',
        ),
        ReactiveIconDefinition(
          assetIcon: UIData.hahaGif,
          code: '2',
        ),
        ReactiveIconDefinition(
          assetIcon: UIData.loveGif,
          code: '3',
        ),
        ReactiveIconDefinition(
          assetIcon: UIData.sadGif,
          code: '4',
        ),
        ReactiveIconDefinition(
          assetIcon: UIData.wowGif,
          code: '5',
        ),
        ReactiveIconDefinition(
          assetIcon: UIData.angryGif,
          code: '6',
        ),
      ], //_flags,
      onTap: () {},
      onSelected: (ReactiveIconDefinition? value) {
        yourReact = int.parse(value!.code);
        setState(() {});
      },
      iconWidth: 35.0,
      iconGrowRatio: 1.1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.transparent),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.blueGrey,
            blurRadius: 1.3,
          ),
        ],
      ),
      containerPadding: 4,
      iconPadding: 5,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        child: textWidget,
      ),
    );
  }
}
