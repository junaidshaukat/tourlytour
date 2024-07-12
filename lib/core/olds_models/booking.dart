import '/core/app_export.dart';

class BookingRequest {
  late num _id;
  late num _productId;
  late num _userId;
  late String _orderNumber;
  late DateTime _date;
  late num _totalNumberOfGuest;
  late String _language;
  late String _preferedDriverGender;
  late String _hotelName;
  late String _hotelAddress;
  late String _hotelRoomNumber;
  late String _contactPersonName;
  late String _contactPersonEmail;
  late String _contactPersonMobile;
  late String _stripeToken;
  late String _stripeReferrenceNumber;
  late String _status;
  late bool _isPaid;
  late num _totalAmount;

  late List<OrderGuests> _guests;
  late Products _product;
  late String _phoneCode;

  void setProducts(Products product, CurrentUserProvider currentUser) {
    _product = product;
    _productId = product.id ?? -1;
    _userId = currentUser.id;
  }

  Products get product => _product;
  String get language => _language;
  String get preferedDriverGender => _preferedDriverGender;
  num get userId => _userId;
  num get productId => _productId;
  String get orderNumber => _orderNumber;
  void setStep00(Products product, CurrentUserProvider currentUser) {
    _language = '';
    _totalAmount = 0;
    _product = product;
    _preferedDriverGender = '';
    _userId = currentUser.id;
    _productId = product.id ?? -1;
    _orderNumber = fn.orderNumber();
  }

  DateTime get date => _date;
  num get totalNumberOfGuest => _totalNumberOfGuest;
  void setStep01({required DateTime date, required int totalNumberOfGuest}) {
    _date = date;
    _totalNumberOfGuest = totalNumberOfGuest;
  }

  String get phoneCode => _phoneCode;
  String get contactPersonName => _contactPersonName;
  String get contactPersonEmail => _contactPersonEmail;
  String get contactPersonMobile => _contactPersonMobile;
  String get contactPersonMobileWithCode => _phoneCode + _contactPersonMobile;
  String get hotelName => _hotelName;
  String get hotelAddress => _hotelAddress;
  String get hotelRoomNumber => _hotelRoomNumber;
  List<OrderGuests> get guests => _guests;
  String get stripeReferrenceNumber => _stripeReferrenceNumber;
  String get stripeToken => _stripeToken;
  num get totalAmount => _totalAmount;
  String get status => _status;
  bool get isPaid => _isPaid;
  void setStep02({
    required bool paid,
    required String status,
    required String fullName,
    required String hotelName,
    required String phoneCode,
    required num totalPayment,
    required String stripeToken,
    required String emailAddress,
    required String mobileNumber,
    required String hotelAddress,
    required String hotelRoomNumber,
    required List<OrderGuests> guests,
    required String stripeReferrenceNumber,
  }) {
    _isPaid = paid;
    _status = status;
    _guests = guests;
    _phoneCode = phoneCode;
    _hotelName = hotelName;
    _stripeToken = stripeToken;
    _totalAmount = totalPayment;
    _hotelAddress = hotelAddress;
    _contactPersonName = fullName;
    _hotelRoomNumber = hotelRoomNumber;
    _contactPersonEmail = emailAddress;
    _contactPersonMobile = mobileNumber;
    _stripeReferrenceNumber = stripeReferrenceNumber;
  }

  num get id => _id;
  void setOrders(Map<String, dynamic> json) {
    if (json.containsKey('Id')) {
      _id = json['Id'];
    }

    if (json.containsKey('orderNumber')) {
      _orderNumber = json['orderNumber'];
    }
  }

  Map<String, dynamic> toJson({List skip = const []}) {
    final Map<String, dynamic> data = {};

    if (!skip.contains('id')) {
      data['Id'] = _id;
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
      data['Date'] = date.toIso8601String();
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

    if (!skip.contains('stripeReferrenceNumber')) {
      data['StripeReferrenceNumber'] = stripeReferrenceNumber;
    }

    if (!skip.contains('guests')) {
      data['guests'] = guests
          .map((guest) => guest.toJson())
          .cast<Map<String, dynamic>>()
          .toList();
    }

    if (!skip.contains('status')) {
      data['Status'] = status;
    }

    if (!skip.contains('isPaid')) {
      data['IsPaid'] = isPaid;
    }

    if (!skip.contains('TotalAmount')) {
      data['TotalAmount'] = totalAmount;
    }

    return data;
  }

  void fromJson(Map<String, dynamic> json) {
    _id = json['Id'];
    _productId = json['ProductId'];
    _userId = json['UserId'];
    _orderNumber = json['OrderNumber'];
    _date = DateTime.parse(json['Date']);
    _totalNumberOfGuest = json['TotalNumberOfGuest'];
    _language = json['Language'];
    _preferedDriverGender = json['PreferedDriverGender'];
    _hotelName = json['HotelName'];
    _hotelAddress = json['HotelAddress'];
    _hotelRoomNumber = json['HotelRoomNumber'];
    _contactPersonName = json['ContactPersonName'];
    _contactPersonEmail = json['ContactPersonEmail'];
    _contactPersonMobile = json['ContactPersonMobile'];
    _stripeToken = json['StripeToken'];
    _stripeReferrenceNumber = json['StripeReferrenceNumber'];
    _status = json['Status'];
    _isPaid = json['IsPaid'];
    _totalAmount = json['TotalAmount'];

    if (json['guests'] != null) {
      _guests = (json['guests'] as List)
          .map((guestJson) => OrderGuests.fromJson(guestJson))
          .toList();
    } else {
      _guests = [];
    }
  }
}
