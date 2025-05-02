import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/ecommerce/category.dart';
import 'package:flutter_social_share/providers/async_provider/category_async_provider.dart';
import 'package:flutter_social_share/screens/ecommerce_screen/favorite_product_screen.dart';
import 'package:flutter_social_share/screens/ecommerce_screen/tracking_order_screen.dart';

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
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  List<Category> categories = [];
  String? search;
  String? selectedCategory = "All";
  String? minPrice;
  String? maxPrice;
  num? rating;
  String? inStock;
  String? field;
  String? direction;

  void _onCategoryChanged(String? newCategory) {
    if (newCategory == null) return;
    setState(() {
      selectedCategory = newCategory;
    });

    print(selectedCategory);
    ref.read(productAsyncNotifierProvider.notifier).getProducts(
          category: selectedCategory == "All" ? null : selectedCategory,
        );
  }

  void _fetchProducts() {
    ref.read(productAsyncNotifierProvider.notifier).getProducts(
          search: search,
          category: selectedCategory == 'All' ? null : selectedCategory,
          minPrice: minPrice?.isEmpty ?? true ? null : minPrice,
          maxPrice: maxPrice?.isEmpty ?? true ? null : maxPrice,
          rating: rating,
          inStock: inStock,
          field: field,
          direction: direction,
        );
  }

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _autoSlide();

    // 👇 Fetch default products when screen opens (without any filter)
    Future.microtask(() {
      ref.read(productAsyncNotifierProvider.notifier).getProducts();
    });

    // 👇 Fetch categories when screen opens
    Future.microtask(() {
      ref.read(categoryAsyncNotifierProvider.notifier);
    });
  }

  void _autoSlide() {
    if (!mounted) return;
    setState(() {
      _currentIndex = (_currentIndex + 1) % slidersLists.length;
    });
    Future.delayed(const Duration(seconds: 3), _autoSlide);
  }

  void clearFilters() {
    setState(() {
      selectedCategory = 'All';
      minPrice = '';
      maxPrice = '';
      rating = null;
      search = '';
      minPriceController.clear();
      maxPriceController.clear();
      searchController.clear();
    });
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productAsyncNotifierProvider);
    final categoryState = ref.watch(categoryAsyncNotifierProvider);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: SizedBox(
            height: 40,
            child: TextField(
              controller: searchController, // ✅ Set controller
              onChanged: (value) {
                // ✅ Trigger search
                setState(() {
                  search = value;
                });
                _fetchProducts();
              },
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
              icon: const Icon(Icons.receipt_long, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TrackingShippingScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(CupertinoIcons.suit_heart, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FavoriteProductScreen()),
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
                            margin: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 4),
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
                      categoryState.when(
                        data: (categories) {
                          final allCategories = [
                            Category(
                                id: 'all',
                                name: 'All',
                                description: 'All Categories',
                                createdAt: "nothing",
                                updatedAt: "Nothing"),
                            ...categories,
                          ];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  IntrinsicWidth(
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      child: DropdownButtonFormField<String>(
                                        value: selectedCategory,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 4),
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                        items: allCategories.map((category) {
                                          return DropdownMenuItem<String>(
                                            value: category.name,
                                            child: Text(
                                              category.name,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: _onCategoryChanged,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton.icon(
                                      onPressed: clearFilters,
                                      icon: const Icon(Icons.clear),
                                      label: const Text("Clear Filters"),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              // Min Price
                              Row(
                                children: [
                                  _buildSmallInput(
                                    hintText: 'Min Price',
                                    controller: minPriceController,
                                    onChanged: (value) {
                                      setState(() {
                                        minPrice = value;
                                      });
                                      _fetchProducts();
                                    },
                                  ),
                                  _buildSmallInput(
                                    hintText: 'Max Price',
                                    controller: maxPriceController,
                                    onChanged: (value) {
                                      setState(() {
                                        maxPrice = value;
                                      });
                                      _fetchProducts();
                                    },
                                  ),
                                ],
                              ),
                              // Rating Stars
                              _buildRatingStars(),
                            ],
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, _) =>
                            Center(child: Text('Error: $error')),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      productState.when(
                        data: (products) {
                          if (products.isEmpty) {
                            return const Center(
                                child: Text('No products found.'));
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

  Widget _buildSmallInput({
    required String hintText,
    required Function(String) onChanged,
    required TextEditingController controller,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          keyboardType: TextInputType.number,
          onChanged: onChanged,
        ),
      ),
    );
  }

// Rating Stars Widget
  Widget _buildRatingStars() {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Row(
        children: List.generate(5, (index) {
          final starIndex = index + 1;
          return IconButton(
            icon: Icon(
              starIndex <= (rating ?? 0) ? Icons.star : Icons.star_border,
              color: Colors.amber,
              size: 24,
            ),
            onPressed: () {
              setState(() {
                rating = starIndex;
              });
              _fetchProducts();
            },
          );
        }),
      ),
    );
  }
}
