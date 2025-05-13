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

  final ScrollController _scrollController = ScrollController();

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

    _fetchProducts();
  }

  void _fetchProducts() {
    ref.read(productAsyncNotifierProvider.notifier).getNextProductPage(
          search: search,
          category: selectedCategory == 'All' ? null : selectedCategory,
          minPrice: minPrice?.isEmpty ?? true ? null : minPrice,
          maxPrice: maxPrice?.isEmpty ?? true ? null : maxPrice,
          rating: rating,
          inStock: inStock,
          field: field,
          direction: direction,
          reset: true,
        );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      ref.read(productAsyncNotifierProvider.notifier).getNextProductPage(
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
  }

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _autoSlide();

    // 👇 Fetch default products when screen opens (without any filter)
    Future.microtask(() {
      ref.invalidate(productAsyncNotifierProvider);
    });

    // 👇 Fetch categories when screen opens
    Future.microtask(() {
      ref.read(categoryAsyncNotifierProvider.notifier);
    });
    _scrollController.addListener(_onScroll);
  }

  void _autoSlide() {
    if (!mounted) return;
    setState(() {
      _currentIndex = (_currentIndex + 1) % slidersLists.length;
    });
    Future.delayed(const Duration(seconds: 3), _autoSlide);
  }

  void clearFilters() async {
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
              onChanged: (value) async {
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
                  controller: _scrollController,
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
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: DropdownButtonFormField<String>(
                                        value: selectedCategory,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 10,
                                          ),
                                          filled: true,
                                          fillColor: Colors.transparent,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                          ),
                                          prefixIcon: const Icon(
                                            Icons.category_outlined,
                                            color: Colors.grey,
                                            size: 20,
                                          ),
                                        ),
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        dropdownColor: Colors.white,
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.grey,
                                        ),
                                        items: allCategories.map((category) {
                                          return DropdownMenuItem<String>(
                                            value: category.name,
                                            child: Text(
                                              category.name,
                                              style: const TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: _onCategoryChanged,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  TextButton.icon(
                                    onPressed: clearFilters,
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.redAccent,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      backgroundColor: Colors.white,
                                      elevation: 1,
                                      shadowColor: Colors.grey.withOpacity(0.2),
                                    ),
                                    icon: const Icon(Icons.clear, size: 18),
                                    label: const Text(
                                      'Clear',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Price Range
                              Row(
                                children: [
                                  _buildSmallInput(
                                    hintText: 'Min Price',
                                    controller: minPriceController,
                                    icon: Icons.attach_money,
                                    onChanged: (value) {
                                      setState(() {
                                        minPrice = value;
                                      });
                                      _fetchProducts();
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  _buildSmallInput(
                                    hintText: 'Max Price',
                                    controller: maxPriceController,
                                    icon: Icons.attach_money,
                                    onChanged: (value) {
                                      setState(() {
                                        maxPrice = value;
                                      });
                                      _fetchProducts();
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Rating Stars
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    _buildRatingStars(),
                                  ],
                                ),
                              ),
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
    IconData? icon,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            prefixIcon: icon != null
                ? Icon(
                    icon,
                    color: Colors.grey,
                    size: 20,
                  )
                : null,
          ),
          keyboardType: TextInputType.number,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }

// Rating Stars Widget
  Widget _buildRatingStars() {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      child: Row(
        children: List.generate(5, (index) {
          final starIndex = index + 1;
          return IconButton(
            icon: Icon(
              starIndex <= (rating ?? 0) ? Icons.star : Icons.star_border,
              color: Colors.amber,
              size: 20,
            ),
            onPressed: () async {
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
