import '/core/app_export.dart';

class Tour {
  final Orders orders;
  final Products products;

  Tour({
    required this.orders,
    required this.products,
  });

  factory Tour.fromJson(Map<String, dynamic> json) {
    try {
      return Tour(
        orders: Orders.fromJson(json['orders'] ?? {}),
        products: Products.fromJson(json['products'] ?? {}),
      );
    } catch (e) {
      console.error(e, 'Tour');
      rethrow;
    }
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {};
    if (!skip.contains('orders')) {
      data['orders'] = orders.toJson(skip: skip);
    }

    if (!skip.contains('products')) {
      data['products'] = products.toJson(skip: skip);
    }

    return data;
  }
}

class TourDetails {
  Orders? orders;
  Contacts? contacts;
  Products? products;
  ProductReviews? reviews;
  List<OrderGuests> guests;
  List<ProductInclusion> inclusions;
  List<ProductItineraries> itineraries;
  List<ProductAdditionalInformation> additional;

  TourDetails({
    this.orders,
    this.guests = const [],
    this.reviews,
    this.contacts,
    this.products,
    this.additional = const [],
    this.inclusions = const [],
    this.itineraries = const [],
  });

  factory TourDetails.fromJson(Map<String, dynamic> json) {
    try {
      return TourDetails(
        orders: json['orders'] != null ? Orders.fromJson(json['orders']) : null,
        contacts: json['contacts'] != null
            ? Contacts.fromJson(json['contacts'])
            : null,
        products: json['products'] != null
            ? Products.fromJson(json['products'])
            : null,
        reviews: json['reviews'] != null
            ? ProductReviews.fromJson(json['reviews'])
            : null,
        guests: json["guests"] != null
            ? List<OrderGuests>.from(
                json["guests"].map((x) => OrderGuests.fromJson(x)))
            : [],
        inclusions: json["inclusions"] != null
            ? List<ProductInclusion>.from(
                json["inclusions"].map((x) => ProductInclusion.fromJson(x)))
            : [],
        itineraries: json["itineraries"] != null
            ? List<ProductItineraries>.from(
                json["itineraries"].map((x) => ProductItineraries.fromJson(x)))
            : [],
        additional: json["additional"] != null
            ? List<ProductAdditionalInformation>.from(json["additional"]
                .map((x) => ProductAdditionalInformation.fromJson(x)))
            : [],
      );
    } catch (e) {
      console.error(e, 'TourDetails');
      rethrow;
    }
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {};
    if (!skip.contains('orders')) {
      data['orders'] = orders?.toJson(skip: skip);
    }

    if (!skip.contains('contacts')) {
      data['contacts'] = contacts?.toJson(skip: skip);
    }

    if (!skip.contains('products')) {
      data['products'] = products?.toJson(skip: skip);
    }

    if (!skip.contains('reviews')) {
      data['reviews'] = reviews?.toJson(skip: skip);
    }

    if (!skip.contains('guests')) {
      data['guests'] = guests.map((e) => e.toJson(skip: skip)).toList();
    }

    if (!skip.contains('inclusions')) {
      data['inclusions'] = inclusions.map((e) => e.toJson(skip: skip)).toList();
    }

    if (!skip.contains('itineraries')) {
      data['itineraries'] =
          itineraries.map((e) => e.toJson(skip: skip)).toList();
    }

    if (!skip.contains('additional')) {
      data['additional'] = additional.map((e) => e.toJson(skip: skip)).toList();
    }

    return data;
  }
}
