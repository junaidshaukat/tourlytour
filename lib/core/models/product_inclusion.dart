class ProductInclusion {
  final num id;
  final num productId;
  final bool isIncluded;
  final String icon;
  final String label;

  ProductInclusion({
    required this.id,
    required this.productId,
    required this.isIncluded,
    required this.icon,
    required this.label,
  });

  factory ProductInclusion.fromJson(Map<String, dynamic> json) {
    return ProductInclusion(
      id: json['Id'],
      productId: json['ProductId'],
      isIncluded: json['IsIncluded'],
      icon: json['Icon'],
      label: json['Label'],
    );
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {
      'Id': id,
      'ProductId': productId,
      'IsIncluded': isIncluded,
      'Icon': icon,
      'Label': label,
    };

    for (var key in skip) {
      data.remove(key);
    }

    return data;
  }
}
