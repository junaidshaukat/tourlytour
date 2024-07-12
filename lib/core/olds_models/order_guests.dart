import 'package:tourlytour/core/utils/console.dart';

class OrderGuests {
  num? id;
  num? orderId;
  String? name;
  String? passportNumber;

  OrderGuests({
    this.id,
    this.name,
    this.passportNumber,
    this.orderId,
  });

  factory OrderGuests.fromJson(dynamic json) {
    try {
      return OrderGuests(
        id: json['Id'] as num?,
        name: json['Name'] as String?,
        passportNumber: json['PassportNumber'] as String?,
        orderId: json['OrderId'] as num?,
      );
    } catch (e) {
      console.error(e, 'OrderGuests');
      rethrow;
    }
  }

  factory OrderGuests.toGuest(dynamic json) {
    try {
      return OrderGuests(
        name: json['name'] as String?,
        passportNumber: json['passport'] as String?,
      );
    } catch (e) {
      console.error(e, 'OrderGuests');
      rethrow;
    }
  }

  Map<String, dynamic> toJson({List skip = const []}) {
    final Map<String, dynamic> data = {};

    if (!skip.contains('id')) {
      data['Id'] = id;
    }

    if (!skip.contains('name')) {
      data['Name'] = name;
    }

    if (!skip.contains('passportNumber')) {
      data['PassportNumber'] = passportNumber;
    }

    if (!skip.contains('orderId')) {
      data['OrderId'] = orderId;
    }

    return data;
  }
}
