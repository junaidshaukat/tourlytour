import '/core/app_export.dart';

extension AuthSession on Session? {
  Map<String, dynamic> getParams() {
    if (this == null) {
      return {};
    } else {
      return {
        "isVerified": true,
        "password": '',
        "uuid": this!.user.id,
        'email': this!.user.email,
        "mobileNumber": this!.user.phone,
        "name": this!.user.userMetadata?['full_name'],
        "loginProvider": this!.user.appMetadata['provider'],
        "providerKey": this!.user.userMetadata?['provider_id'],
        "providerDisplayName": this!.user.userMetadata?['name'] ??
            this!.user.userMetadata?['full_name'],
        "profilePhotoUrl": this!.user.userMetadata?['avatar_url'],
      };
    }
  }
}

extension Assets on String {
  /// assets/fonts
  String get font {
    return 'assets/fonts/$this';
  }

  ///assets/icons
  String get icon {
    return 'assets/icons/$this';
  }

  ///assets/images
  String get network {
    return this;
  }

  ///assets/images
  String get image {
    return 'assets/images/$this';
  }

  ///assets/images
  String get gif {
    return 'assets/gif/$this';
  }

  ///ttf
  String get ttf {
    return '$this.ttf';
  }

  ///svg
  String get svg {
    return '$this.svg';
  }

  ///png
  String get png {
    return '$this.png';
  }

  ///png
  String get jpg {
    return '$this.jpg';
  }
}

extension DateTimeExtension on DateTime {
  String format([
    String pattern = 'dd/MM/yyyy',
    String? locale,
  ]) {
    if (locale != null && locale.isNotEmpty) {
      initializeDateFormatting(locale);
    }
    return DateFormat(pattern, locale).format(this);
  }
}
