class ProductAdditionalInformation {
  final num id;
  final num productId;
  final String icon;
  final String label;
  final String mobileIcon;

  ProductAdditionalInformation({
    required this.id,
    required this.productId,
    required this.icon,
    required this.label,
    required this.mobileIcon,
  });

  factory ProductAdditionalInformation.fromJson(Map<String, dynamic> json) {
    return ProductAdditionalInformation(
      id: json['Id'],
      productId: json['ProductId'],
      icon: json['Icon'],
      label: json['Label'],
      mobileIcon: json['MobileIcon'],
    );
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {
      'Id': id,
      'ProductId': productId,
      'Icon': icon,
      'Label': label,
      'MobileIcon': mobileIcon,
    };

    for (var key in skip) {
      data.remove(key);
    }

    return data;
  }
}
