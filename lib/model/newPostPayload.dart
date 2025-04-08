class createPostRequest {
  final String content;
  final String images;
  final String? authorId;
  final String? topicId;

  createPostRequest({
    required this.content,
    required this.images,
    required this.authorId,
    required this.topicId,

  });

  factory createPostRequest.fromJson(Map<String, dynamic> json) {
    return createPostRequest(
      content: json['content'],
      images: json['images'],
      authorId: json['authorId'],
      topicId: json['topicId']
    );
  }
}
