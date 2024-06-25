class ProductVideos {
  num? id;
  num? productId;
  String? url;
  num? status;

  ProductVideos({
    this.id,
    this.productId,
    this.url,
    this.status,
  });

  factory ProductVideos.fromJson(Map<String, dynamic> json) {
    return ProductVideos(
      id: json['Id'] as num?,
      productId: json['ProductId'] as num?,
      url: json['Url'] as String?,
      status: json['Status'] as num?,
    );
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {};

    if (!skip.contains('id')) {
      data['Id'] = id;
    }

    if (!skip.contains('productId')) {
      data['ProductId'] = productId;
    }

    if (!skip.contains('url')) {
      data['Url'] = url;
    }

    if (!skip.contains('status')) {
      data['Status'] = status;
    }

    return data;
  }
}
