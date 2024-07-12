class ProductVideo {
  final num id;
  final num productId;
  final num status;
  final String url;

  ProductVideo({
    required this.id,
    required this.productId,
    required this.status,
    required this.url,
  });

  factory ProductVideo.fromJson(Map<String, dynamic> json) {
    return ProductVideo(
      id: json['Id'],
      productId: json['ProductId'],
      status: json['Status'],
      url: json['Url'],
    );
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {
      'Id': id,
      'ProductId': productId,
      'Status': status,
      'Url': url,
    };

    for (var key in skip) {
      data.remove(key);
    }

    return data;
  }
}
