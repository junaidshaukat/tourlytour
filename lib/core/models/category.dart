class Category {
  final num id;
  final num rating;
  final String name;
  final String shortDescription;
  final String longDescription;
  final String tags;

  Category({
    required this.id,
    required this.rating,
    required this.name,
    required this.shortDescription,
    required this.longDescription,
    required this.tags,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['Id'],
      rating: json['Rating'],
      name: json['Name'],
      shortDescription: json['ShortDescription'],
      longDescription: json['LongDescription'],
      tags: json['Tags'],
    );
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {
      'Id': id,
      'Rating': rating,
      'Name': name,
      'ShortDescription': shortDescription,
      'LongDescription': longDescription,
      'Tags': tags,
    };

    for (var key in skip) {
      data.remove(key);
    }

    return data;
  }
}
