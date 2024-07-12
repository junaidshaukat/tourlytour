class Favourite {
  final num id;
  final num productId;
  final num userId;
  final String status;

  Favourite({
    required this.id,
    required this.productId,
    required this.userId,
    required this.status,
  });

  factory Favourite.fromJson(Map<String, dynamic> json) {
    return Favourite(
      id: json['Id'],
      productId: json['ProductId'],
      userId: json['UserId'],
      status: json['Status'],
    );
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {
      'Id': id,
      'ProductId': productId,
      'UserId': userId,
      'Status': status,
    };

    for (var key in skip) {
      data.remove(key);
    }

    return data;
  }
}
