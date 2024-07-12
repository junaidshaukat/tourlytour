class ProductPrice {
  final num id;
  final num productId;
  final num quantity;
  final num price;
  final String stripePriceKey;

  ProductPrice({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.stripePriceKey,
  });

  factory ProductPrice.fromJson(Map<String, dynamic> json) {
    return ProductPrice(
      id: json['Id'],
      productId: json['ProductId'],
      quantity: json['Quantity'],
      price: json['Price'],
      stripePriceKey: json['StripePriceKey'],
    );
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {
      'Id': id,
      'ProductId': productId,
      'Quantity': quantity,
      'Price': price,
      'StripePriceKey': stripePriceKey,
    };

    for (var key in skip) {
      data.remove(key);
    }

    return data;
  }
}
