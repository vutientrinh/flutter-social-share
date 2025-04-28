class ProductReview {
  final String id;
  final String author;
  final String comment;
  final int rating;
  final String createdAt;
  final String updatedAt;

  ProductReview({
    required this.id,
    required this.author,
    required this.comment,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      id: json['id'],
      author: json['author'],
      comment: json['comment'],
      rating: json['rating'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
