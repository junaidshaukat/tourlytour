class ProductReviewPhotos {
  num? id;
  num? productReviewId;
  String? url;

  ProductReviewPhotos({
    this.id,
    this.productReviewId,
    this.url,
  });

  factory ProductReviewPhotos.fromJson(Map<String, dynamic> json) {
    return ProductReviewPhotos(
      id: json['Id'] as num?,
      productReviewId: json['ProductReviewId'] as num?,
      url: json['Url'] as String?,
    );
  }

  Map<String, dynamic> toJson({List skip = const []}) {
    final Map<String, dynamic> data = {};

    if (!skip.contains('id')) {
      data['id'] = id;
    }

    if (!skip.contains('productReviewId')) {
      data['productReviewId'] = productReviewId;
    }

    if (!skip.contains('url')) {
      data['url'] = url;
    }

    return data;
  }
}
