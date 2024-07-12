import '/core/app_export.dart';

class ReviewsPending {
  final Orders order;
  final Products product;

  ReviewsPending({
    required this.order,
    required this.product,
  });

  factory ReviewsPending.fromJson(Map<String, dynamic> json) {
    try {
      return ReviewsPending(
        order: Orders.fromJson(json['order']),
        product: Products.fromJson(json['product']),
      );
    } catch (e) {
      console.error(e, 'ReviewsPending');
      rethrow;
    }
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {};

    if (!skip.contains('order')) {
      data['order'] = order.toJson(skip: skip);
    }

    if (!skip.contains('product')) {
      data['product'] = product.toJson(skip: skip);
    }

    return data;
  }
}
