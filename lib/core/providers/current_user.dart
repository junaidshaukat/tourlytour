import 'dart:io';

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

  bool get onboarding => box.get('onboarding', defaultValue: true);
  bool get rememberMe => box.get('rememberMe', defaultValue: false);

  num? get id => box.get('Id', defaultValue: '');
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
      box.get('Avatar', defaultValue: 'assets/images/profile.png');

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
      console.log(error, 'CurrentUserProvider::find::NoInternetException');
      props.setError(currentError: error.toString());
      notifyListeners();
      return false;
    } on CustomException catch (error) {
      console.log(error, 'CurrentUserProvider::find::CustomException');
      props.setError(currentError: error.toString());
      notifyListeners();
      return false;
    } on AuthException catch (error) {
      console.log(error, 'CurrentUserProvider::find::AuthException');
      props.setError(currentError: error.message.toString());
      notifyListeners();
      return false;
    } catch (error) {
      console.log(error, 'CurrentUserProvider::find');
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

      console.log(users.toJson(skip: ['id']));

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
      console.log(error, 'CurrentUserProvider::update::NoInternetException');
      props.setError(currentError: error.toString());
      notifyListeners();
      return false;
    } on CustomException catch (error) {
      console.log(error, 'CurrentUserProvider::update::CustomException');
      props.setError(currentError: error.toString());
      notifyListeners();
      return false;
    } on AuthException catch (error) {
      console.log(error, 'CurrentUserProvider::update::AuthException');
      props.setError(currentError: error.message.toString());
      notifyListeners();
      return false;
    } catch (error) {
      console.log(error, 'CurrentUserProvider::update');
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
      console.log(users.toJson(skip: ['id']));

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
      console.log(error, 'CurrentUserProvider::create::NoInternetException');
      props.setError(currentError: error.toString());
      notifyListeners();
      return false;
    } on CustomException catch (error) {
      console.log(error, 'CurrentUserProvider::create::CustomException');
      props.setError(currentError: error.toString());
      notifyListeners();
      return false;
    } on AuthException catch (error) {
      console.log(error, 'CurrentUserProvider::create::AuthException');
      props.setError(currentError: error.message.toString());
      notifyListeners();
      return false;
    } catch (error) {
      console.log(error, 'CurrentUserProvider::create');
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
      console.log(error, 'CurrentUserProvider::setAvatar::NoInternetException');
      props.setError(currentError: error.toString());
      notifyListeners();
    } on CustomException catch (error) {
      console.log(error, 'CurrentUserProvider::setAvatar::CustomException');
      props.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      console.log(error, 'CurrentUserProvider::setAvatar::AuthException');
      props.setError(currentError: error.message.toString());
      notifyListeners();
    } catch (error) {
      console.log(error, 'CurrentUserProvider::setAvatar');
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
      console.log(error, 'CurrentUserProvider::exists');
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
      console.log(
          error, 'CurrentUserProvider::uploadProfile::NoInternetException');
      props.setError(currentError: error.toString());
      notifyListeners();
    } on CustomException catch (error) {
      console.log(error, 'CurrentUserProvider::uploadProfile::CustomException');
      props.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      console.log(error, 'CurrentUserProvider::uploadProfile::AuthException');
      props.setError(currentError: error.message.toString());
      notifyListeners();
    } catch (error) {
      console.log(error, 'CurrentUserProvider::uploadProfile');
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
    }
  }
}
