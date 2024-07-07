class UserProfile {
  bool isVerified;
  int id;
  String email;
  String providerKey;
  String providerDisplayName;
  String loginProvider;
  String mobileNumber;
  String password;
  String profilePhotoUrl;
  String uuid;
  String name;

  UserProfile({
    required this.isVerified,
    required this.id,
    required this.email,
    required this.providerKey,
    required this.providerDisplayName,
    required this.loginProvider,
    required this.mobileNumber,
    required this.password,
    required this.profilePhotoUrl,
    required this.uuid,
    required this.name,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      isVerified: json['IsVerified'],
      id: json['Id'],
      email: json['Email'],
      providerKey: json['ProviderKey'],
      providerDisplayName: json['ProviderDisplayName'],
      loginProvider: json['LoginProvider'],
      mobileNumber: json['MobileNumber'],
      password: json['Password'], // Handle securely in real applications
      profilePhotoUrl: json['ProfilePhotoUrl'],
      uuid: json['Uuid'],
      name: json['Name'],
    );
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {};

    if (!skip.contains('Id')) {
      data['Id'] = id;
    }

    if (!skip.contains('Name')) {
      data['Name'] = name;
    }

    if (!skip.contains('Email')) {
      data['Email'] = email;
    }

    if (!skip.contains('ProviderKey')) {
      data['ProviderKey'] = providerKey;
    }

    if (!skip.contains('ProviderDisplayName')) {
      data['ProviderDisplayName'] = providerDisplayName;
    }

    if (!skip.contains('LoginProvider')) {
      data['LoginProvider'] = loginProvider;
    }

    if (!skip.contains('MobileNumber')) {
      data['MobileNumber'] = mobileNumber;
    }

    if (!skip.contains('Password')) {
      data['Password'] = password; // Note: Handle securely in real applications
    }

    if (!skip.contains('IsVerified')) {
      data['IsVerified'] = isVerified;
    }

    if (!skip.contains('ProfilePhotoUrl')) {
      data['ProfilePhotoUrl'] = profilePhotoUrl;
    }

    if (!skip.contains('Uuid')) {
      data['Uuid'] = uuid;
    }

    return data;
  }
}
