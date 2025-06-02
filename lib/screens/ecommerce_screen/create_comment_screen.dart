import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/ecommerce/product.dart';
import '../../providers/async_provider/product_async_provider.dart';
import '../../providers/async_provider/review_async_provider.dart';

class CreateCommentScreen extends ConsumerStatefulWidget {
  final Product product;

  const CreateCommentScreen({super.key, required this.product});

  @override
  ConsumerState<CreateCommentScreen> createState() =>
      _CreateCommentScreenState();
}

class _CreateCommentScreenState extends ConsumerState<CreateCommentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  int _rating = 1;

  void _submitComment() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(reviewProductAsyncNotifierProvider.notifier).createComment(
            productId: widget.product.id,
            author: _authorController.text.trim(),
            comment: _commentController.text.trim(),
            rating: _rating,
          );
      await ref
          .read(productAsyncNotifierProvider.notifier)
          .updateProductRating(widget.product, _rating);
      _authorController.clear();
      _commentController.clear();
      setState(() {
        _rating = 1;
      });
      Navigator.pop(context, true);
    }
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        return GestureDetector(
          onTap: () {
            setState(() {
              _rating = starIndex;
            });
          },
          child: Icon(
            Icons.star,
            color: _rating >= starIndex ? Colors.orange : Colors.grey,
            size: 30,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Comment'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name input
                TextFormField(
                  controller: _authorController,
                  decoration: InputDecoration(
                    labelText: 'Your Name',
                    labelStyle: const TextStyle(color: Colors.blueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.blueAccent),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your name'
                      : null,
                ),
                const SizedBox(height: 20),

                // Comment input
                TextFormField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    labelText: 'Your Comment',
                    labelStyle: const TextStyle(color: Colors.blueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.blueAccent),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                  ),
                  maxLines: 4,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a comment'
                      : null,
                ),
                const SizedBox(height: 20),

                // Rating Section
                const Text(
                  'Rating',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                _buildStarRating(),
                const SizedBox(height: 24),

                // Submit Button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: _submitComment,
                    child: const Text(
                      'Submit Comment',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
