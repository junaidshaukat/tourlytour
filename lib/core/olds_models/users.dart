import 'package:tourlytour/core/utils/console.dart';

class Users {
  num? id;
  String? name;
  String? email;
  String? providerKey;
  String? providerDisplayName;
  String? loginProvider;
  String? mobileNumber;
  String? password;
  bool? isVerified;
  String? profilePhotoUrl;
  String? uuid;

  Users({
    this.id = -1,
    this.name = '',
    this.uuid = '',
    this.email = '',
    this.password = '',
    this.providerKey = '',
    this.mobileNumber = '',
    this.loginProvider = '',
    this.providerDisplayName = '',
    this.isVerified = false,
    this.profilePhotoUrl = '',
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    try {
      return Users(
        id: json['Id'] as num,
        uuid: json['Uuid'] as String,
        name: json['Name'] as String,
        email: json['Email'] as String,
        password: json['Password'] as String,
        providerKey: json['ProviderKey'] as String,
        mobileNumber: json['MobileNumber'] as String,
        providerDisplayName: json['ProviderDisplayName'] as String,
        loginProvider: json['LoginProvider'] as String,
        isVerified: json['IsVerified'] as bool,
        profilePhotoUrl: json['ProfilePhotoUrl'] as String,
      );
    } catch (e) {
      console.error(e, 'Users');
      rethrow;
    }
  }

  Map<String, dynamic> toJson({List skip = const []}) {
    final Map<String, dynamic> data = {};

    if (!skip.contains('id')) {
      data['Id'] = id;
    }

    if (!skip.contains('name')) {
      data['Name'] = name;
    }

    if (!skip.contains('email')) {
      data['Email'] = email;
    }

    if (!skip.contains('providerKey')) {
      data['ProviderKey'] = providerKey;
    }

    if (!skip.contains('providerDisplayName')) {
      data['ProviderDisplayName'] = providerDisplayName;
    }

    if (!skip.contains('loginProvider')) {
      data['LoginProvider'] = loginProvider;
    }

    if (!skip.contains('mobileNumber')) {
      data['MobileNumber'] = mobileNumber;
    }

    if (!skip.contains('password')) {
      data['Password'] = password;
    }

    if (!skip.contains('isVerified')) {
      data['IsVerified'] = isVerified;
    }

    if (!skip.contains('profilePhotoUrl')) {
      data['ProfilePhotoUrl'] = profilePhotoUrl;
    }

    if (!skip.contains('uuid')) {
      data['Uuid'] = uuid;
    }

    return data;
  }
}
