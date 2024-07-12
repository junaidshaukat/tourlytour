class ProductItinerary {
  final num status;
  final num travelHours;
  final num productId;
  final num time;
  final num id;
  final String city;
  final String country;
  final String tags;
  final String code;
  final String title;
  final String description;
  final String iconUrl;
  final String imageUrl;

  ProductItinerary({
    required this.status,
    required this.travelHours,
    required this.productId,
    required this.time,
    required this.id,
    required this.city,
    required this.country,
    required this.tags,
    required this.code,
    required this.title,
    required this.description,
    required this.iconUrl,
    required this.imageUrl,
  });

  factory ProductItinerary.fromJson(Map<String, dynamic> json) {
    return ProductItinerary(
      status: json['Status'],
      travelHours: json['TravelHours'],
      productId: json['ProductId'],
      time: json['Time'],
      id: json['Id'],
      city: json['City'],
      country: json['Country'],
      tags: json['Tags'],
      code: json['Code'],
      title: json['Title'],
      description: json['Description'],
      iconUrl: json['IconUrl'],
      imageUrl: json['ImageUrl'],
    );
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {
      'Status': status,
      'TravelHours': travelHours,
      'ProductId': productId,
      'Time': time,
      'Id': id,
      'City': city,
      'Country': country,
      'Tags': tags,
      'Code': code,
      'Title': title,
      'Description': description,
      'IconUrl': iconUrl,
      'ImageUrl': imageUrl,
    };

    for (var key in skip) {
      data.remove(key);
    }

    return data;
  }
}
