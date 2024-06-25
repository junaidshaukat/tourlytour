import '/core/app_export.dart';

class ProductReviews {
  num? id;
  num? productId;
  num? userId;
  num? rate;
  String? description;
  DateTime? dateTime;
  num? status;
  num? hospitality;
  num? impressiveness;
  num? seamlessExperience;
  num? valueForMoney;

  Products? product;
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
    this.product,
    this.user,
    this.photos = const [],
  });

  factory ProductReviews.fromJson(Map<String, dynamic> json) {
    return ProductReviews(
      id: json['Id'] as num?,
      productId: json['ProductId'] as num?,
      userId: json['UserId'] as num?,
      rate: json['Rate'] as num?,
      description: json['Description'] as String?,
      dateTime:
          json['DateTime'] != null ? DateTime.parse(json['DateTime']) : null,
      status: json['Status'] as num?,
      hospitality: json['Hospitality'] as num?,
      impressiveness: json['Impressiveness'] as num?,
      seamlessExperience: json['SeamlessExperience'] as num?,
      valueForMoney: json['ValueForMoney'] as num?,
      product:
          json['Products'] != null ? Products.fromJson(json['Products']) : null,
      user: json['Users'] != null ? Users.fromJson(json['Users']) : null,
      photos: json['ProductReviewPhotos'] != null
          ? (json['ProductReviewPhotos'] as List)
              .map((e) => ProductReviewPhotos.fromJson(e))
              .toList()
          : [],
    );
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

    if (!skip.contains('product')) {
      data['Products'] = product?.toJson();
    }

    if (!skip.contains('user')) {
      data['Users'] = user?.toJson();
    }

    if (!skip.contains('photos')) {
      data['Photos'] = photos.map((e) => e.toJson()).toList();
    }

    return data;
  }
}
