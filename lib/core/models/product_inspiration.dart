class ProductInspiration {
  final num id;
  final num status;
  final String name;
  final String description;
  final String imageUrl;

  ProductInspiration({
    required this.id,
    required this.status,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory ProductInspiration.fromJson(Map<String, dynamic> json) {
    return ProductInspiration(
      id: json['Id'],
      status: json['Status'],
      name: json['Name'],
      description: json['Description'],
      imageUrl: json['ImageUrl'],
    );
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {
      'Id': id,
      'Status': status,
      'Name': name,
      'Description': description,
      'ImageUrl': imageUrl,
    };

    for (var key in skip) {
      data.remove(key);
    }

    return data;
  }
}
