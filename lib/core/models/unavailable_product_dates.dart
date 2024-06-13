class UnavailableProductDates {
  num id;
  num productId;
  DateTime date;
  String description;

  UnavailableProductDates({
    required this.id,
    required this.productId,
    required this.date,
    required this.description,
  });

  factory UnavailableProductDates.fromJson(Map<String, dynamic> json) {
    return UnavailableProductDates(
      id: json['Id'],
      productId: json['ProductId'],
      date: DateTime.parse(json['Date']),
      description: json['Description'],
    );
  }

  Map<String, dynamic> toJson({List skip = const []}) {
    Map<String, dynamic> data = {};

    if (!skip.contains('id')) {
      data.addAll({'Id': id});
    }

    if (!skip.contains('productId')) {
      data.addAll({'ProductId': productId});
    }

    if (!skip.contains('date')) {
      data.addAll({'Date': date.toIso8601String()});
    }

    if (!skip.contains('description')) {
      data.addAll({'Description': description});
    }

    return data;
  }
}
