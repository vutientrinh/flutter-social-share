import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

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
              ))
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
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
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Item name",
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Seller",
                              style: TextStyle(color: Colors.black),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage('assets/image2/profile_image.png'),
                            ),
                            Text(
                              "In House Brands",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            Icon(Icons.star, color: Colors.amber),
                            Text("4.5", style: TextStyle(fontSize: 16, color: Colors.black)),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.message_rounded,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          "Quantity : ",
                          style: TextStyle(),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          child: const Text("Add to Cart"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange),
                          child: const Text("Buy Now"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
