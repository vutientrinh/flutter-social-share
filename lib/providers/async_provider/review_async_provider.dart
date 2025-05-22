import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/ecommerce/product_review.dart';
import 'package:flutter_social_share/providers/state_provider/product_review_provider.dart';

final reviewProductAsyncNotifierProvider =
    AsyncNotifierProvider<ReviewProductNotifier, List<ProductReview>>(
        ReviewProductNotifier.new);

class ReviewProductNotifier extends AsyncNotifier<List<ProductReview>> {
  @override
  Future<List<ProductReview>> build() async {
    return [];
  }

  Future<void> getReviewProduct(String productId) async {
    final reviewProductService = ref.watch(productReviewProvider);
    final productReviews =
        await reviewProductService.getComments(productId: productId);
    state = AsyncData(productReviews);
  }

  Future<void> createComment({
    required String productId,
    required String author,
    required String comment,
    required int rating,
  }) async {
    final reviewProductService = ref.watch(productReviewProvider);
    await reviewProductService.comment(
        productId: productId, author: author, comment: comment, rating: rating);
    await getReviewProduct(productId);
  }
}
