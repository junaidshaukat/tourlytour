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
  String? city;
  String? country;
  String? tags;
  String? code;

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
    this.city,
    this.country,
    this.tags,
    this.code,
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
      city: json['City'] as String?,
      country: json['Country'] as String?,
      tags: json['Tags'] as String?,
      code: json['Code'] as String?,
    );
  }

  Map<String, dynamic> toJson({List skip = const []}) {
    final Map<String, dynamic> data = {};

    if (!skip.contains('Id')) {
      data['Id'] = id;
    }

    if (!skip.contains('ProductId')) {
      data['ProductId'] = productId;
    }

    if (!skip.contains('Title')) {
      data['Title'] = title;
    }

    if (!skip.contains('Description')) {
      data['Description'] = description;
    }

    if (!skip.contains('Time')) {
      data['Time'] = time;
    }

    if (!skip.contains('TravelHours')) {
      data['TravelHours'] = travelHours;
    }

    if (!skip.contains('IconUrl')) {
      data['IconUrl'] = iconUrl;
    }

    if (!skip.contains('ImageUrl')) {
      data['ImageUrl'] = imageUrl;
    }

    if (!skip.contains('Status')) {
      data['Status'] = status;
    }

    if (!skip.contains('City')) {
      data['City'] = city;
    }

    if (!skip.contains('Country')) {
      data['Country'] = country;
    }

    if (!skip.contains('Tags')) {
      data['Tags'] = tags;
    }

    if (!skip.contains('Code')) {
      data['Code'] = code;
    }

    return data;
  }
}
