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
  String? thumbnailUrl;
  num? standardPrice;
  num? price;
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
    this.thumbnailUrl,
    this.price,
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
      rating: json['Rating'],
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

  num get saving {
    if (standardPrice != null && price != null) {
      return standardPrice! - price!;
    }
    return 0;
  }

  Map<String, dynamic> toJson({List skip = const []}) {
    Map<String, dynamic> data = {};

    if (!skip.contains('id')) {
      data['id'] = id;
    }

    if (!skip.contains('name')) {
      data['name'] = name;
    }

    if (!skip.contains('shortDescription')) {
      data['shortDescription'] = shortDescription;
    }

    if (!skip.contains('longDescription')) {
      data['longDescription'] = longDescription;
    }

    if (!skip.contains('rating')) {
      data['rating'] = rating;
    }

    if (!skip.contains('hours')) {
      data['hours'] = hours;
    }

    if (!skip.contains('locations')) {
      data['locations'] = locations;
    }

    if (!skip.contains('tags')) {
      data['tags'] = tags;
    }

    if (!skip.contains('status')) {
      data['status'] = status;
    }

    if (!skip.contains('price')) {
      data['price'] = price;
    }

    if (!skip.contains('thumbnailUrl')) {
      data['thumbnailUrl'] = thumbnailUrl;
    }

    if (!skip.contains('standardPrice')) {
      data['standardPrice'] = standardPrice;
    }

    if (!skip.contains('type')) {
      data['type'] = type;
    }

    if (!skip.contains('code')) {
      data['code'] = code;
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
