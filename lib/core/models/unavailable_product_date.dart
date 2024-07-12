class UnavailableProductDate {
  final num id;
  final num productId;
  final DateTime date;
  final String description;

  UnavailableProductDate({
    required this.id,
    required this.productId,
    required this.date,
    required this.description,
  });

  factory UnavailableProductDate.fromJson(Map<String, dynamic> json) {
    return UnavailableProductDate(
      id: json['Id'],
      productId: json['ProductId'],
      date: DateTime.parse(json['Date']),
      description: json['Description'],
    );
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {
      'Id': id,
      'ProductId': productId,
      'Date': date.toIso8601String(),
      'Description': description,
    };

    for (var key in skip) {
      data.remove(key);
    }

    return data;
  }
}
