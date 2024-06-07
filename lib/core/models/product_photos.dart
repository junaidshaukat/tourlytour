class ProductPhotos {
  num? id;
  num? productId;
  num? status;
  String? url;
  String? caption;

  ProductPhotos({
    this.id,
    this.productId,
    this.status,
    this.url,
    this.caption,
  });

  factory ProductPhotos.fromJson(Map<String, dynamic> json) {
    return ProductPhotos(
      id: json['Id'] as num?,
      productId: json['ProductId'] as num?,
      status: json['Status'] as num?,
      url: json['Url'] as String?,
      caption: json['Caption'] as String?,
    );
  }

  Map<String, dynamic> toJson({List skip = const []}) {
    final Map<String, dynamic> data = {};

    if (!skip.contains('id')) {
      data['id'] = id;
    }

    if (!skip.contains('productId')) {
      data['productId'] = productId;
    }

    if (!skip.contains('status')) {
      data['status'] = status;
    }

    if (!skip.contains('url')) {
      data['url'] = url;
    }

    if (!skip.contains('caption')) {
      data['caption'] = caption;
    }

    return data;
  }
}
