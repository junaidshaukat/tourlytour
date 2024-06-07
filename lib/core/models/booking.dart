import '/core/app_export.dart';

class BookingRequest {
  late num _id;
  late num _productId;
  late num _userId;
  late String _orderNumber;
  late DateTime _date;
  late int _totalNumberOfGuest;
  late String _phoneCode;
  late String _contactPersonName;
  late String _contactPersonEmail;
  late String _contactPersonMobile;
  late String _language;
  late String _preferedDriverGender;
  late String _hotelName;
  late String _hotelAddress;
  late String _hotelRoomNumber;
  late String _stripeToken;
  late String _stripeReferenceNumber;
  late int _status;
  late bool _isPaid;
  late List<Guests> _guests;
  late Products _product;

  void setProducts(Products product, CurrentUserProvider currentUser) {
    _product = product;
    _productId = product.id ?? -1;
    _userId = currentUser.id ?? -1;
  }

  Products get product => _product;
  num get status => _status;
  String get language => _language;
  bool get isPaid => _isPaid;
  String get stripeToken => _stripeToken;
  String get preferedDriverGender => _preferedDriverGender;
  String get stripeReferenceNumber => _stripeReferenceNumber;
  num get userId => _userId;
  num get productId => _productId;
  String get orderNumber => _orderNumber;
  void setStep00(Products product, CurrentUserProvider currentUser) {
    _status = 0;
    _language = '';
    _isPaid = false;
    _stripeToken = '';
    _product = product;
    _preferedDriverGender = '';
    _stripeReferenceNumber = '';
    _userId = currentUser.id ?? -1;
    _productId = product.id ?? -1;
    _orderNumber = fn.orderNumber();
  }

  DateTime get date => _date;
  int get totalNumberOfGuest => _totalNumberOfGuest;
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
  List<Guests> get guests => _guests;

  void setStep02({
    required String phoneCode,
    required String fullName,
    required String emailAddress,
    required String mobileNumber,
    required String hotelName,
    required String hotelAddress,
    required String hotelRoomNumber,
    required List<Guests> guests,
  }) {
    _phoneCode = phoneCode;
    _contactPersonName = fullName;
    _contactPersonEmail = emailAddress;
    _contactPersonMobile = mobileNumber;
    _hotelName = hotelName;
    _hotelAddress = hotelAddress;
    _hotelRoomNumber = hotelRoomNumber;
    _guests = guests;
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

    if (!skip.contains('stripeReferenceNumber')) {
      data['StripeReferenceNumber'] = stripeReferenceNumber;
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

    return data;
  }
}
