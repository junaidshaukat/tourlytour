import '/core/app_export.dart';

extension UserX on User {
  String get uuid {
    return id;
  }

  String get name {
    Map<String, dynamic> data = userMetadata ?? {};

    if (data.containsKey('full_name')) {
      String fullName = data['full_name'];
      if (fullName.isNotEmpty) {
        return fullName;
      }
    }

    if (data.containsKey('name')) {
      String name = data['name'];
      if (name.isNotEmpty) {
        return name;
      }
    }

    return '';
  }

  String get emails {
    Map<String, dynamic> data = userMetadata ?? {};

    if (email != null) {
      if (email!.isNotEmpty) return email!;
    }

    if (data.containsKey('email')) {
      String email = data['email'];
      if (email.isNotEmpty) {
        return email;
      }
    }

    return '';
  }

  String get password {
    return '';
  }

  bool get isVerified {
    return true;
  }

  String get providerKey {
    Map<String, dynamic> data = userMetadata ?? {};

    if (data.containsKey('provider_id')) {
      String providerId = data['provider_id'];
      if (providerId.isNotEmpty) {
        return providerId;
      }
    }

    if (data.containsKey('sub')) {
      String sub = data['sub'];
      if (sub.isNotEmpty) {
        return sub;
      }
    }

    return '';
  }

  String get mobileNumber {
    if (phone != null && phone!.isNotEmpty) {
      return phone!;
    }

    return '';
  }

  String get loginProvider {
    Map<String, dynamic> data = appMetadata;

    if (data.containsKey('provider')) {
      String provider = data['provider'];
      if (provider.isNotEmpty) {
        return provider;
      }
    }

    return '';
  }

  String get profilePhotoUrl {
    Map<String, dynamic> data = userMetadata ?? {};

    if (data.containsKey('picture')) {
      String pictureUrl = data['picture'];
      if (pictureUrl.isNotEmpty) {
        return pictureUrl;
      }
    }

    if (data.containsKey('avatar_url')) {
      String avatarUrl = data['avatar_url'];
      if (avatarUrl.isNotEmpty) {
        return avatarUrl;
      }
    }

    return '';
  }

  String get providerDisplayName {
    Map<String, dynamic> data = userMetadata ?? {};

    if (data.containsKey('name')) {
      String name = data['name'];
      if (name.isNotEmpty) {
        return name;
      }
    }

    if (data.containsKey('full_name')) {
      String fullName = data['full_name'];
      if (fullName.isNotEmpty) {
        return fullName;
      }
    }

    return '';
  }
}

extension AuthSession on Session {
  Map<String, dynamic> getParams() {
    return {
      "uuid": user.uuid,
      "name": user.name,
      'email': user.emails,
      "password": user.password,
      "isVerified": user.isVerified,
      "providerKey": user.providerKey,
      "mobileNumber": user.mobileNumber,
      "loginProvider": user.loginProvider,
      "profilePhotoUrl": user.profilePhotoUrl,
      "providerDisplayName": user.providerDisplayName,
    };
  }
}

extension Assets on String {
  /// - assets/fontawesome/
  String get fa {
    if (contains("fa-brands")) {
      return '${Environment.bucket}/icons/brands/${split(' ').last.replaceFirst('fa-', '').replaceAll('-', '_').svg}';
    } else if (contains("fa-duotone")) {
      return '${Environment.bucket}/icons/duotone/${split(' ').last.replaceFirst('fa-', '').replaceAll('-', '_').svg}';
    } else if (contains("fa-light")) {
      return '${Environment.bucket}/icons/light/${split(' ').last.replaceFirst('fa-', '').replaceAll('-', '_').svg}';
    } else if (contains("fa-regular")) {
      return '${Environment.bucket}/icons/regular/${split(' ').last.replaceFirst('fa-', '').replaceAll('-', '_').svg}';
    } else if (contains("fa-solid")) {
      return '${Environment.bucket}/icons/solid/${split(' ').last.replaceFirst('fa-', '').replaceAll('-', '_').svg}';
    } else if (contains("fa-thin")) {
      return '${Environment.bucket}/icons/thin/${split(' ').last.replaceFirst('fa-', '').replaceAll('-', '_').svg}';
    } else {
      return '${Environment.bucket}/$this';
    }
  }

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
