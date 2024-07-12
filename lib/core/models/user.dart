class User {
  final bool isVerified;
  final num id;
  final String email;
  final String providerKey;
  final String providerDisplayName;
  final String loginProvider;
  final String mobileNumber;
  final String password;
  final String profilePhotoUrl;
  final String uuid;
  final String name;

  User({
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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      isVerified: json['IsVerified'],
      id: json['Id'],
      email: json['Email'],
      providerKey: json['ProviderKey'],
      providerDisplayName: json['ProviderDisplayName'],
      loginProvider: json['LoginProvider'],
      mobileNumber: json['MobileNumber'],
      password: json['Password'],
      profilePhotoUrl: json['ProfilePhotoUrl'],
      uuid: json['Uuid'],
      name: json['Name'],
    );
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> data = {
      'IsVerified': isVerified,
      'Id': id,
      'Email': email,
      'ProviderKey': providerKey,
      'ProviderDisplayName': providerDisplayName,
      'LoginProvider': loginProvider,
      'MobileNumber': mobileNumber,
      'Password': password,
      'ProfilePhotoUrl': profilePhotoUrl,
      'Uuid': uuid,
      'Name': name,
    };

    for (var key in skip) {
      data.remove(key);
    }

    return data;
  }
}
