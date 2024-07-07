class ProductInclusion {
  int id;
  String icon;
  String label;
  int productId;
  bool isIncluded;

  ProductInclusion({
    required this.id,
    required this.icon,
    required this.label,
    required this.productId,
    required this.isIncluded,
  });

  factory ProductInclusion.fromJson(Map<String, dynamic> json) {
    return ProductInclusion(
      id: json['Id'],
      icon: json['Icon'],
      label: json['Label'],
      productId: json['ProductId'],
      isIncluded: json['IsIncluded'],
    );
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {};

    if (!skip.contains('id')) {
      data['Id'] = id;
    }

    if (!skip.contains('icon')) {
      data['Icon'] = icon;
    }

    if (!skip.contains('label')) {
      data['Label'] = label;
    }

    if (!skip.contains('productId')) {
      data['ProductId'] = productId;
    }

    if (!skip.contains('IsIncluded')) {
      data['IsIncluded'] = isIncluded;
    }

    return data;
  }
}
