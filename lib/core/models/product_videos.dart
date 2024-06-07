class ProductVideos {
  num? id;
  num? productId;
  num? status;
  String? url;

  ProductVideos({
    this.id,
    this.productId,
    this.status,
    this.url,
  });

  factory ProductVideos.fromJson(Map<String, dynamic> json) {
    return ProductVideos(
      id: json['Id'] as num?,
      productId: json['ProductId'] as num?,
      status: json['Status'] as num?,
      url: json['Url'] as String?,
    );
  }

  Map<String, dynamic> toJson({List skip = const []}) {
    Map<String, dynamic> data = {};

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

    return data;
  }
}
