import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/async_provider/product_liked_async_provider.dart';
import '../../providers/async_provider/product_async_provider.dart';
import 'cart_screen.dart';
import 'widget/grid_product_list.dart';

class FavoriteProductScreen extends ConsumerStatefulWidget {
  const FavoriteProductScreen({super.key});

  @override
  ConsumerState<FavoriteProductScreen> createState() =>
      _FavoriteProductScreenState();
}

class _FavoriteProductScreenState extends ConsumerState<FavoriteProductScreen> {
  String? search;
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(productLikedAsyncNotifierProvider.notifier);
    });
  }

  @override
  Widget build(BuildContext context) {
    final productLikedState = ref.watch(productLikedAsyncNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Favorite product"),
        actions: [
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
      body: SafeArea(
        child: productLikedState.when(
          data: (products) {
            if (products.isEmpty) {
              return const Center(child: Text('No products found.'));
            }
            return Padding(
              padding: const EdgeInsets.all(12),
              child: GridProductList(
                products: products,
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}
