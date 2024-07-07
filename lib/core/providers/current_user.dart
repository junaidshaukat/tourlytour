import 'package:flutter/material.dart';
import '/core/app_export.dart';

class CurrentUserProvider with ChangeNotifier {
  final BuildContext context;
  final supabase = Supabase.instance.client;
  Props props = Props(data: [], initialData: []);

  late Box box;
  late ConnectivityProvider connectivity;

  CurrentUserProvider(this.context) {
    connectivity = context.read<ConnectivityProvider>();
  }

  String get trace {
    final stackTrace = StackTrace.current;
    final frames = stackTrace.toString().split('\n');

    if (frames.length > 1) {
      final callerFrame = frames[1].trim();
      final regex = RegExp(r'#\d+\s+(\S+)\.(\S+)\s+\(.*\)');
      final match = regex.firstMatch(callerFrame);

      if (match != null) {
        final className = match.group(1);
        final methodName = match.group(2);
        return "$className::$methodName";
      } else {
        return "$runtimeType::unknown";
      }
    } else {
      return "$runtimeType::unknown";
    }
  }

  bool get onboarding => box.get('onboarding', defaultValue: true);
  bool get rememberMe => box.get('rememberMe', defaultValue: false);

  num get id => box.get('Id', defaultValue: 0);
  String get uuid => box.get('Uuid', defaultValue: '');
  String get name => box.get('Name', defaultValue: '');
  String get email => box.get('Email', defaultValue: '');
  String get providerKey => box.get('ProviderKey', defaultValue: '');
  String get providerDisplayName =>
      box.get('ProviderDisplayName', defaultValue: '');
  String get loginProvider => box.get('LoginProvider', defaultValue: '');
  String get mobileNumber => box.get('MobileNumber', defaultValue: '');
  String get password => box.get('Password', defaultValue: '');
  String get avatar =>
      box.get('ProfilePhotoUrl', defaultValue: 'profile'.image.png);

  dynamic get credentials => box.get('credentials', defaultValue: {});
  dynamic get appMetaData => box.get('app_meta_data', defaultValue: {});
  dynamic get userMetaData => box.get('user_meta_data', defaultValue: {});

  Future<void> onReady() async {
    await HiveBox.onReady();
    box = HiveBox.users;

    notifyListeners();
  }

  Future<void> setOnboarding(bool value) async {
    await box.put('onboarding', value);
    await onReady();
    notifyListeners();
  }

  Future<void> put(dynamic key, dynamic value) async {
    await box.put(key, value);
    await onReady();
    notifyListeners();
  }

  Future<void> putAll(Map<dynamic, dynamic> entries) async {
    await box.putAll(entries);
    await onReady();
    notifyListeners();
  }

  Future<void> clearAll() async {
    await box.clear();
    await box.put('onboarding', false);
  }
}
