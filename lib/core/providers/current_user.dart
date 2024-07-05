import 'dart:io';

import 'package:flutter/material.dart';
import '/core/app_export.dart';

class CurrentUserProvider with ChangeNotifier {
  final BuildContext context;
  final supabase = Supabase.instance.client;
  Props props = Props(data: [], initialData: []);

  late Box box;
  late AuthenticationProvider auth;
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
  String get avatar => box.get('Avatar', defaultValue: 'profile'.image.png);

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

  Future<bool> find(String? uuid) async {
    try {
      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      var response = await supabase
          .from('Users')
          .select()
          .eq('Uuid', "$uuid")
          .maybeSingle();

      if (response != null) {
        return true;
      } else {
        return false;
      }
    } on NoInternetException catch (error) {
      console.internet(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
      return false;
    } on CustomException catch (error) {
      console.custom(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
      return false;
    } on AuthException catch (error) {
      console.authentication(error, trace);
      props.setUnauthorized(currentError: error.message.toString());
      notifyListeners();
      return false;
    } catch (error) {
      console.error(error, trace);
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
      return false;
    }
  }

  Future<bool> signedOut() async {
    try {
      await box.clear();
      await box.put('onboarding', false);
      await onReady();
      notifyListeners();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> update(String? uuid, Users users) async {
    try {
      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      var response = await supabase
          .from('Users')
          .update(users.toJson(skip: ['id']))
          .eq('Uuid', "$uuid")
          .select()
          .maybeSingle();

      if (response != null) {
        Users users = Users.fromJson(response);
        await box.putAll(users.toJson());
        await onReady();
        return true;
      } else {
        return false;
      }
    } on NoInternetException catch (error) {
      console.internet(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
      return false;
    } on CustomException catch (error) {
      console.custom(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
      return false;
    } on AuthException catch (error) {
      console.authentication(error, trace);
      props.setUnauthorized(currentError: error.message.toString());
      notifyListeners();
      return false;
    } catch (error) {
      console.error(error, trace);
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
      return false;
    }
  }

  Future<bool> create(String? uuid, Users users) async {
    try {
      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      var response = await supabase
          .from('Users')
          .insert(users.toJson(skip: ['id']))
          .select()
          .maybeSingle();

      if (response != null) {
        Users users = Users.fromJson(response);
        await box.putAll(users.toJson());
        await onReady();
        notifyListeners();

        return true;
      } else {
        notifyListeners();

        return false;
      }
    } on NoInternetException catch (error) {
      console.internet(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
      return false;
    } on CustomException catch (error) {
      console.custom(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
      return false;
    } on AuthException catch (error) {
      console.authentication(error, trace);
      props.setUnauthorized(currentError: error.message.toString());
      notifyListeners();
      return false;
    } catch (error) {
      console.error(error, trace);
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
      return false;
    }
  }

  Future<void> setAvatar(String path) async {
    try {
      props.setProcessing();
      notifyListeners();
      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      String url = supabase.storage.from('profile').getPublicUrl(path);
      await put('Avatar', url);
      props.setSuccess();
      notifyListeners();
    } on NoInternetException catch (error) {
      console.internet(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
    } on CustomException catch (error) {
      console.custom(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      console.authentication(error, trace);
      props.setUnauthorized(currentError: error.message.toString());
      notifyListeners();
    } catch (error) {
      console.error(error, trace);
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
    }
  }

  Future<bool> exists(String bucket, String path, String name) async {
    try {
      final files = await supabase.storage.from(bucket).list(path: path);
      if (files.isEmpty) {
        return false;
      }
      return files.any((file) => file.name == name);
    } catch (error) {
      console.error(error, trace);
      return false;
    }
  }

  Future<void> uploadProfile(File file) async {
    try {
      props.setProcessing();
      notifyListeners();
      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      String filename = '${fn.objectId()}.png';

      await supabase.storage.from('profile').upload(
            '$uuid/$filename',
            file,
          );

      await setAvatar('$uuid/$filename');
      await onReady();
      props.setSuccess();
      notifyListeners();
    } on NoInternetException catch (error) {
      console.internet(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
    } on CustomException catch (error) {
      console.custom(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      console.authentication(error, trace);
      props.setUnauthorized(currentError: error.message.toString());
      notifyListeners();
    } catch (error) {
      console.error(error, trace);
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
    }
  }
}
