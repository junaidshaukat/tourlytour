class OrderGuest {
  final num id;
  final DateTime dateOfBirth;
  final num orderId;
  final String name;
  final String passportNumber;

  OrderGuest({
    required this.id,
    required this.dateOfBirth,
    required this.orderId,
    required this.name,
    required this.passportNumber,
  });

  factory OrderGuest.fromJson(Map<String, dynamic> json) {
    return OrderGuest(
      id: json['Id'],
      dateOfBirth: DateTime.parse(json['DateOfBirth']),
      orderId: json['OrderId'],
      name: json['Name'],
      passportNumber: json['PassportNumber'],
    );
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {
      'Id': id,
      'DateOfBirth': dateOfBirth.toIso8601String(),
      'OrderId': orderId,
      'Name': name,
      'PassportNumber': passportNumber,
    };

    for (var key in skip) {
      data.remove(key);
    }

    return data;
  }
}
