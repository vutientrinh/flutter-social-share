import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/state_provider/product_review_provider.dart';

class CreateCommentScreen extends ConsumerStatefulWidget {
  final String productId;

  const CreateCommentScreen({super.key, required this.productId});

  @override
  ConsumerState<CreateCommentScreen> createState() =>
      _CreateCommentScreenState();
}

class _CreateCommentScreenState extends ConsumerState<CreateCommentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  int _rating = 1;

  void _submitComment() {
    if (_formKey.currentState!.validate()) {

      ref.read(productReviewProvider).comment(
          productId: widget.productId,
          author: _authorController.text.trim(),
          comment: _commentController.text.trim(),
          rating: _rating);

      // You can also clear the fields after submission
      _authorController.clear();
      _commentController.clear();
      setState(() {
        _rating = 1;
      });
      Navigator.pop(context);
    }
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        return IconButton(
          icon: Icon(
            Icons.star,
            color: _rating >= starIndex ? Colors.amber : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _rating = starIndex;
            });
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Comment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(
                  labelText: 'Your Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your name'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Your Comment',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a comment'
                    : null,
              ),
              const SizedBox(height: 16),
              const Text(
                'Rating',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _buildStarRating(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitComment,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
