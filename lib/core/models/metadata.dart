import '/core/app_export.dart';

class Credentials {
  String? provider;
  String? email;
  String? phone;
  String? password;
  bool? rememberMe;

  Credentials({
    this.provider,
    this.email,
    this.phone,
    this.password,
    this.rememberMe = false,
  });

  factory Credentials.fromJson(dynamic json) {
    return Credentials(
      provider: json['provider'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      rememberMe: json['rememberMe'],
    );
  }

  Map<String, dynamic> toJson({List skip = const []}) {
    final Map<String, dynamic> data = {};

    if (!skip.contains('provider')) {
      data['provider'] = provider;
    }

    if (!skip.contains('email')) {
      data['email'] = email;
    }

    if (!skip.contains('phone')) {
      data['phone'] = phone;
    }

    if (!skip.contains('password')) {
      data['password'] = password;
    }

    if (!skip.contains('rememberMe')) {
      data['rememberMe'] = rememberMe;
    }

    return data;
  }
}

class AppMetadata {
  String? provider;
  List<String>? providers;

  AppMetadata({this.provider = '', this.providers = const []});

  factory AppMetadata.fromJson(dynamic json) {
    return AppMetadata(
      provider: json['provider'],
      providers: json['providers'] != null
          ? (json['providers'] as List)
              .map((provider) => provider.toString())
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'providers': providers?.map((e) => e),
    };
  }

  bool get isGoogle => provider == 'google' ? true : false;
  bool get isFacebook => provider == 'facebook' ? true : false;
  bool get isEmail => provider == 'email' ? true : false;
  bool get isPhone => provider == 'phone' ? true : false;
}

class UserMetadata {
  String? avatarUrl;
  String? email;
  bool? emailVerified;
  String? fullName;
  String? iss;
  String? name;
  String? phone;
  bool? phoneVerified;
  String? picture;
  String? provider;
  String? providerId;
  String? sub;

  UserMetadata({
    this.avatarUrl,
    this.email,
    this.emailVerified,
    this.fullName,
    this.iss,
    this.name,
    this.phone,
    this.phoneVerified,
    this.picture,
    this.provider,
    this.providerId,
    this.sub,
  });

  factory UserMetadata.signup(dynamic json) {
    return UserMetadata(
      name: json['full_name'],
      avatarUrl: json['avatar_url'],
      email: json['email'],
      emailVerified: json['email_verified'],
      fullName: json['full_name'],
      iss: json['iss'],
      phone: json['phone'],
      phoneVerified: json['phone_verified'],
      picture: json['picture'],
      provider: json['provider'],
      providerId: json['provider_id'],
      sub: json['sub'],
    );
  }

  factory UserMetadata.fromJson(dynamic json) {
    return UserMetadata(
      avatarUrl: json['avatar_url'],
      email: json['email'],
      emailVerified: json['email_verified'],
      fullName: json['full_name'],
      iss: json['iss'],
      name: json['name'],
      phone: json['phone'],
      phoneVerified: json['phone_verified'],
      picture: json['picture'],
      provider: json['provider'],
      providerId: json['provider_id'],
      sub: json['sub'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avatar_url': avatarUrl,
      'email': email,
      'email_verified': emailVerified,
      'full_name': fullName,
      'iss': iss,
      'name': name,
      'phone': phone,
      'phone_verified': phoneVerified,
      'picture': picture,
      'provider': provider,
      'provider_id': providerId,
      'sub': sub,
    };
  }

  Map<String, dynamic> forSupabase(uuid) {
    return {
      'Uuid': uuid,
      'Email': email,
      'ProviderDisplayName': fullName,
      'Name': name,
      'MobileNumber': phone,
      'LoginProvider': provider,
      'ProviderKey': providerId,
    };
  }

  factory UserMetadata.fromGoogle(User user) {
    Map<String, dynamic>? userMetadata = user.userMetadata;
    return UserMetadata(
      avatarUrl: userMetadata?['avatar_url'],
      email: userMetadata?['email'],
      emailVerified: userMetadata?['email_verified'],
      fullName: userMetadata?['full_name'],
      iss: userMetadata?['iss'],
      name: userMetadata?['name'],
      phone: userMetadata?['phone'],
      phoneVerified: userMetadata?['phone_verified'],
      picture: userMetadata?['picture'],
      provider: 'google',
      providerId: userMetadata?['provider_id'],
      sub: userMetadata?['sub'],
    );
  }

  factory UserMetadata.fromFacebook(User user) {
    Map<String, dynamic>? userMetadata = user.userMetadata;

    return UserMetadata(
      avatarUrl: userMetadata?['avatar_url'],
      email: userMetadata?['email'],
      emailVerified: userMetadata?['email_verified'],
      fullName: userMetadata?['full_name'],
      iss: userMetadata?['iss'],
      name: userMetadata?['name'],
      phone: userMetadata?['phone'],
      phoneVerified: userMetadata?['phone_verified'],
      picture: userMetadata?['picture'],
      provider: 'google',
      providerId: userMetadata?['provider_id'],
      sub: userMetadata?['sub'],
    );
  }

  factory UserMetadata.fromEmailAndPhone(User user) {
    Map<String, dynamic>? userMetadata = user.userMetadata;

    return UserMetadata(
      avatarUrl: userMetadata?['avatar_url'],
      email: userMetadata?['email'],
      emailVerified: userMetadata?['email_verified'],
      fullName: userMetadata?['full_name'],
      iss: userMetadata?['iss'],
      name: userMetadata?['name'],
      phone: userMetadata?['phone'],
      phoneVerified: userMetadata?['phone_verified'],
      picture: userMetadata?['picture'],
      provider: 'google',
      providerId: userMetadata?['provider_id'],
      sub: userMetadata?['sub'],
    );
  }
}
