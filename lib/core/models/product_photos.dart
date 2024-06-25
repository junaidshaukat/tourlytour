class ProductPhotos {
  num? id;
  num? productId;
  String? url;
  String? caption;
  num? status;

  ProductPhotos({
    this.id,
    this.productId,
    this.url,
    this.caption,
    this.status,
  });

  factory ProductPhotos.fromJson(Map<String, dynamic> json) {
    return ProductPhotos(
      id: json['Id'] as num?,
      productId: json['ProductId'] as num?,
      url: json['Url'] as String?,
      caption: json['Caption'] as String?,
      status: json['Status'] as num?,
    );
  }

  Map<String, dynamic> toJson({List skip = const []}) {
    final Map<String, dynamic> data = {};

    if (!skip.contains('id')) {
      data['Id'] = id;
    }

    if (!skip.contains('productId')) {
      data['ProductId'] = productId;
    }

    if (!skip.contains('status')) {
      data['Status'] = status;
    }

    if (!skip.contains('url')) {
      data['Url'] = url;
    }

    if (!skip.contains('caption')) {
      data['Caption'] = caption;
    }

    return data;
  }
}
