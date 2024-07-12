import '/core/app_export.dart';

class Products {
  num? id;
  num? rating;
  num? hours;
  num? locations;
  num? price;
  num? standardPrice;
  num? type;
  bool? isFeatured;
  num? featureOrder;
  num? activities;
  String? thumbnailUrl;
  String? region;
  String? name;
  String? shortDescription;
  String? longDescription;
  String? stripePriceIdentifier;
  String? code;
  String? city;
  String? tags;
  String? status;
  String? country;

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
    try {
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
    } catch (e) {
      console.error(e, 'Products');
      rethrow;
    }
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

class ProductDetails {
  Products product;
  Statistics statistics;
  List<ProductPrice> prices;
  List<ProductVideos> videos;
  List<ProductPhotos> photos;
  List<ProductReviews> reviews;
  List<ProductItineraries> itineraries;

  ProductDetails({
    required this.product,
    required this.videos,
    required this.prices,
    required this.photos,
    required this.reviews,
    required this.statistics,
    required this.itineraries,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    try {
      return ProductDetails(
        product: Products.fromJson(json['product']),
        statistics: Statistics.fromJson(json['statistics']),
        prices: (json['prices'] as List)
            .map((e) => ProductPrice.fromJson(e))
            .toList(),
        videos: (json['videos'] as List)
            .map((e) => ProductVideos.fromJson(e))
            .toList(),
        photos: (json['photos'] as List)
            .map((e) => ProductPhotos.fromJson(e))
            .toList(),
        itineraries: (json['itineraries'] as List)
            .map((e) => ProductItineraries.fromJson(e))
            .toList(),
        reviews: (json['reviews'] as List)
            .map((e) => ProductReviews.fromJson(e))
            .toList(),
      );
    } catch (e) {
      console.error(e, 'ProductDetails');
      rethrow;
    }
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {};

    if (!skip.contains('product')) {
      data['product'] = product.toJson(skip: skip);
    }

    if (!skip.contains('statistics')) {
      data['statistics'] = statistics.toJson(skip: skip);
    }

    if (!skip.contains('prices')) {
      data['videos'] = prices.map((e) => e.toJson(skip: skip)).toList();
    }

    if (!skip.contains('videos')) {
      data['videos'] = videos.map((e) => e.toJson(skip: skip)).toList();
    }

    if (!skip.contains('photos')) {
      data['photos'] = photos.map((e) => e.toJson(skip: skip)).toList();
    }

    if (!skip.contains('itineraries')) {
      data['itineraries'] =
          itineraries.map((e) => e.toJson(skip: skip)).toList();
    }

    if (!skip.contains('reviews')) {
      data['reviews'] = reviews.map((e) => e.toJson(skip: skip)).toList();
    }

    return data;
  }
}
