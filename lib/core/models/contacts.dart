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
    return Contacts(
      whatsapp: json['whatsapp'],
      instagram: json['instagram'],
      twitter: json['twitter'],
      wechat: json['wechat'],
      viber: json['viber'],
      threads: json['threads'],
      line: json['line'],
    );
  }

  Map<String, dynamic> toJson({List skip = const []}) {
    final Map<String, dynamic> data = {};

    if (!skip.contains('whatsapp')) {
      data['whatsapp'] = whatsapp;
    }

    if (!skip.contains('instagram')) {
      data['instagram'] = instagram;
    }

    if (!skip.contains('twitter')) {
      data['twitter'] = twitter;
    }

    if (!skip.contains('wechat')) {
      data['wechat'] = wechat;
    }

    if (!skip.contains('viber')) {
      data['viber'] = viber;
    }

    if (!skip.contains('threads')) {
      data['threads'] = threads;
    }

    if (!skip.contains('line')) {
      data['line'] = line;
    }

    return data;
  }
}
