import '/core/app_export.dart';

class Favourites {
  num? id;
  num? productId;
  Products? products;
  num? userId;
  String? status;

  Favourites({
    this.id,
    this.productId,
    this.products,
    this.userId,
    this.status,
  });

  factory Favourites.fromJson(Map<String, dynamic> json) {
    return Favourites(
      id: json['Id'] as num?,
      productId: json['ProductId'] as num?,
      userId: json['UserId'] as num?,
      status: json['Status'] as String?,
      products:
          json['Products'] != null ? Products.fromJson(json['Products']) : null,
    );
  }

  Map<String, dynamic> toJson({List skip = const []}) {
    final Map<String, dynamic> data = {};

    if (!skip.contains('id')) {
      data['Id'] = id;
    }

    if (!skip.contains('productId')) {
      data['ProductId'] = productId;
    }

    if (!skip.contains('userId')) {
      data['UserId'] = userId;
    }

    if (!skip.contains('status')) {
      data['Status'] = status;
    }

    return data;
  }
}
