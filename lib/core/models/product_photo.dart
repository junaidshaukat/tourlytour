class ProductPhoto {
  final num id;
  final num productId;
  final num status;
  final String url;
  final String caption;

  ProductPhoto({
    required this.id,
    required this.productId,
    required this.status,
    required this.url,
    required this.caption,
  });

  factory ProductPhoto.fromJson(Map<String, dynamic> json) {
    return ProductPhoto(
      id: json['Id'],
      productId: json['ProductId'],
      status: json['Status'],
      url: json['Url'],
      caption: json['Caption'],
    );
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {
      'Id': id,
      'ProductId': productId,
      'Status': status,
      'Url': url,
      'Caption': caption,
    };

    for (var key in skip) {
      data.remove(key);
    }

    return data;
  }
}
