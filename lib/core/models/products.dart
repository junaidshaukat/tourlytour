class Products {
  num? id;
  String? name;
  String? shortDescription;
  String? longDescription;
  num? rating;
  num? hours;
  num? locations;
  String? tags;
  String? status;
  num? price;
  String? thumbnailUrl;
  num? standardPrice;
  num? type;
  String? code;
  String? city;
  String? country;
  String? region;
  String? stripePriceIdentifier;

  Products({
    this.id,
    this.name,
    this.shortDescription,
    this.longDescription,
    this.rating,
    this.hours,
    this.locations,
    this.tags,
    this.status,
    this.price,
    this.thumbnailUrl,
    this.standardPrice,
    this.type,
    this.code,
    this.city,
    this.country,
    this.region,
    this.stripePriceIdentifier,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['Id'] as num?,
      name: json['Name'] as String?,
      shortDescription: json['ShortDescription'] as String?,
      longDescription: json['LongDescription'] as String?,
      rating: json['Rating'] as num?,
      hours: json['Hours'] as num?,
      locations: json['Locations'] as num?,
      tags: json['Tags'] as String?,
      status: json['Status'] as String?,
      price: json['Price'] as num?,
      thumbnailUrl: json['ThumbnailUrl'] as String?,
      standardPrice: json['StandardPrice'] as num?,
      type: json['Type'] as num?,
      code: json['Code'] as String?,
      city: json['City'] as String?,
      country: json['Country'] as String?,
      region: json['Region'] as String?,
      stripePriceIdentifier: json['StripePriceIdentifier'] as String?,
    );
  }

  num get saving => (standardPrice ?? 0) - (price ?? 0);

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {};

    if (!skip.contains('id')) {
      data['Id'] = id;
    }

    if (!skip.contains('name')) {
      data['Name'] = name;
    }

    if (!skip.contains('shortDescription')) {
      data['ShortDescription'] = shortDescription;
    }

    if (!skip.contains('longDescription')) {
      data['LongDescription'] = longDescription;
    }

    if (!skip.contains('rating')) {
      data['Rating'] = rating;
    }

    if (!skip.contains('hours')) {
      data['Hours'] = hours;
    }

    if (!skip.contains('locations')) {
      data['Locations'] = locations;
    }

    if (!skip.contains('tags')) {
      data['Tags'] = tags;
    }

    if (!skip.contains('status')) {
      data['Status'] = status;
    }

    if (!skip.contains('price')) {
      data['Price'] = price;
    }

    if (!skip.contains('thumbnailUrl')) {
      data['ThumbnailUrl'] = thumbnailUrl;
    }

    if (!skip.contains('standardPrice')) {
      data['StandardPrice'] = standardPrice;
    }

    if (!skip.contains('type')) {
      data['Type'] = type;
    }

    if (!skip.contains('code')) {
      data['Code'] = code;
    }

    if (!skip.contains('city')) {
      data['City'] = city;
    }

    if (!skip.contains('country')) {
      data['Country'] = country;
    }

    if (!skip.contains('region')) {
      data['Region'] = region;
    }

    if (!skip.contains('stripePriceIdentifier')) {
      data['StripePriceIdentifier'] = stripePriceIdentifier;
    }

    return data;
  }
}
