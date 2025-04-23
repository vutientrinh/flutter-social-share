import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/screens/ecommerce_screen/product_detail_screen.dart';
import 'package:flutter_social_share/utils/uidata.dart';

import '../../model/ecommerce/product.dart';
import '../../providers/state_provider/product_provider.dart';

class GridProductList extends ConsumerStatefulWidget {
  const GridProductList({super.key});

  @override
  ConsumerState<GridProductList> createState() => _GridProductListState();
}

class _GridProductListState extends ConsumerState<GridProductList> {
  List<Product>? products;

  @override
  void initState() {
    super.initState();
    loadProduct();
  }

  Future<void> loadProduct() async {
    final productsResponse =
    await ref.read(productServiceProvider).getAllProduct();
    print(productsResponse);
    setState(() {
      products = productsResponse;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (products == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: products?.length ?? 0,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        mainAxisExtent: 250,
      ),
      itemBuilder: (context, index) {
        final product = products![index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                  productName: product.name,
                ),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  LINK_IMAGE.publicImage(product.images[0]),
                  width: 150,
                  height: 120,
                  fit: BoxFit.fitHeight,
                ),
                const SizedBox(height: 10),
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "${product.price.toStringAsFixed(0)} ₫",
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
