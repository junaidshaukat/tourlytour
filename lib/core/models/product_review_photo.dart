class ProductReviewPhoto {
  final num id;
  final num productReviewId;
  final String url;

  ProductReviewPhoto({
    required this.id,
    required this.productReviewId,
    required this.url,
  });

  factory ProductReviewPhoto.fromJson(Map<String, dynamic> json) {
    return ProductReviewPhoto(
      id: json['Id'],
      productReviewId: json['ProductReviewId'],
      url: json['Url'],
    );
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {
      'Id': id,
      'ProductReviewId': productReviewId,
      'Url': url,
    };

    for (var key in skip) {
      data.remove(key);
    }

    return data;
  }
}
