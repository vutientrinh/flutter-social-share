import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_share/screens/posts/models/photo.dart';
import 'package:flutter_social_share/screens/posts/widgets/post_img_item.dart';
import 'package:flutter_social_share/utils/uidata.dart';

class GridImage extends StatelessWidget {
  final List<String> photos;
  final double padding;

  const GridImage({
    Key? key,
    required this.photos,
    this.padding = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - padding;
    return buildImageGrid(photos, width, context);
  }

  Widget buildImageGrid(
      List<String> photos, double width, BuildContext context) {
    switch (photos.length) {
      case 0:
        return const SizedBox();
      case 1:
        return _buildOneImage(photos[0], width, context);
      case 2:
        return _buildTwoImage(photos, width, context);
      case 3:
        return _buildThreeImage(photos, width, context);
      case 4:
        return const SizedBox();
      case 5:
        return const SizedBox();
      default:
        return _buildOneImage(photos[0], width, context);
    }
  }

  Widget _buildOneImage(String photo, double width, BuildContext context) {
    final image = photo;

    return GestureDetector(
      onTap: () => navigateToPhotoPage([], 0, context),
      child: SizedBox(
        height: 300,
        width: width,
        child: CachedNetworkImage(
          imageUrl: image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTwoImage(
      List<String> photos, double width, BuildContext context) {
    final height = width;
    width = width - padding;
    return Row(
      children: <Widget>[
        PostImgItem(
          url:  LINK_IMAGE.publicImage(photos[0]),
          width: width / 2,
          height: height,
          onTap: () => navigateToPhotoPage(photos, 0, context),
        ),
        _buildPadding(),
        PostImgItem(
          url: photos[1],
          width: width / 2,
          height: height,
          onTap: () => navigateToPhotoPage(photos, 0, context),
        ),
      ],
    );
  }

  Padding _buildPadding() => Padding(
        padding: EdgeInsets.only(left: padding, top: padding),
      );

  Widget _buildThreeImage(
      List<String> photos, double width, BuildContext context) {
    final firstImg = photos;

    // first vertical style images
    // if (firstImg!.orgHeight! > firstImg.orgWidth!) {
    //   final height = width;
    //   final itemHeight = height;
    //   final itemWidth = width - padding;
    //   return SizedBox(
    //     height: height,
    //     child: Row(
    //       crossAxisAlignment: CrossAxisAlignment.stretch,
    //       children: <Widget>[
    //         PostImgItem(
    //           url: photos[0].url,
    //           width: itemWidth / 2,
    //           height: itemHeight,
    //           onTap: () => navigateToPhotoPage(photos, 0, context),
    //         ),
    //         _buildPadding(),
    //         Column(
    //           children: <Widget>[
    //             PostImgItem(
    //               url: photos[1].url,
    //               width: itemWidth / 2,
    //               height: (itemHeight - padding) / 2,
    //               onTap: () => navigateToPhotoPage(photos, 1, context),
    //             ),
    //             _buildPadding(),
    //             PostImgItem(
    //               url: photos[2].url,
    //               width: itemWidth / 2,
    //               height: (itemHeight - padding) / 2,
    //               onTap: () => navigateToPhotoPage(photos, 2, context),
    //             ),
    //           ],
    //         )
    //       ],
    //     ),
    //   );
    // }

    final height = width;
    final itemWidth = (width - padding) / 2;
    final itemHeight = (height - padding) / 2;
    return SizedBox(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              PostImgItem(
                url: LINK_IMAGE.publicImage(photos[1]),
                width: itemWidth,
                height: itemHeight,
                onTap: () => navigateToPhotoPage(photos, 1, context),
              ),
              _buildPadding(),
              PostImgItem(
                url: LINK_IMAGE.publicImage(photos[2]),
                width: itemWidth,
                height: itemHeight,
                onTap: () => navigateToPhotoPage(photos, 2, context),
              ),
            ],
          ),
          _buildPadding(),
          PostImgItem(
            url: LINK_IMAGE.publicImage(photos[0]),
            width: width,
            height: itemHeight,
            onTap: () => navigateToPhotoPage(photos, 0, context),
          ),
        ],
      ),
    );
  }

  void navigateToPhotoPage(
      List<String> photos, int index, BuildContext context) {}
}
