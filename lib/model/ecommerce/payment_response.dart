class PaymentResponse {
  final String createAt;
  final String updatedAt;
  final String id;
  final String method;
  final String status;
  final String transactionId;
  final double amountPaid;

  PaymentResponse({
    required this.createAt,
    required this.updatedAt,
    required this.id,
    required this.method,
    required this.status,
    required this.transactionId,
    required this.amountPaid,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      createAt: json['createAt'] ?? '',
      updatedAt: json['updateAt'] ?? '',
      id: json['id'] ?? '',
      method: json['method'] ?? '',
      status: json['status'] ?? '',
      transactionId: json['transactionId'] ?? '',
      amountPaid: (json['amountPaid'] ?? 0).toDouble(),
    );
  }
}