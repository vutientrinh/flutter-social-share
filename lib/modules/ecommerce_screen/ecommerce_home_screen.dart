import 'package:flutter/material.dart';

class EcommerceHomeScreen extends StatefulWidget {
  const EcommerceHomeScreen({super.key});

  @override
  State<EcommerceHomeScreen> createState() => _EcommerceHomeScreenState();
}

class _EcommerceHomeScreenState extends State<EcommerceHomeScreen> {
  final slidersLists = [
    "https://th.bing.com/th/id/OIP.Zu87gW73klh42UG7Q_28yQHaEn?w=294&h=183&c=7&r=0&o=5&pid=1.7",
    "https://th.bing.com/th/id/OIP.90sDWdblfZFiciIEpsGFwwHaEY?w=310&h=183&c=7&r=0&o=5&pid=1.7",
    "https://th.bing.com/th/id/OIP.EifbIt7AOgyTyGIXuuq6TAAAAA?w=234&h=183&c=7&r=0&o=5&pid=1.7",
    "https://th.bing.com/th/id/OIP.oqmBe8wpnsCUUuxUwyv5TAHaE8?w=276&h=184&c=7&r=0&o=5&pid=1.7"
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
