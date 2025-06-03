import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/async_provider/product_async_provider.dart';
import 'package:flutter_social_share/screens/ecommerce_screen/product_detail_screen.dart';
import 'package:flutter_social_share/utils/uidata.dart';
import 'package:intl/intl.dart';

import '../../../model/ecommerce/product.dart';

class GridProductList extends ConsumerStatefulWidget {
  final List<Product> products;

  const GridProductList({super.key, required this.products});

  @override
  ConsumerState<GridProductList> createState() => _GridProductListState();
}

class _GridProductListState extends ConsumerState<GridProductList> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(productAsyncNotifierProvider.notifier);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        mainAxisExtent: 270,
      ),
      itemBuilder: (context, index) {
        final product = widget.products[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProductDetailScreen(product: product),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: LINK_IMAGE.publicImage(product.images[0]),
                  width: 150,
                  height: 120,
                  fit: BoxFit.fitHeight,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.category.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                    product.stockQuantity > 1
                        ? const Row(
                            children: [
                              Icon(Icons.check_circle,
                                  color: Colors.green, size: 16),
                              SizedBox(width: 4),
                              Text(
                                "In Stock",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 10),
                              ),
                            ],
                          )
                        : const Row(
                            children: [
                              Icon(Icons.remove_circle,
                                  color: Colors.red, size: 16),
                              SizedBox(width: 4),
                              Text(
                                "Out Stock",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 10),
                              ),
                            ],
                          )
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "₫${NumberFormat("#,###", "vi_VN").format(product.price.toInt())}",
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toDouble().toStringAsFixed(1),
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
                          "${product.salesCount.toString()} sold",
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
