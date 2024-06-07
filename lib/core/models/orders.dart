import '/core/app_export.dart';

class Orders {
  num? id;
  num? productId;
  num? userId;
  String? orderNumber;
  DateTime? date;
  num? totalNumberOfGuest;
  String? language;
  String? preferedDriverGender;
  String? hotelName;
  String? hotelAddress;
  String? hotelRoomNumber;
  String? contactPersonName;
  String? contactPersonEmail;
  String? contactPersonMobile;
  String? stripeToken;
  String? stripeReferenceNumber;
  num? status;
  bool? isPaid;

  Orders({
    this.id,
    this.productId,
    this.userId,
    this.orderNumber,
    this.date,
    this.totalNumberOfGuest,
    this.language = '',
    this.preferedDriverGender = '',
    this.hotelName,
    this.hotelAddress,
    this.hotelRoomNumber,
    this.contactPersonName,
    this.contactPersonEmail,
    this.contactPersonMobile,
    this.stripeToken = '',
    this.stripeReferenceNumber = '',
    this.status = 0,
    this.isPaid = false,
  });

  factory Orders.fromJson(Map<String, dynamic> json) {
    return Orders(
      id: json['Id'] as num?,
      productId: json['ProductId'] as num?,
      userId: json['UserId'] as num?,
      orderNumber: json['OrderNumber'] as String?,
      date: json['Date'] != null ? DateTime.parse(json['Date']) : null,
      totalNumberOfGuest: json['TotalNumberOfGuest'] as num?,
      language: json['Language'] as String?,
      preferedDriverGender: json['PreferedDriverGender'] as String?,
      hotelName: json['HotelName'] as String?,
      hotelAddress: json['HotelAddress'] as String?,
      hotelRoomNumber: json['HotelRoomNumber'] as String?,
      contactPersonName: json['ContactPersonName'] as String?,
      contactPersonEmail: json['ContactPersonEmail'] as String?,
      contactPersonMobile: json['ContactPersonMobile'] as String?,
      stripeToken: json['StripeToken'] as String?,
      stripeReferenceNumber: json['StripeReferenceNumber'] as String?,
      status: json['Status'] as num?,
      isPaid: json['IsPaid'] as bool?,
    );
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    Map<String, dynamic> data = {};

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

    if (!skip.contains('preferedDriverGender')) {
      data['PreferedDriverGender'] = preferedDriverGender;
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

    return data;
  }
}

class OrdersDetails {
  Orders? orders;
  Products? product;
  Contacts? contacts;
  List<Guests>? guests;
  List<ProductItineraries>? itineraries;

  OrdersDetails({
    this.orders,
    this.product,
    this.contacts,
    this.guests,
    this.itineraries,
  });

  factory OrdersDetails.fromJson(Map<String, dynamic> json) {
    return OrdersDetails(
      orders: json["orders"] != null ? Orders.fromJson(json["orders"]) : null,
      contacts:
          json["contacts"] != null ? Contacts.fromJson(json["contacts"]) : null,
      product:
          json["product"] != null ? Products.fromJson(json["product"]) : null,
      guests: json["guests"] != null
          ? List<Guests>.from(json["guests"].map((x) => Guests.fromJson(x)))
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
