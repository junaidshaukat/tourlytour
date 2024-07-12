class Location {
  final num id;
  final num status;
  final String city;
  final String country;
  final String description;
  final String coordinates;
  final String photoUrl;
  final String name;

  Location({
    required this.id,
    required this.status,
    required this.city,
    required this.country,
    required this.description,
    required this.coordinates,
    required this.photoUrl,
    required this.name,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['Id'],
      status: json['Status'],
      city: json['City'],
      country: json['Country'],
      description: json['Description'],
      coordinates: json['Coordinates'],
      photoUrl: json['PhotoUrl'],
      name: json['Name'],
    );
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {
      'Id': id,
      'Status': status,
      'City': city,
      'Country': country,
      'Description': description,
      'Coordinates': coordinates,
      'PhotoUrl': photoUrl,
      'Name': name,
    };

    for (var key in skip) {
      data.remove(key);
    }

    return data;
  }
}
