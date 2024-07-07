class ProductAdditionalInformation {
  int id;
  String icon;
  String label;
  int productId;

  ProductAdditionalInformation({
    required this.id,
    required this.icon,
    required this.label,
    required this.productId,
  });

  factory ProductAdditionalInformation.fromJson(Map<String, dynamic> json) {
    return ProductAdditionalInformation(
      id: json['Id'],
      icon: json['Icon'],
      label: json['Label'],
      productId: json['ProductId'],
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

    return data;
  }
}
