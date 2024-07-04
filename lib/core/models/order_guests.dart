class OrderGuests {
  num? id;
  String? name;
  String? passportNumber;
  num? orderId;

  OrderGuests({
    this.id,
    this.name,
    this.passportNumber,
    this.orderId,
  });

  factory OrderGuests.fromJson(dynamic json) {
    return OrderGuests(
      id: json['Id'] as num?,
      name: json['Name'] as String?,
      passportNumber: json['PassportNumber'] as String?,
      orderId: json['OrderId'] as num?,
    );
  }

  factory OrderGuests.toGuest(dynamic json) {
    return OrderGuests(
      name: json['name'] as String?,
      passportNumber: json['passport'] as String?,
    );
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
