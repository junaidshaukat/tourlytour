import '/core/app_export.dart';

class Orders {
  num? id;
  num? productId;
  num? userId;
  DateTime? date;
  num? totalNumberOfGuest;
  bool? isPaid;
  DateTime? createdAtDateTime;
  num? totalAmount;
  DateTime? updatedAtDateTime;
  num? isReview;
  String? hotelRoomNumber;
  String? contactPersonName;
  String? contactPersonEmail;
  String? contactPersonMobile;
  String? stripeToken;
  String? orderNumber;
  String? stripeReferrenceNumber;
  String? status;
  String? language;
  String? preferedDriverGender;
  String? hotelName;
  String? hotelAddress;

  Orders({
    this.id,
    this.productId,
    this.userId,
    this.orderNumber,
    this.date,
    this.totalNumberOfGuest,
    this.language,
    this.preferedDriverGender,
    this.hotelName,
    this.hotelAddress,
    this.hotelRoomNumber,
    this.contactPersonName,
    this.contactPersonEmail,
    this.contactPersonMobile,
    this.stripeToken,
    this.stripeReferrenceNumber,
    this.status,
    this.isPaid,
    this.createdAtDateTime,
    this.totalAmount,
    this.updatedAtDateTime,
  });

  factory Orders.fromJson(Map<String, dynamic> json) {
    try {
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
        stripeReferrenceNumber: json['StripeReferrenceNumber'] as String?,
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
    } catch (e) {
      console.error(e, 'Orders');
      rethrow;
    }
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
      data['StripeReferrenceNumber'] = stripeReferrenceNumber;
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

class OrdersDetails {
  Orders? orders;
  Products? product;
  Contacts? contacts;
  List<OrderGuests>? guests;
  List<ProductItineraries>? itineraries;
  List<ProductInclusion>? inclusions;
  List<ProductAdditionalInformation>? additional;

  OrdersDetails({
    this.orders,
    this.product,
    this.contacts,
    this.guests,
    this.itineraries,
    this.inclusions,
    this.additional,
  });

  factory OrdersDetails.fromJson(Map<String, dynamic> json) {
    try {
      return OrdersDetails(
        orders: json["orders"] != null ? Orders.fromJson(json["orders"]) : null,
        contacts: json["contacts"] != null
            ? Contacts.fromJson(json["contacts"])
            : null,
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
        inclusions: json["inclusions"] != null
            ? (json['inclusions'] as List<dynamic>?)
                ?.map((e) => ProductInclusion.fromJson(e))
                .toList()
            : [],
        additional: json["additional"] != null
            ? (json['additional'] as List<dynamic>?)
                ?.map((e) => ProductAdditionalInformation.fromJson(e))
                .toList()
            : [],
      );
    } catch (e) {
      console.error(e, 'OrdersDetails');
      rethrow;
    }
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

    if (!skip.contains('inclusions') && inclusions != null) {
      data['inclusions'] = inclusions!.map((v) => v.toJson()).toList();
    }

    if (!skip.contains('additional') && additional != null) {
      data['additional'] = additional!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
