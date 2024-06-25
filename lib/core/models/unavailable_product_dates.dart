class UnavailableProductDates {
  num? id;
  num? productId;
  DateTime? date;
  String? description;

  UnavailableProductDates({
    this.id,
    this.productId,
    this.date,
    this.description,
  });

  factory UnavailableProductDates.fromJson(Map<String, dynamic> json) {
    return UnavailableProductDates(
      id: json['Id'] as num?,
      productId: json['ProductId'] as num?,
      date: json['Date'] != null ? DateTime.parse(json['Date']) : null,
      description: json['Description'] as String?,
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

    if (!skip.contains('date')) {
      data['Date'] = date?.toIso8601String();
    }

    if (!skip.contains('description')) {
      data['Description'] = description;
    }

    return data;
  }
}
