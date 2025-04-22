class PaymentRequest {
  final String method;
  final double amountPaid;

  PaymentRequest({
    required this.method,
    required this.amountPaid,
  });

  factory PaymentRequest.fromJson(Map<String, dynamic> json) {
    return PaymentRequest(
      method: json['method'],
      amountPaid: json['amountPaid'],
    );
  }
}
