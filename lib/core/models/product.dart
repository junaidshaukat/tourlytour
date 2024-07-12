class Product {
  final num id;
  final num rating;
  final num hours;
  final num locations;
  final num price;
  final num standardPrice;
  final num type;
  final bool isFeatured;
  final num featureOrder;
  final num activities;
  final String thumbnailUrl;
  final String region;
  final String name;
  final String shortDescription;
  final String longDescription;
  final String stripePriceIdentifier;
  final String code;
  final String city;
  final String tags;
  final String status;
  final String country;

  Product({
    required this.id,
    required this.rating,
    required this.hours,
    required this.locations,
    required this.price,
    required this.standardPrice,
    required this.type,
    required this.isFeatured,
    required this.featureOrder,
    required this.activities,
    required this.thumbnailUrl,
    required this.region,
    required this.name,
    required this.shortDescription,
    required this.longDescription,
    required this.stripePriceIdentifier,
    required this.code,
    required this.city,
    required this.tags,
    required this.status,
    required this.country,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['Id'],
      rating: json['Rating'],
      hours: json['Hours'],
      locations: json['Locations'],
      price: json['Price'],
      standardPrice: json['StandardPrice'],
      type: json['Type'],
      isFeatured: json['IsFeatured'],
      featureOrder: json['FeatureOrder'],
      activities: json['Activities'],
      thumbnailUrl: json['ThumbnailUrl'],
      region: json['Region'],
      name: json['Name'],
      shortDescription: json['ShortDescription'],
      longDescription: json['LongDescription'],
      stripePriceIdentifier: json['StripePriceIdentifier'],
      code: json['Code'],
      city: json['City'],
      tags: json['Tags'],
      status: json['Status'],
      country: json['Country'],
    );
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {
      'Id': id,
      'Rating': rating,
      'Hours': hours,
      'Locations': locations,
      'Price': price,
      'StandardPrice': standardPrice,
      'Type': type,
      'IsFeatured': isFeatured,
      'FeatureOrder': featureOrder,
      'Activities': activities,
      'ThumbnailUrl': thumbnailUrl,
      'Region': region,
      'Name': name,
      'ShortDescription': shortDescription,
      'LongDescription': longDescription,
      'StripePriceIdentifier': stripePriceIdentifier,
      'Code': code,
      'City': city,
      'Tags': tags,
      'Status': status,
      'Country': country,
    };

    for (var key in skip) {
      data.remove(key);
    }

    return data;
  }
}
