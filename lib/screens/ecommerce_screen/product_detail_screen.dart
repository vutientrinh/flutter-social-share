import 'package:flutter/material.dart';

import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productName;
  const ProductDetailScreen({super.key, required this.productName});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Product detail"),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.share,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.favorite_outline,
              )),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CartScreen()),
                );
              },
              icon: const Icon(
                Icons.shopping_bag,
              )),
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
                  itemCount: 6,
                  controller: PageController(viewportFraction: 1),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Image.asset(
                      'assets/images/pi1.jpg',
                      width: double.infinity,
                      fit: BoxFit.fitHeight,
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.productName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Text("Available Colors: ",
                        style: TextStyle(fontSize: 16)),
                    ...List.generate(
                      3,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: [Colors.red, Colors.blue, Colors.green][index],
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber),
                    SizedBox(width: 4),
                    // Small space between icon and rating text
                    Text("4.5",
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              AssetImage('assets/image2/profile_image.png'),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "In House Brands",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.message_rounded, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Description:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                    "This is a high-quality product with amazing features, durable materials, and stylish design."),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Customer Reviews:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                        child: Icon(Icons.person),
                        backgroundColor: Colors.grey),
                    title: Text("John Doe"),
                    subtitle: Text("Great product! Highly recommend."),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                        child: Icon(Icons.person),
                        backgroundColor: Colors.grey),
                    title: Text("Jane Smith"),
                    subtitle: Text("Good quality, fast delivery!"),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                        child: Icon(Icons.person),
                        backgroundColor: Colors.grey),
                    title: Text("John Doe"),
                    subtitle: Text("Great product! Highly recommend."),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                        child: Icon(Icons.person),
                        backgroundColor: Colors.grey),
                    title: Text("Jane Smith"),
                    subtitle: Text("Good quality, fast delivery!"),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                        child: Icon(Icons.person),
                        backgroundColor: Colors.grey),
                    title: Text("John Doe"),
                    subtitle: Text("Great product! Highly recommend."),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                        child: Icon(Icons.person),
                        backgroundColor: Colors.grey),
                    title: Text("Jane Smith"),
                    subtitle: Text("Good quality, fast delivery!"),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                        child: Icon(Icons.person),
                        backgroundColor: Colors.grey),
                    title: Text("John Doe"),
                    subtitle: Text("Great product! Highly recommend."),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                        child: Icon(Icons.person),
                        backgroundColor: Colors.grey),
                    title: Text("Jane Smith"),
                    subtitle: Text("Good quality, fast delivery!"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Add to Cart"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text("Buy Now"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
