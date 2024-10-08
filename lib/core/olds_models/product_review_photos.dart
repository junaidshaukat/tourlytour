import 'package:tourlytour/core/utils/console.dart';

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
    try {
      return ProductReviewPhotos(
        id: json['Id'] as num?,
        productReviewId: json['ProductReviewId'] as num?,
        url: json['Url'] as String?,
      );
    } catch (e) {
      console.error(e, 'ProductReviewPhotos');
      rethrow;
    }
  }

  Map<String, dynamic> toJson({List skip = const []}) {
    final Map<String, dynamic> data = {};

    if (!skip.contains('id')) {
      data['Id'] = id;
    }

    if (!skip.contains('productReviewId')) {
      data['ProductReviewId'] = productReviewId;
    }

    if (!skip.contains('url')) {
      data['Url'] = url;
    }

    return data;
  }
}
