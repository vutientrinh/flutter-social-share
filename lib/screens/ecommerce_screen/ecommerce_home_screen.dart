import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/ecommerce/product.dart';
import 'package:flutter_social_share/providers/state_provider/product_provider.dart';
import 'package:flutter_social_share/screens/ecommerce_screen/favorite_product_screen.dart';

import '../../providers/async_provider/product_async_provider.dart';
import 'cart_screen.dart';
import 'widget/grid_product_list.dart';

class EcommerceHomeScreen extends ConsumerStatefulWidget {
  const EcommerceHomeScreen({super.key});

  @override
  ConsumerState<EcommerceHomeScreen> createState() =>
      _EcommerceHomeScreenState();
}

class _EcommerceHomeScreenState extends ConsumerState<EcommerceHomeScreen> {
  final slidersLists = [
    "assets/images/slider_1.png",
    "assets/images/slider_2.png",
    "assets/images/slider_3.png",
    "assets/images/slider_4.png"
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), _autoSlide);
    Future.microtask(() {
      ref.read(productAsyncNotifierProvider.notifier);
    });
  }

  void _autoSlide() {
    if (!mounted) return;
    setState(() {
      _currentIndex = (_currentIndex + 1) % slidersLists.length;
    });
    Future.delayed(const Duration(seconds: 3), _autoSlide);
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productAsyncNotifierProvider);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: SizedBox(
            height: 40,
            child: TextField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                hintText: "Search...",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(CupertinoIcons.suit_heart, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FavoriteProductScreen()),
                );
              },
            ),
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
        body: Container(
          padding: const EdgeInsets.all(12),
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            child: Column(
              children: [
                // Search Bar
                const SizedBox(height: 10),
                // Image Slider
                Expanded(
                    child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 150,
                        child: PageView.builder(
                          controller:
                              PageController(initialPage: _currentIndex),
                          onPageChanged: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          itemCount: slidersLists.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  slidersLists[index],
                                  fit: BoxFit.fill,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Dots Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          slidersLists.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == index
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      productState.when(
                        data: (products) {
                          if (products.isEmpty) {
                            return const Center(child: Text('No products found.'));
                          }
                          return GridProductList(products: products);
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, _) =>
                            Center(child: Text('Error: $error')),
                      )
                    ],
                  ),
                )),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ));
  }
}
