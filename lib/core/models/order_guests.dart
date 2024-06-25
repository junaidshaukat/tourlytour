class OrderGuests {
  num? id;
  String? name;
  DateTime? dateOfBirth;
  String? passportNumber;
  num? orderId;

  OrderGuests({
    this.id,
    this.name,
    this.dateOfBirth,
    this.passportNumber,
    this.orderId,
  });

  factory OrderGuests.fromJson(dynamic json) {
    return OrderGuests(
      id: json['Id'] as num?,
      name: json['Name'] as String?,
      dateOfBirth: json['DateOfBirth'] != null
          ? DateTime.parse(json['DateOfBirth'])
          : null,
      passportNumber: json['PassportNumber'] as String?,
      orderId: json['OrderId'] as num?,
    );
  }

  factory OrderGuests.toGuest(dynamic json) {
    return OrderGuests(
      name: json['name'] as String?,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
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

    if (!skip.contains('dateOfBirth')) {
      data['DateOfBirth'] = dateOfBirth?.toIso8601String();
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
