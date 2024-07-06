import '/core/app_export.dart';

class TourHistory {
  final Orders orders;
  final Products products;
  final Contacts contacts;
  final List<OrderGuests> guests;
  final ProductReviews reviews;
  final List<ProductItineraries> itineraries;

  TourHistory({
    required this.orders,
    required this.guests,
    required this.reviews,
    required this.contacts,
    required this.products,
    required this.itineraries,
  });

  factory TourHistory.fromJson(Map<String, dynamic> json) {
    return TourHistory(
      orders: Orders.fromJson(json['orders'] ?? {}),
      guests: (json['guests'] as List<dynamic>?)
              ?.map((e) => OrderGuests.fromJson(e))
              .toList() ??
          [],
      products: Products.fromJson(json['products'] ?? {}),
      contacts: Contacts.fromJson(json['contacts'] ?? {}),
      reviews: ProductReviews.fromJson(json['reviews'] ?? {}),
      itineraries: (json['itineraries'] as List<dynamic>?)
              ?.map((e) => ProductItineraries.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {};
    if (!skip.contains('orders')) {
      data['orders'] = orders.toJson(skip: skip);
    }

    if (!skip.contains('products')) {
      data['products'] = products.toJson(skip: skip);
    }

    if (!skip.contains('contacts')) {
      data['contacts'] = contacts.toJson(skip: skip);
    }

    if (!skip.contains('guests')) {
      data['guests'] = guests.map((e) => e.toJson(skip: skip)).toList();
    }

    if (!skip.contains('reviews')) {
      data['reviews'] = reviews.toJson(skip: skip);
    }

    if (!skip.contains('itineraries')) {
      data['itineraries'] =
          itineraries.map((e) => e.toJson(skip: skip)).toList();
    }

    return data;
  }
}

class Tours {
  num? id;
  num? productId;
  num? userId;
  String? orderNumber;
  DateTime? date;
  num? totalNumberOfGuest;
  String? language;
  String? preferredDriverGender;
  String? hotelName;
  String? hotelAddress;
  String? hotelRoomNumber;
  String? contactPersonName;
  String? contactPersonEmail;
  String? contactPersonMobile;
  String? stripeToken;
  String? stripeReferenceNumber;
  String? status;
  bool? isPaid;
  DateTime? createdAtDateTime;
  num? totalAmount;
  DateTime? updatedAtDateTime;

  Tours({
    this.id,
    this.productId,
    this.userId,
    this.orderNumber,
    this.date,
    this.totalNumberOfGuest,
    this.language,
    this.preferredDriverGender,
    this.hotelName,
    this.hotelAddress,
    this.hotelRoomNumber,
    this.contactPersonName,
    this.contactPersonEmail,
    this.contactPersonMobile,
    this.stripeToken,
    this.stripeReferenceNumber,
    this.status,
    this.isPaid,
    this.createdAtDateTime,
    this.totalAmount,
    this.updatedAtDateTime,
  });

  factory Tours.fromJson(Map<String, dynamic> json) {
    return Tours(
      id: json['Id'] as num?,
      productId: json['ProductId'] as num?,
      userId: json['UserId'] as num?,
      orderNumber: json['OrderNumber'] as String?,
      date: json['Date'] != null ? DateTime.parse(json['Date']) : null,
      totalNumberOfGuest: json['TotalNumberOfGuest'] as num?,
      language: json['Language'] as String?,
      preferredDriverGender: json['PreferredDriverGender'] as String?,
      hotelName: json['HotelName'] as String?,
      hotelAddress: json['HotelAddress'] as String?,
      hotelRoomNumber: json['HotelRoomNumber'] as String?,
      contactPersonName: json['ContactPersonName'] as String?,
      contactPersonEmail: json['ContactPersonEmail'] as String?,
      contactPersonMobile: json['ContactPersonMobile'] as String?,
      stripeToken: json['StripeToken'] as String?,
      stripeReferenceNumber: json['StripeReferenceNumber'] as String?,
      status: json['Status'] as String?,
      isPaid: json['IsPaid'] as bool?,
      createdAtDateTime: json['CreatedAtDateTime'] != null
          ? DateTime.parse(json['CreatedAtDateTime'])
          : null,
      totalAmount: json['TotalAmount'] as num?,
      updatedAtDateTime: json['UpdatedAtDateTime'] != null
          ? DateTime.parse(json['UpdatedAtDateTime'])
          : null,
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

    if (!skip.contains('userId')) {
      data['UserId'] = userId;
    }

    if (!skip.contains('orderNumber')) {
      data['OrderNumber'] = orderNumber;
    }

    if (!skip.contains('date')) {
      data['Date'] = date?.toIso8601String();
    }

    if (!skip.contains('totalNumberOfGuest')) {
      data['TotalNumberOfGuest'] = totalNumberOfGuest;
    }

    if (!skip.contains('language')) {
      data['Language'] = language;
    }

    if (!skip.contains('preferredDriverGender')) {
      data['PreferredDriverGender'] = preferredDriverGender;
    }

    if (!skip.contains('hotelName')) {
      data['HotelName'] = hotelName;
    }

    if (!skip.contains('hotelAddress')) {
      data['HotelAddress'] = hotelAddress;
    }

    if (!skip.contains('hotelRoomNumber')) {
      data['HotelRoomNumber'] = hotelRoomNumber;
    }

    if (!skip.contains('contactPersonName')) {
      data['ContactPersonName'] = contactPersonName;
    }

    if (!skip.contains('contactPersonEmail')) {
      data['ContactPersonEmail'] = contactPersonEmail;
    }

    if (!skip.contains('contactPersonMobile')) {
      data['ContactPersonMobile'] = contactPersonMobile;
    }

    if (!skip.contains('stripeToken')) {
      data['StripeToken'] = stripeToken;
    }

    if (!skip.contains('stripeReferenceNumber')) {
      data['StripeReferenceNumber'] = stripeReferenceNumber;
    }

    if (!skip.contains('status')) {
      data['Status'] = status;
    }

    if (!skip.contains('isPaid')) {
      data['IsPaid'] = isPaid;
    }

    if (!skip.contains('createdAtDateTime')) {
      data['CreatedAtDateTime'] = createdAtDateTime?.toIso8601String();
    }

    if (!skip.contains('totalAmount')) {
      data['TotalAmount'] = totalAmount;
    }

    if (!skip.contains('updatedAtDateTime')) {
      data['UpdatedAtDateTime'] = updatedAtDateTime?.toIso8601String();
    }

    return data;
  }
}

class ToursDetails {
  Tours? orders;
  Products? product;
  Contacts? contacts;
  List<OrderGuests>? guests;
  List<ProductItineraries>? itineraries;

  ToursDetails({
    this.orders,
    this.product,
    this.contacts,
    this.guests,
    this.itineraries,
  });

  factory ToursDetails.fromJson(Map<String, dynamic> json) {
    return ToursDetails(
      orders: json["orders"] != null ? Tours.fromJson(json["orders"]) : null,
      contacts:
          json["contacts"] != null ? Contacts.fromJson(json["contacts"]) : null,
      product:
          json["product"] != null ? Products.fromJson(json["product"]) : null,
      guests: json["guests"] != null
          ? List<OrderGuests>.from(
              json["guests"].map((x) => OrderGuests.fromJson(x)))
          : null,
      itineraries: json["itineraries"] != null
          ? List<ProductItineraries>.from(
              json["itineraries"].map((x) => ProductItineraries.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {};

    if (!skip.contains('orders') && orders != null) {
      data['orders'] = orders!.toJson();
    }

    if (!skip.contains('contacts') && orders != null) {
      data['contacts'] = contacts!.toJson();
    }

    if (!skip.contains('product') && product != null) {
      data['product'] = product!.toJson();
    }

    if (!skip.contains('guests') && guests != null) {
      data['guests'] = guests!.map((v) => v.toJson()).toList();
    }

    if (!skip.contains('itineraries') && itineraries != null) {
      data['itineraries'] = itineraries!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
