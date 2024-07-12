import 'package:tourlytour/core/utils/console.dart';

class Statistics {
  num rate;
  num hospitality;
  num valueForMoney;
  num impressiveness;
  num seamlessExperience;

  Statistics({
    this.rate = 0,
    this.hospitality = 0,
    this.valueForMoney = 0,
    this.impressiveness = 0,
    this.seamlessExperience = 0,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) {
    try {
      return Statistics(
        rate: json['rate'],
        hospitality: json['hospitality'],
        valueForMoney: json['valueForMoney'],
        impressiveness: json['impressiveness'],
        seamlessExperience: json['seamlessExperience'],
      );
    } catch (e) {
      console.error(e, 'Statistics');
      rethrow;
    }
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {};

    if (!skip.contains('rate')) {
      data['rate'] = rate;
    }

    if (!skip.contains('hospitality')) {
      data['hospitality'] = hospitality;
    }

    if (!skip.contains('valueForMoney')) {
      data['valueForMoney'] = valueForMoney;
    }

    if (!skip.contains('impressiveness')) {
      data['impressiveness'] = impressiveness;
    }

    if (!skip.contains('seamlessExperience')) {
      data['seamlessExperience'] = seamlessExperience;
    }

    return data;
  }
}
