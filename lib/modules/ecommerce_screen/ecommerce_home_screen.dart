import 'package:flutter/material.dart';

class EcommerceHomeScreen extends StatefulWidget {
  const EcommerceHomeScreen({super.key});

  @override
  State<EcommerceHomeScreen> createState() => _EcommerceHomeScreenState();
}

class _EcommerceHomeScreenState extends State<EcommerceHomeScreen> {
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
    // Auto slide logic
    Future.delayed(const Duration(seconds: 3), _autoSlide);
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
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              alignment: Alignment.center,
              height: 60,
              color: Colors.white,
              child: TextFormField(
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Search ...",
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
            ),

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
                      controller: PageController(initialPage: _currentIndex),
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemCount: slidersLists.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
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
                  GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 6,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              mainAxisExtent: 300),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            // RoundedSM equivalent
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                // Soft shadow
                                blurRadius: 5,
                                spreadRadius: 1,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/p1.jpeg',
                                // Correct path to the image
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Laptop 4GB/64GB",
                                style: TextStyle(color: Colors.black26),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "\$600",
                                style: TextStyle(color: Colors.black26),
                              ),
                            ],
                          ),
                        );
                      }),
                ],
              ),
            )),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
