import 'dart:io';

import 'package:flutter/material.dart';
import '/core/app_export.dart';

class ProfileProvider with ChangeNotifier {
  final BuildContext context;
  final supabase = Supabase.instance.client;
  Props props = Props(data: null, initialData: null);

  late AuthenticationProvider auth;
  late CurrentUserProvider currentUser;
  late ConnectivityProvider connectivity;

  ProfileProvider(this.context) {
    auth = context.read<AuthenticationProvider>();
    connectivity = context.read<ConnectivityProvider>();
    currentUser = context.read<CurrentUserProvider>();
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

  Future<void> onReady() async {
    try {
      props.setLoading();
      notifyListeners();

      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      if (!auth.isAuthorized) {
        throw UnauthorizedException();
      }

      var response = await supabase.rpc('profile', params: {
        'user_id': currentUser.id,
      });

      if (response == null) {
        props.setSuccess(currentData: null);
        notifyListeners();
      } else {
        props.setSuccess(currentData: UserProfile.fromJson(response));
        notifyListeners();
      }
    } on NoInternetException catch (error) {
      console.internet(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      console.authentication(error, trace);
      props.setAuthException(currentError: error.message.toString());
      notifyListeners();
    } on CustomException catch (error) {
      console.custom(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
    } catch (error) {
      console.error(error, trace);
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
    }
  }

  Future<dynamic> onUpdateProfile(File file) async {
    try {
      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      if (!auth.isAuthorized) {
        throw UnauthorizedException();
      }

      String filename = '${fn.objectId()}.png';

      String path = await supabase.storage
          .from('profile/${currentUser.uuid}')
          .upload(filename, file);

      var response = await auth.onUpdateProfile("${Environment.bucket}/$path");
      return response;
    } on NoInternetException catch (error) {
      console.internet(error, trace);
      rethrow;
    } on AuthException catch (error) {
      console.authentication(error, trace);
      rethrow;
    } on CustomException catch (error) {
      console.custom(error, trace);
      rethrow;
    } catch (error) {
      console.error(error, trace);
      rethrow;
    }
  }

  Future<void> onRefresh({num userId = 1}) async {
    await onReady();
  }
}
