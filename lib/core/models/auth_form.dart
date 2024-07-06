class AuthForm {
  String? provider;
  String? event;
  String? name;
  String? email;
  String? phone;
  String? password;
  String? passwordConfirm;
  bool rememberMe;

  AuthForm({
    this.provider,
    this.event,
    this.name,
    this.email,
    this.phone,
    this.password,
    this.passwordConfirm,
    this.rememberMe = false,
  });

  factory AuthForm.fromJson(dynamic json) {
    return AuthForm(
      provider: json['provider'] as String?,
      event: json['event'] as String?,
      name: json['full_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      password: json['password'] as String?,
      passwordConfirm: json['passwordConfirm'] as String?,
      rememberMe: json['rememberMe'] ?? false,
    );
  }

  Map<String, dynamic> toJson({List skip = const []}) {
    final Map<String, dynamic> data = {};

    if (!skip.contains('provider')) {
      data['provider'] = provider;
    }

    if (!skip.contains('event')) {
      data['event'] = event;
    }

    if (!skip.contains('name')) {
      data['name'] = name;
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

    if (!skip.contains('passwordConfirm')) {
      data['passwordConfirm'] = passwordConfirm;
    }

    if (!skip.contains('rememberMe')) {
      data['rememberMe'] = rememberMe;
    }

    return data;
  }
}

class AuthProvider {
  static String get email => "Email";
  static String get facebook => "Facebook";
  static String get google => "Google";
  static String get phone => "Phone";
}

class AuthEvent {
  static String get forgetPassword => "forget_password";
  static String get signin => "signin";
  static String get signup => "signup";
  static String get update => "update";
}
