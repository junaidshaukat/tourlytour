import 'package:tourlytour/core/utils/console.dart';

class ProductPrice {
  num? id;
  num? productId;
  num? quantity;
  num? price;
  String? stripePriceKey;

  ProductPrice({
    this.id,
    this.productId,
    this.quantity,
    this.price,
    this.stripePriceKey,
  });

  factory ProductPrice.fromJson(Map<String, dynamic> json) {
    try {
      return ProductPrice(
        id: json['Id'] as num?,
        productId: json['ProductId'] as num?,
        quantity: json['Quantity'] as num?,
        price: json['Price'] as num?,
        stripePriceKey: json['StripePriceKey'] as String?,
      );
    } catch (e) {
      console.error(e, 'ProductPrice');
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

    if (!skip.contains('quantity')) {
      data['Quantity'] = quantity;
    }

    if (!skip.contains('price')) {
      data['Price'] = price;
    }

    if (!skip.contains('stripePriceKey')) {
      data['StripePriceKey'] = stripePriceKey;
    }

    return data;
  }
}
