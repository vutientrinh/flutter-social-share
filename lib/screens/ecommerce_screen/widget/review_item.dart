import 'package:flutter/material.dart';
import 'package:flutter_social_share/model/ecommerce/product_review.dart';

class ReviewItem extends StatelessWidget {
  final ProductReview productReview;

  const ReviewItem({
    Key? key,
    required this.productReview
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.grey,
        child: Icon(Icons.person),
      ),
      title: Text(productReview.author,style: const TextStyle(fontWeight: FontWeight.bold,),),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(productReview.comment),
          const SizedBox(height: 4),
          Text(
            productReview.updatedAt,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
