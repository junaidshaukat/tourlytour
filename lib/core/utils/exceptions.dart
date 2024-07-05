import '/core/app_export.dart';

class NoInternetException implements Exception {
  late String _message;

  NoInternetException([String message = 'no_internet_connection']) {
    _message = message.tr;
  }

  @override
  String toString() {
    return _message;
  }
}

class CustomException implements Exception {
  late String _message;

  CustomException([String message = 'something_went_wrong']) {
    _message = message.tr;
  }

  @override
  String toString() {
    return _message;
  }
}

class PaymentIntentException implements Exception {
  late String _message;

  PaymentIntentException([String message = 'something_went_wrong']) {
    _message = message.tr;
  }

  @override
  String toString() {
    return _message;
  }
}

class UnauthorizedException extends AuthException {
  UnauthorizedException() : super('401 Unauthorized!', statusCode: '401');
}
