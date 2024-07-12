class ProductTopRecommendationItem {
  final num id;
  final num productRecommendationId;
  final num productId;
  final num ordinal;
  final num status;

  ProductTopRecommendationItem({
    required this.id,
    required this.productRecommendationId,
    required this.productId,
    required this.ordinal,
    required this.status,
  });

  factory ProductTopRecommendationItem.fromJson(Map<String, dynamic> json) {
    return ProductTopRecommendationItem(
      id: json['Id'],
      productRecommendationId: json['ProductRecommendationId'],
      productId: json['ProductId'],
      ordinal: json['Ordinal'],
      status: json['Status'],
    );
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {
      'Id': id,
      'ProductRecommendationId': productRecommendationId,
      'ProductId': productId,
      'Ordinal': ordinal,
      'Status': status,
    };

    for (var key in skip) {
      data.remove(key);
    }

    return data;
  }
}
