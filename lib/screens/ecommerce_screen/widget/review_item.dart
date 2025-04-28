import 'package:flutter/material.dart';
import 'package:flutter_social_share/model/ecommerce/product_review.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReviewItem extends StatelessWidget {
  final ProductReview productReview;

  const ReviewItem({Key? key, required this.productReview}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 12,
        height: 12,
        decoration: const BoxDecoration(
          color: Colors.black, // Dot color
          shape: BoxShape.circle,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            productReview.author,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16
            ),
          ),
          const SizedBox(width: 8),
          Text(
            timeago.format(DateTime.parse(productReview.updatedAt)),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(productReview.comment),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(5, (index) {
              return Icon(
                Icons.star,
                color: productReview.rating > index
                    ? Colors.amber
                    : Colors.grey,
                size: 10,
              );
            }),
          ),
        ],
      ),
    );
  }
}
