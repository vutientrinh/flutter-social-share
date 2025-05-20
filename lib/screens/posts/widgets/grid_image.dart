import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
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
    return buildImageSlider(photos, width, context);
  }

  Widget buildImageSlider(List<String> photos, double width, BuildContext context) {
    if (photos.isEmpty) {
      return const SizedBox();
    }

    return _buildSlider(photos, width, context);
  }

  Widget _buildSlider(List<String> photos, double width, BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300, // Fixed height for consistency
          child: Swiper(
            itemCount: photos.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => navigateToPhotoPage(photos, index, context),
                child: PostImgItem(
                  url: LINK_IMAGE.publicImage(photos[index]),
                  width: width,
                  height: 300,
                  onTap: () => navigateToPhotoPage(photos, index, context),
                ),
              );
            },
            loop: photos.length > 1, // Enable loop for multiple images
            autoplay: false, // Disable auto-play for manual control
            pagination: photos.length > 1
                ? SwiperPagination(
              margin: EdgeInsets.only(top: padding),
              builder: DotSwiperPaginationBuilder(
                activeColor: Theme.of(context).primaryColor,
                color: Colors.grey.withOpacity(0.4),
                size: 8.0,
                activeSize: 8.0,
                space: 4.0,
              ),
            )
                : null, // No pagination for single image
          ),
        ),
      ],
    );
  }

  void navigateToPhotoPage(List<String> photos, int index, BuildContext context) {
    // Implement navigation logic here
  }
}