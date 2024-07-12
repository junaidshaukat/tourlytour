import '/core/app_export.dart';

class Favourites {
  num? id;
  num? productId;
  num? userId;
  String? status;
  Products? products;

  Favourites({
    this.id,
    this.productId,
    this.products,
    this.userId,
    this.status,
  });

  factory Favourites.fromJson(Map<String, dynamic> json) {
    try {
      return Favourites(
        id: json['Id'] as num?,
        productId: json['ProductId'] as num?,
        userId: json['UserId'] as num?,
        status: json['Status'] as String?,
        products:
            json['product'] != null ? Products.fromJson(json['product']) : null,
      );
    } catch (e) {
      console.error(e, 'Favourites');
      rethrow;
    }
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
