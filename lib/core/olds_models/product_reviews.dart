import '/core/app_export.dart';

class ProductReviews {
  num? valueForMoney;
  num? productId;
  num? userId;
  num? rate;
  num? id;
  DateTime? dateTime;
  num? status;
  num? hospitality;
  num? impressiveness;
  num? seamlessExperience;
  String? description;

  Users? user;
  List<ProductReviewPhotos> photos;

  ProductReviews({
    this.id,
    this.productId,
    this.userId,
    this.rate,
    this.description,
    this.dateTime,
    this.status,
    this.hospitality,
    this.impressiveness,
    this.seamlessExperience,
    this.valueForMoney,
    this.user,
    this.photos = const [],
  });

  factory ProductReviews.fromJson(Map<String, dynamic> json) {
    try {
      return ProductReviews(
        valueForMoney: json['ValueForMoney'],
        productId: json['ProductId'],
        userId: json['UserId'],
        rate: json['Rate'],
        id: json['Id'],
        dateTime: DateTime.parse(json['DateTime']),
        status: json['Status'],
        hospitality: json['Hospitality'],
        impressiveness: json['Impressiveness'],
        seamlessExperience: json['SeamlessExperience'],
        description: json['Description'],
        user: json['user'] != null ? Users.fromJson(json['user']) : null,
        photos: json['photos'] != null
            ? (json['photos'] as List)
                .map((e) => ProductReviewPhotos.fromJson(e))
                .toList()
            : [],
      );
    } catch (e) {
      console.error(e, 'ProductReviews');
      rethrow;
    }
  }

  Map<String, dynamic> toJson({List skip = const []}) {
    final Map<String, dynamic> data = {};

    if (!skip.contains('id')) {
      data['Id'] = id;
    }

    if (!skip.contains('productId')) {
      data['ProductId'] = productId;
    }

    if (!skip.contains('userId')) {
      data['UserId'] = userId;
    }

    if (!skip.contains('rate')) {
      data['Rate'] = rate;
    }

    if (!skip.contains('description')) {
      data['Description'] = description;
    }

    if (!skip.contains('dateTime')) {
      data['DateTime'] = dateTime?.toIso8601String();
    }

    if (!skip.contains('status')) {
      data['Status'] = status;
    }

    if (!skip.contains('hospitality')) {
      data['Hospitality'] = hospitality;
    }

    if (!skip.contains('impressiveness')) {
      data['Impressiveness'] = impressiveness;
    }

    if (!skip.contains('seamlessExperience')) {
      data['SeamlessExperience'] = seamlessExperience;
    }

    if (!skip.contains('ValueForMoney')) {
      data['ValueForMoney'] = valueForMoney;
    }

    if (!skip.contains('user')) {
      data['User'] = user?.toJson();
    }

    if (!skip.contains('photos')) {
      data['Photos'] = photos.map((e) => e.toJson()).toList();
    }

    return data;
  }
}
