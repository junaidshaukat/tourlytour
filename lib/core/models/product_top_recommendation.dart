class ProductTopRecommendation {
  final num id;
  final num status;
  final String name;
  final String imageUrl;

  ProductTopRecommendation({
    required this.id,
    required this.status,
    required this.name,
    required this.imageUrl,
  });

  factory ProductTopRecommendation.fromJson(Map<String, dynamic> json) {
    return ProductTopRecommendation(
      id: json['Id'],
      status: json['Status'],
      name: json['Name'],
      imageUrl: json['ImageUrl'],
    );
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {
      'Id': id,
      'Status': status,
      'Name': name,
      'ImageUrl': imageUrl,
    };

    for (var key in skip) {
      data.remove(key);
    }

    return data;
  }
}
