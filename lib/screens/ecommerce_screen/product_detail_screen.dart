import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/ecommerce/product_review.dart';
import 'package:flutter_social_share/providers/async_provider/review_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import 'package:flutter_social_share/providers/state_provider/product_provider.dart';
import 'package:flutter_social_share/providers/state_provider/product_review_provider.dart';
import 'package:flutter_social_share/route/screen_export.dart';
import 'package:flutter_social_share/screens/ecommerce_screen/widget/review_item.dart';
import 'package:flutter_social_share/utils/uidata.dart';
import 'package:intl/intl.dart';
import 'package:another_flushbar/flushbar.dart';
import '../../model/ecommerce/product.dart';
import '../../providers/async_provider/cart_async_provider.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  List<ProductReview>? productReviews;

  @override
  void initState() {
    super.initState();
    loadReview();
  }

  Future<void> loadReview() async {
    final data = await ref
        .read(productReviewProvider)
        .getComments(productId: widget.product.id);
    setState(() {
      productReviews = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final reviewProductState = ref.watch(reviewProductAsyncNotifierProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Product detail"),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.favorite_outline,
              )),
          IconButton(
            icon: const Icon(CupertinoIcons.cart, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 250,
                child: PageView.builder(
                  itemCount: widget.product.images.length,
                  controller: PageController(viewportFraction: 1),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Image.network(
                        LINK_IMAGE.publicImage(widget.product.images[index]),
                        width: double.infinity,
                        fit: BoxFit.fitHeight);
                  },
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.product.category.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.product.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            widget.product.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.shopping_cart_outlined,
                              color: Colors.grey, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            "${widget.product.salesCount} sold",
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "₫${NumberFormat("#,###", "vi_VN").format(widget.product.price.toInt())}",
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      widget.product.isLiked
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: widget.product.isLiked ? Colors.red : Colors.black,
                      size: 18,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Description:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(widget.product.description),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Customer Reviews:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              productReviews == null
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: productReviews!
                          .map((review) => ReviewItem(productReview: review))
                          .toList(),
                    )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Expanded(
                  child: ElevatedButton.icon(
                onPressed: () async {
                  final data =
                      await ref.read(authServiceProvider).getSavedData();
                  ref.read(cartAsyncNotifierProvider.notifier).addToCart(
                      data['userId'],
                      widget.product.id,
                      widget.product.price,
                      1);

                  await Flushbar(
                    title: 'Success',
                    message: 'Product added to cart successfully!',
                    backgroundColor: Colors.green,
                    flushbarPosition: FlushbarPosition.TOP,
                    duration: const Duration(seconds: 1),
                    margin: const EdgeInsets.all(8),
                    borderRadius: BorderRadius.circular(8),
                    animationDuration: const Duration(milliseconds: 500),
                  ).show(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EcommerceHomeScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_cart_outlined,
                    size: 18, color: Colors.white),
                label: const Text(
                  "Add to Cart",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
