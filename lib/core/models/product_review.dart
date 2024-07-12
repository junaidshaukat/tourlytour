class ProductReview {
  final num valueForMoney;
  final num productId;
  final num userId;
  final num rate;
  final num id;
  final DateTime dateTime;
  final num status;
  final num hospitality;
  final num impressiveness;
  final num seamlessExperience;
  final String description;

  ProductReview({
    required this.valueForMoney,
    required this.productId,
    required this.userId,
    required this.rate,
    required this.id,
    required this.dateTime,
    required this.status,
    required this.hospitality,
    required this.impressiveness,
    required this.seamlessExperience,
    required this.description,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      valueForMoney: json['ValueForMoney'],
      productId: json['ProductId'],
      userId: json['UserId'],
      rate: json['Rate'],
      id: json['Id'],
      dateTime: DateTime.parse(json['DateTime']),
      status: json['Status'],
      hospitality: json['Hospitality'],
      impressiveness: json['Impressiveness'],
      seamlessExperience: json['SeamlessExperience'],
      description: json['Description'],
    );
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {
      'ValueForMoney': valueForMoney,
      'ProductId': productId,
      'UserId': userId,
      'Rate': rate,
      'Id': id,
      'DateTime': dateTime.toIso8601String(),
      'Status': status,
      'Hospitality': hospitality,
      'Impressiveness': impressiveness,
      'SeamlessExperience': seamlessExperience,
      'Description': description,
    };

    for (var key in skip) {
      data.remove(key);
    }

    return data;
  }
}
