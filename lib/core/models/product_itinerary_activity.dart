class ProductItineraryActivity {
  final num id;
  final num productItineraryId;
  final num duration;
  final String title;
  final String description;
  final String tags;

  ProductItineraryActivity({
    required this.id,
    required this.productItineraryId,
    required this.duration,
    required this.title,
    required this.description,
    required this.tags,
  });

  factory ProductItineraryActivity.fromJson(Map<String, dynamic> json) {
    return ProductItineraryActivity(
      id: json['Id'],
      productItineraryId: json['ProductItineraryId'],
      duration: json['Duration'],
      title: json['Title'],
      description: json['Description'],
      tags: json['Tags'],
    );
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {
      'Id': id,
      'ProductItineraryId': productItineraryId,
      'Duration': duration,
      'Title': title,
      'Description': description,
      'Tags': tags,
    };

    for (var key in skip) {
      data.remove(key);
    }

    return data;
  }
}
