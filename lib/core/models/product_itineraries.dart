class ProductItineraries {
  num? id;
  num? productId;
  String? title;
  String? description;
  num? time;
  num? travelHours;
  String? iconUrl;
  String? imageUrl;
  num? status;

  ProductItineraries({
    this.id,
    this.productId,
    this.title,
    this.description,
    this.time,
    this.travelHours,
    this.iconUrl,
    this.imageUrl,
    this.status,
  });

  factory ProductItineraries.fromJson(Map<String, dynamic> json) {
    return ProductItineraries(
      id: json['Id'] as num?,
      productId: json['ProductId'] as num?,
      title: json['Title'] as String?,
      description: json['Description'] as String?,
      time: json['Time'] as num?,
      travelHours: json['TravelHours'] as num?,
      iconUrl: json['IconUrl'] as String?,
      imageUrl: json['ImageUrl'] as String?,
      status: json['Status'] as num?,
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

    if (!skip.contains('title')) {
      data['Title'] = title;
    }

    if (!skip.contains('description')) {
      data['Description'] = description;
    }

    if (!skip.contains('time')) {
      data['Time'] = time;
    }

    if (!skip.contains('travelHours')) {
      data['TravelHours'] = travelHours;
    }

    if (!skip.contains('iconUrl')) {
      data['IconUrl'] = iconUrl;
    }

    if (!skip.contains('imageUrl')) {
      data['ImageUrl'] = imageUrl;
    }

    if (!skip.contains('status')) {
      data['status'] = status;
    }

    return data;
  }
}
