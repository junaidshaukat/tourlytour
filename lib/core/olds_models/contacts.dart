import '../app_export.dart';

class Contacts {
  String? whatsapp;
  String? instagram;
  String? twitter;
  String? wechat;
  String? viber;
  String? threads;
  String? line;

  Contacts({
    this.whatsapp,
    this.instagram,
    this.twitter,
    this.wechat,
    this.viber,
    this.threads,
    this.line,
  });

  factory Contacts.fromJson(dynamic json) {
    try {
      return Contacts(
        whatsapp: json['whatsapp'],
        instagram: json['instagram'],
        twitter: json['twitter'],
        wechat: json['wechat'],
        viber: json['viber'],
        threads: json['threads'],
        line: json['line'],
      );
    } catch (e) {
      console.error(e, 'Contacts');
      rethrow;
    }
  }

  Map<String, dynamic> toJson({List skip = const []}) {
    final Map<String, dynamic> data = {};

    if (!skip.contains('whatsapp')) {
      data['Whatsapp'] = whatsapp;
    }

    if (!skip.contains('instagram')) {
      data['Instagram'] = instagram;
    }

    if (!skip.contains('twitter')) {
      data['Twitter'] = twitter;
    }

    if (!skip.contains('wechat')) {
      data['Wechat'] = wechat;
    }

    if (!skip.contains('viber')) {
      data['Viber'] = viber;
    }

    if (!skip.contains('threads')) {
      data['Threads'] = threads;
    }

    if (!skip.contains('line')) {
      data['Line'] = line;
    }

    return data;
  }
}
