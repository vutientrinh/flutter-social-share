import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/async_provider/product_async_provider.dart';
import 'package:flutter_social_share/providers/async_provider/product_liked_async_provider.dart';
import 'package:flutter_social_share/providers/async_provider/review_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import 'package:flutter_social_share/screens/ecommerce_screen/create_comment_screen.dart';
import 'package:flutter_social_share/screens/ecommerce_screen/widget/review_item.dart';
import 'package:flutter_social_share/utils/uidata.dart';
import 'package:intl/intl.dart';
import 'package:another_flushbar/flushbar.dart';
import '../../model/ecommerce/product.dart';
import '../../providers/async_provider/cart_async_provider.dart';
import 'cart_screen.dart';
import 'favorite_product_screen.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  Product? product;

  @override
  void initState() {
    super.initState();
    loadProduct();
    Future.microtask(() {
      ref
          .read(productAsyncNotifierProvider.notifier)
          .getProductById(widget.productId);
      ref
          .read(reviewProductAsyncNotifierProvider.notifier)
          .getReviewProduct(widget.productId);
    });
  }

  Future<void> loadProduct() async {
    final data = await ref
        .read(productAsyncNotifierProvider.notifier)
        .getProductById(widget.productId);
    setState(() {
      product = data;
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FavoriteProductScreen()),
                );
              },
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
      body: product == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 250,
                      child: PageView.builder(
                        itemCount: product!.images.length,
                        controller: PageController(viewportFraction: 1),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Image.network(
                              LINK_IMAGE.publicImage(product!.images[index]),
                              width: double.infinity,
                              fit: BoxFit.fitHeight);
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        product!.category.name,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        product!.name,
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
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  product!.rating.toStringAsFixed(1),
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
                                  "${product!.salesCount} sold",
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
                            "₫${NumberFormat("#,###", "vi_VN").format(product?.price.toInt())}",
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            product!.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: product!.isLiked ? Colors.red : Colors.black,
                            size: 18,
                          ),
                          onPressed: () async {
                            product!.isLiked
                                ? await ref
                                    .read(productLikedAsyncNotifierProvider
                                        .notifier)
                                    .unlike(product!.id)
                                : await ref
                                    .read(productLikedAsyncNotifierProvider
                                        .notifier)
                                    .like(product!.id);

                            loadProduct();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Description:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(product!.description),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Customer Reviews:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // Center align the content
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  // Button background color
                                  borderRadius: BorderRadius.circular(30),
                                  // Rounded corners
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3), // Shadow position
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CreateCommentScreen(
                                                  productId: product!.id)),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(30),
                                  // Apply rounded corners to InkWell as well
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.comment,
                                        color: Colors.white,
                                        // Icon color for contrast
                                        size:
                                            20, // Adjust size for better visual balance
                                      ),
                                      SizedBox(width: 8),
                                      // Spacing between icon and text
                                      Text(
                                        'Review',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors
                                              .white, // Text color for contrast
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    reviewProductState.when(
                      data: (productReviews) {
                        if (productReviews.isEmpty) {
                          return const Center(
                              child: Text('No products found.'));
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          // IMPORTANT: add this to make it work inside Column
                          physics: const NeverScrollableScrollPhysics(),
                          // disable inner scrolling
                          itemCount: productReviews.length,
                          itemBuilder: (context, index) {
                            final productReview = productReviews[index];
                            return ReviewItem(productReview: productReview);
                          },
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, _) => Center(child: Text('Error: $error')),
                    ),
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
                      data['userId'], product!.id, product!.price, 1);

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
                  Navigator.pop(context);
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
              )),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: ElevatedButton.icon(
                onPressed: () async {
                  final data =
                      await ref.read(authServiceProvider).getSavedData();
                  ref.read(cartAsyncNotifierProvider.notifier).addToCart(
                      data['userId'], product!.id, product!.price, 1);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
                icon: const Icon(Icons.shopping_cart_outlined,
                    size: 18, color: Colors.white),
                label: const Text(
                  "Buy now",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
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
