class ProductCommentResponse {
  final String id;
  final String author;
  final String comment;
  final int rating;
  final String createdAt;
  final String updatedAt;

  ProductCommentResponse({
    required this.id,
    required this.author,
    required this.comment,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductCommentResponse.fromJson(Map<String, dynamic> json) {
    return ProductCommentResponse(
      id: json['id'],
      author: json['author'],
      comment: json['comment'],
      rating: json['rating'],
      createdAt: json['createdAt'],
      updatedAt:json['updatedAt'],
    );
  }
}
