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
                  const SizedBox(height: 10,),
                  const Text("Item name",style: TextStyle(fontSize: 16,color: Colors.grey)),
                  const SizedBox(height: 10,),
                  const Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Seller", style: TextStyle(color: Colors.black),),
                            SizedBox(height: 10,),
                            Text("In House Brands", style: TextStyle(color: Colors.black, fontSize: 16),),

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
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      SizedBox(width: 100,child:
                        Text("Quantity : ",style: TextStyle(),),)
                    ],
                  )

                  
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
