import 'dart:async';

import 'package:flutter/material.dart';
import '/core/app_export.dart';

class AuthenticationProvider with ChangeNotifier {
  Session? currentSession;
  final BuildContext context;
  final supabase = Supabase.instance.client;
  final String redirectTo = 'io.supabase.tourlytour://login-callback/';

  late ConnectivityProvider connectivity;
  late CurrentUserProvider currentUser;
  late DependenciesProvider dependencies;

  late String bucket;

  Props props = Props(data: [], initialData: []);

  AuthenticationProvider(this.context) {
    connectivity = context.read<ConnectivityProvider>();
    currentUser = context.read<CurrentUserProvider>();

    supabase.auth.onAuthStateChange.listen((data) async {
      AuthChangeEvent event = data.event;
      Session? session = data.session;

      if (event == AuthChangeEvent.initialSession) {
        currentSession = session;
        if (session != null) {
          final response = await supabase.rpc('signed_in', params: {
            'data': session.getParams(),
          });

          if (response != null) {
            await currentUser.putAll(response);
          }
        }

        props.setInitialSession(currentData: data);
        notifyListeners();
      }

      if (event == AuthChangeEvent.signedIn) {
        currentSession = session;
        if (session != null) {
          final response = await supabase.rpc('signed_in', params: {
            'data': session.getParams(),
          });

          if (response != null) {
            await currentUser.putAll(response);
          }
        }
        props.setSignedIn(currentData: data);
        notifyListeners();
      }

      if (event == AuthChangeEvent.signedOut) {
        currentSession = session;
        await currentUser.clearAll();
        props.setSignedOut(currentData: data);
        notifyListeners();
      }
    });
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

  bool get isAuthorized {
    try {
      if (currentSession == null || currentUser.id < 1) return false;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> signinWithGoogle() async {
    await supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: redirectTo,
    );
  }

  Future<void> signinWithFacebook() async {
    await supabase.auth.signInWithOAuth(
      OAuthProvider.facebook,
      redirectTo: redirectTo,
    );
  }

  Future<AuthResponse> signinWithEmail({
    String? email,
    String? phone,
    required String password,
    String? captchaToken,
  }) async {
    try {
      props.setProcessing();
      notifyListeners();

      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      AuthResponse response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
        captchaToken: captchaToken,
      );

      console.log(response, trace);

      return response;
    } on NoInternetException catch (error) {
      console.internet(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
      rethrow;
    } on AuthException catch (error) {
      console.authentication(error, trace);
      props.setAuthException(currentError: error.message.toString());
      notifyListeners();
      rethrow;
    } on CustomException catch (error) {
      console.custom(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
      rethrow;
    } catch (error) {
      console.error(error, trace);
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
      rethrow;
    }
  }

  Future<AuthResponse> signupWithEmail({
    String? email,
    String? phone,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    try {
      props.setProcessing();
      notifyListeners();

      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      AuthResponse response = await supabase.auth.signUp(
        data: data,
        email: email,
        password: password,
      );

      props.setNone();
      notifyListeners();

      return response;
    } on NoInternetException catch (error) {
      console.internet(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
      rethrow;
    } on AuthException catch (error) {
      console.authentication(error, trace);
      props.setAuthException(currentError: error.message.toString());
      notifyListeners();
      rethrow;
    } on CustomException catch (error) {
      console.custom(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
      rethrow;
    } catch (error) {
      console.error(error, trace);
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
      rethrow;
    }
  }

  Future<AuthResponse> verifyOTP({
    String? email,
    String? phone,
    String? token,
    OtpType type = OtpType.signup,
    String? redirectTo,
    String? captchaToken,
    String? tokenHash,
  }) async {
    try {
      props.setProcessing();
      notifyListeners();

      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      AuthResponse response = await supabase.auth.verifyOTP(
        email: email,
        token: token,
        type: type,
      );

      props.setNone();
      notifyListeners();

      return response;
    } on NoInternetException catch (error) {
      console.internet(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
      rethrow;
    } on AuthException catch (error) {
      console.authentication(error, trace);
      props.setAuthException(currentError: error.message.toString());
      notifyListeners();
      rethrow;
    } on CustomException catch (error) {
      console.custom(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
      rethrow;
    } catch (error) {
      console.error(error, trace);
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
      rethrow;
    }
  }

  Future<ResendResponse> resend({
    String? email,
    String? phone,
    OtpType type = OtpType.signup,
    String? emailRedirectTo,
    String? captchaToken,
  }) async {
    try {
      props.setResending();
      notifyListeners();

      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      ResendResponse response = await supabase.auth.resend(
        email: email,
        type: type,
      );
      props.setNone();
      notifyListeners();

      return response;
    } on NoInternetException catch (error) {
      console.internet(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
      rethrow;
    } on AuthException catch (error) {
      console.authentication(error, trace);
      props.setAuthException(currentError: error.message.toString());
      notifyListeners();
      rethrow;
    } on CustomException catch (error) {
      console.custom(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
      rethrow;
    } catch (error) {
      console.error(error, trace);
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> send({
    String? email,
    String? phone,
    OtpType type = OtpType.signup,
    String? emailRedirectTo,
    String? captchaToken,
  }) async {
    try {
      props.setSending();
      notifyListeners();

      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      await supabase.auth.resetPasswordForEmail(
        email!,
      );

      props.setNone();
      notifyListeners();

      return true;
    } on NoInternetException catch (error) {
      console.internet(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
      rethrow;
    } on AuthException catch (error) {
      console.authentication(error, trace);
      props.setAuthException(currentError: error.message.toString());
      notifyListeners();
      rethrow;
    } on CustomException catch (error) {
      console.custom(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
      rethrow;
    } catch (error) {
      console.error(error, trace);
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
      rethrow;
    }
  }

  Future<UserResponse> resetPassword({String? password}) async {
    try {
      props.setProcessing();
      notifyListeners();

      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      UserResponse response = await supabase.auth.updateUser(
        UserAttributes(
          password: password!,
        ),
      );

      props.setNone();
      notifyListeners();

      return response;
    } on NoInternetException catch (error) {
      console.internet(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
      rethrow;
    } on AuthException catch (error) {
      console.authentication(error, trace);
      props.setAuthException(currentError: error.message.toString());
      notifyListeners();
      rethrow;
    } on CustomException catch (error) {
      console.custom(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
      rethrow;
    } catch (error) {
      console.error(error, trace);
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> signOut() {
    return supabase.auth.signOut().then((res) {
      return true;
    });
  }

  void setNone() {
    props.setNone();
  }
}
