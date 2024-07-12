class CurrencyRate {
  final num id;
  final num conversionRate;
  final DateTime updatedAtDateTime;
  final String updatedByUserName;
  final String currencySymbol;
  final String currencyLabel;
  final String currencyShortLabel;

  CurrencyRate({
    required this.id,
    required this.conversionRate,
    required this.updatedAtDateTime,
    required this.updatedByUserName,
    required this.currencySymbol,
    required this.currencyLabel,
    required this.currencyShortLabel,
  });

  factory CurrencyRate.fromJson(Map<String, dynamic> json) {
    return CurrencyRate(
      id: json['Id'],
      conversionRate: json['ConversionRate'],
      updatedAtDateTime: DateTime.parse(json['UpdatedAtDateTime']),
      updatedByUserName: json['UpdatedByUserName'],
      currencySymbol: json['CurrencySymbol'],
      currencyLabel: json['CurrencyLabel'],
      currencyShortLabel: json['CurrencyShortLabel'],
    );
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {
      'Id': id,
      'ConversionRate': conversionRate,
      'UpdatedAtDateTime': updatedAtDateTime.toIso8601String(),
      'UpdatedByUserName': updatedByUserName,
      'CurrencySymbol': currencySymbol,
      'CurrencyLabel': currencyLabel,
      'CurrencyShortLabel': currencyShortLabel,
    };

    for (var key in skip) {
      data.remove(key);
    }

    return data;
  }
}
