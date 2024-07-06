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
        props.setInitialSession(currentData: data);
        notifyListeners();
      }

      if (event == AuthChangeEvent.signedIn) {
        currentSession = session;
        props.setSignedIn(currentData: data);
        notifyListeners();
      }

      if (event == AuthChangeEvent.signedOut) {
        currentSession = session;
        props.setSignedOut(currentData: data);
        notifyListeners();
      }

      // if (event == AuthChangeEvent.initialSession) {
      //   if (session != null) {
      //     notifyListeners();
      //   }
      // }

      // if (event == AuthChangeEvent.mfaChallengeVerified) {
      //   if (session != null) {
      //     notifyListeners();
      //   }
      // }

      // if (event == AuthChangeEvent.passwordRecovery) {
      //   if (session != null) {
      //     notifyListeners();
      //   }
      // }

      // if (event == AuthChangeEvent.signedIn) {
      //   if (session != null) {
      //     User user = session.user;
      //     AppMetadata appMetadata = AppMetadata.fromJson(user.appMetadata);
      //     UserMetadata userMetaData = UserMetadata.fromJson(user.userMetadata);

      //     await currentUser.put('Uuid', user.id);
      //     await currentUser.put('app_meta_data', user.appMetadata);
      //     await currentUser.put('user_meta_data', user.userMetadata);

      //     Users users =
      //         Users.fromMetadata(currentUser.uuid, appMetadata, userMetaData);
      //     bool exist = await currentUser.find(currentUser.uuid);
      //     if (exist) {
      //       await currentUser.update(currentUser.uuid, users);
      //     } else {
      //       await currentUser.create(currentUser.uuid, users);
      //     }

      //     if (appMetadata.isFacebook || appMetadata.isGoogle) {
      //       NavigatorService.popAndPushNamed(AppRoutes.splash);
      //     }

      //     notifyListeners();
      //   }
      // }

      // if (event == AuthChangeEvent.signedOut) {
      //   bool signedOut = await currentUser.signedOut();
      //   if (signedOut) {
      //     NavigatorService.popAndPushNamed(AppRoutes.splash);
      //     notifyListeners();
      //   }
      // }

      // if (event == AuthChangeEvent.tokenRefreshed) {
      //   if (session != null) {
      //     notifyListeners();
      //   }
      // }

      // if (event == AuthChangeEvent.userDeleted) {
      //   await currentUser.signedOut();
      //   NavigatorService.popAndPushNamed(AppRoutes.splash);
      //   notifyListeners();
      // }

      // if (event == AuthChangeEvent.userUpdated) {
      //   if (session != null) {
      //     User user = session.user;
      //     AppMetadata appMetadata = AppMetadata.fromJson(user.appMetadata);
      //     UserMetadata userMetaData = UserMetadata.fromJson(user.userMetadata);

      //     await currentUser.put('Uuid', user.id);
      //     await currentUser.put('app_meta_data', user.appMetadata);
      //     await currentUser.put('user_meta_data', user.userMetadata);

      //     Users users =
      //         Users.fromMetadata(currentUser.uuid, appMetadata, userMetaData);

      //     bool exist = await currentUser.find(currentUser.uuid);
      //     if (exist) {
      //       await currentUser.update(currentUser.uuid, users);
      //     } else {
      //       await currentUser.create(currentUser.uuid, users);
      //     }

      //     await currentUser.onReady();

      //     notifyListeners();
      //   }
      // }
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
        phone: phone,
        password: password,
        captchaToken: captchaToken,
      );

      if (response.session != null) {
        return response;
      } else {
        throw CustomException();
      }
    } on NoInternetException catch (error) {
      console.internet(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
      rethrow;
    } on AuthException catch (error) {
      console.authentication(error, trace);
      props.setUnauthorized(currentError: error.message.toString());
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

  // Future<bool> signin(AuthForm body) async {
  //   try {
  //     props.setProcessing();
  //     notifyListeners();

  //     if (!connectivity.isConnected) {
  //       throw NoInternetException();
  //     }

  //     AuthResponse response = body.provider == AuthProvider.email
  //         ? await supabase.auth.signInWithPassword(
  //             email: body.email,
  //             password: body.password ?? '',
  //           )
  //         : await supabase.auth.signInWithPassword(
  //             phone: body.phone,
  //             password: body.password ?? '',
  //           );

  //     if (response.session != null) {
  //       props.setSuccess();
  //       notifyListeners();
  //       return true;
  //     } else {
  //       throw CustomException();
  //     }
  //   } on NoInternetException catch (error) {
  //     console.internet(error, trace);
  //     props.setError(currentError: error.toString());
  //     notifyListeners();
  //     return false;
  //   } on AuthException catch (error) {
  //     console.authentication(error, trace);
  //     props.setUnauthorized(currentError: error.message.toString());
  //     notifyListeners();
  //     return false;
  //   } on CustomException catch (error) {
  //     console.custom(error, trace);
  //     props.setError(currentError: error.toString());
  //     notifyListeners();
  //     return false;
  //   } catch (error) {
  //     console.error(error, trace);
  //     props.setError(currentError: "something_went_wrong".tr);
  //     notifyListeners();
  //     return false;
  //   }
  // }

  // Future<bool> signup(AuthForm body) async {
  //   try {
  //     props.setProcessing();
  //     notifyListeners();

  //     if (!connectivity.isConnected) {
  //       throw NoInternetException();
  //     }

  //     AuthResponse response = body.provider == AuthProvider.email
  //         ? await supabase.auth.signUp(
  //             email: body.email,
  //             password: body.password ?? '',
  //             data: {
  //               "email": body.email,
  //               "full_name": body.name,
  //               "name": body.name,
  //               "phone": body.phone,
  //               "provider": body.provider,
  //             },
  //           )
  //         : await supabase.auth.signUp(
  //             phone: body.phone,
  //             password: body.password ?? '',
  //             data: {
  //               "email": body.email,
  //               "full_name": body.name,
  //               "name": body.name,
  //               "phone": body.phone,
  //               "provider": body.provider,
  //             },
  //           );

  //     if (response.user != null) {
  //       props.setSuccess();
  //       notifyListeners();
  //       return true;
  //     } else {
  //       throw CustomException();
  //     }
  //   } on NoInternetException catch (error) {
  //     console.internet(error, trace);
  //     props.setError(currentError: error.toString());
  //     notifyListeners();
  //     return false;
  //   } on AuthException catch (error) {
  //     console.authentication(error, trace);
  //     props.setUnauthorized(currentError: error.message.toString());
  //     notifyListeners();
  //     return false;
  //   } on CustomException catch (error) {
  //     console.custom(error, trace);
  //     props.setError(currentError: error.toString());
  //     notifyListeners();
  //     return false;
  //   } catch (error) {
  //     console.error(error, trace);
  //     props.setError(currentError: "something_went_wrong".tr);
  //     notifyListeners();
  //     return false;
  //   }
  // }

  // Future<bool> verifyOtp({
  //   required AuthForm body,
  //   required String token,
  // }) async {
  //   try {
  //     props.setProcessing();
  //     notifyListeners();

  //     if (!connectivity.isConnected) {
  //       throw NoInternetException();
  //     }

  //     if (body.event == AuthEvent.signup) {
  //       AuthResponse response = body.provider == AuthProvider.email
  //           ? await supabase.auth.verifyOTP(
  //               email: body.email,
  //               token: token,
  //               type: OtpType.signup,
  //             )
  //           : await supabase.auth.verifyOTP(
  //               phone: body.phone,
  //               token: token,
  //               type: OtpType.signup,
  //             );

  //       if (response.session != null) {
  //         props.setSuccess();
  //         notifyListeners();
  //         return true;
  //       } else {
  //         throw CustomException();
  //       }
  //     }

  //     if (body.event == AuthEvent.forgetPassword) {
  //       AuthResponse response = body.provider == AuthProvider.email
  //           ? await supabase.auth.verifyOTP(
  //               email: body.email,
  //               token: token,
  //               type: OtpType.recovery,
  //             )
  //           : await supabase.auth.verifyOTP(
  //               phone: body.phone,
  //               token: token,
  //               type: OtpType.recovery,
  //             );

  //       if (response.session != null) {
  //         props.setSuccess();
  //         notifyListeners();
  //         return true;
  //       } else {
  //         throw CustomException();
  //       }
  //     }

  //     if (body.event == AuthEvent.update) {
  //       AuthResponse response = body.provider == AuthProvider.email
  //           ? await supabase.auth.verifyOTP(
  //               email: body.email,
  //               token: token,
  //               type: OtpType.email,
  //             )
  //           : await supabase.auth.verifyOTP(
  //               phone: body.phone,
  //               token: token,
  //               type: OtpType.sms,
  //             );

  //       if (response.session != null) {
  //         props.setSuccess();
  //         notifyListeners();
  //         return true;
  //       } else {
  //         throw CustomException();
  //       }
  //     }

  //     throw CustomException();
  //   } on NoInternetException catch (error) {
  //     console.internet(error, trace);
  //     props.setError(currentError: error.toString());
  //     notifyListeners();
  //     return false;
  //   } on CustomException catch (error) {
  //     console.custom(error, trace);
  //     props.setError(currentError: error.toString());
  //     notifyListeners();
  //     return false;
  //   } on AuthException catch (error) {
  //     console.authentication(error, trace);
  //     props.setUnauthorized(currentError: error.message.toString());
  //     notifyListeners();
  //     return false;
  //   } catch (error) {
  //     console.error(error, trace);
  //     props.setError(currentError: "something_went_wrong".tr);
  //     notifyListeners();
  //     return false;
  //   }
  // }

  // Future<bool> sendOTP(AuthForm body) async {
  //   try {
  //     props.setSending();
  //     notifyListeners();

  //     if (!connectivity.isConnected) {
  //       throw NoInternetException();
  //     }

  //     if (body.event == AuthEvent.signup) {
  //       ResendResponse response = body.provider == AuthProvider.email
  //           ? await supabase.auth.resend(
  //               email: body.email,
  //               type: OtpType.signup,
  //             )
  //           : await supabase.auth.resend(
  //               phone: body.phone,
  //               type: OtpType.signup,
  //             );

  //       if (response.messageId != null) {
  //         props.setSuccess();
  //         notifyListeners();
  //         return true;
  //       }

  //       props.setSuccess();
  //       notifyListeners();
  //       return true;
  //     }

  //     if (body.event == AuthEvent.forgetPassword) {
  //       if (body.provider == AuthProvider.email) {
  //         await supabase.auth.resetPasswordForEmail(
  //           body.email ?? "",
  //           redirectTo: redirectTo,
  //         );
  //         props.setSuccess();
  //         notifyListeners();
  //         return true;
  //       } else if (body.provider == AuthProvider.phone) {
  //         await supabase.auth.resetPasswordForEmail(
  //           body.email ?? "",
  //           redirectTo: redirectTo,
  //         );
  //         props.setSuccess();
  //         notifyListeners();
  //         return true;
  //       }

  //       props.setSuccess();
  //       notifyListeners();
  //       return false;
  //     }

  //     if (body.event == AuthEvent.update) {
  //       ResendResponse response = body.provider == AuthProvider.email
  //           ? await supabase.auth.resend(
  //               email: body.email,
  //               type: OtpType.signup,
  //             )
  //           : await supabase.auth.resend(
  //               phone: body.phone,
  //               type: OtpType.sms,
  //             );

  //       if (response.messageId != null) {
  //         props.setSuccess();
  //         notifyListeners();
  //         return true;
  //       }

  //       props.setSuccess();
  //       notifyListeners();
  //       return true;
  //     }

  //     throw CustomException();
  //   } on NoInternetException catch (error) {
  //     console.internet(error, trace);
  //     props.setError(currentError: error.toString());
  //     notifyListeners();
  //     return false;
  //   } on CustomException catch (error) {
  //     console.custom(error, trace);
  //     props.setError(currentError: error.toString());
  //     notifyListeners();
  //     return false;
  //   } on AuthException catch (error) {
  //     console.authentication(error, trace);
  //     props.setUnauthorized(currentError: error.message.toString());
  //     notifyListeners();
  //     return false;
  //   } catch (error) {
  //     console.error(error, trace);
  //     props.setError(currentError: "something_went_wrong".tr);
  //     notifyListeners();
  //     return false;
  //   }
  // }

  // Future<bool> forgetPassword(AuthForm body) async {
  //   try {
  //     props.setProcessing();
  //     notifyListeners();

  //     if (!connectivity.isConnected) {
  //       throw NoInternetException();
  //     }

  //     if (body.provider == AuthProvider.email) {
  //       await supabase.auth.resetPasswordForEmail(
  //         body.email ?? "",
  //         redirectTo: redirectTo,
  //       );
  //       props.setSuccess();
  //       notifyListeners();
  //       return true;
  //     } else if (body.provider == AuthProvider.phone) {
  //       await supabase.auth.resetPasswordForEmail(
  //         body.email ?? "",
  //         redirectTo: redirectTo,
  //       );
  //       props.setSuccess();
  //       notifyListeners();
  //       return true;
  //     }

  //     props.setSuccess();
  //     notifyListeners();
  //     return false;
  //   } on NoInternetException catch (error) {
  //     console.internet(error, trace);
  //     props.setError(currentError: error.toString());
  //     notifyListeners();
  //     return false;
  //   } on CustomException catch (error) {
  //     console.custom(error, trace);
  //     props.setError(currentError: error.toString());
  //     notifyListeners();
  //     return false;
  //   } on AuthException catch (error) {
  //     console.authentication(error, trace);
  //     props.setUnauthorized(currentError: error.message.toString());
  //     notifyListeners();
  //     return false;
  //   } catch (error) {
  //     console.error(error, trace);
  //     props.setError(currentError: "something_went_wrong".tr);
  //     notifyListeners();
  //     return false;
  //   }
  // }

  // Future<bool> resetPassword(String? password) async {
  //   try {
  //     props.setProcessing();
  //     notifyListeners();

  //     if (!connectivity.isConnected) {
  //       throw NoInternetException();
  //     }

  //     UserResponse response = await supabase.auth.updateUser(UserAttributes(
  //       password: password,
  //     ));

  //     if (response.user != null) {
  //       props.setSuccess();
  //       notifyListeners();
  //       return true;
  //     } else {
  //       props.setSuccess();
  //       notifyListeners();
  //       return false;
  //     }
  //   } on NoInternetException catch (error) {
  //     console.internet(error, trace);
  //     props.setError(currentError: error.toString());
  //     notifyListeners();
  //     return false;
  //   } on CustomException catch (error) {
  //     console.custom(error, trace);
  //     props.setError(currentError: error.toString());
  //     notifyListeners();
  //     return false;
  //   } on AuthException catch (error) {
  //     console.authentication(error, trace);
  //     props.setUnauthorized(currentError: error.message.toString());
  //     notifyListeners();
  //     return false;
  //   } catch (error) {
  //     console.error(error, trace);
  //     props.setError(currentError: "something_went_wrong".tr);
  //     notifyListeners();
  //     return false;
  //   }
  // }

  // Future<bool> onUpdateEmail(String? email) async {
  //   try {
  //     props.setProcessing();
  //     notifyListeners();

  //     if (!connectivity.isConnected) {
  //       throw NoInternetException();
  //     }

  //     UserResponse response = await supabase.auth.updateUser(
  //       UserAttributes(
  //         email: email,
  //       ),
  //     );
  //     if (response.user != null) {
  //       props.setSuccess();
  //       notifyListeners();
  //       return true;
  //     } else {
  //       props.setSuccess();
  //       notifyListeners();
  //       return false;
  //     }
  //   } on NoInternetException catch (error) {
  //     console.internet(error, trace);
  //     props.setError(currentError: error.toString());
  //     notifyListeners();
  //     return false;
  //   } on CustomException catch (error) {
  //     console.custom(error, trace);
  //     props.setError(currentError: error.toString());
  //     notifyListeners();
  //     return false;
  //   } on AuthException catch (error) {
  //     console.authentication(error, trace);
  //     props.setUnauthorized(currentError: error.message.toString());
  //     notifyListeners();
  //     return false;
  //   } catch (error) {
  //     console.error(error, trace);
  //     props.setError(currentError: "something_went_wrong".tr);
  //     notifyListeners();
  //     return false;
  //   }
  // }

  // Future<bool> onUpdatePhone(String? phone) async {
  //   try {
  //     props.setProcessing();
  //     notifyListeners();

  //     if (!connectivity.isConnected) {
  //       throw NoInternetException();
  //     }

  //     UserResponse response = await supabase.auth.updateUser(UserAttributes(
  //       phone: phone,
  //     ));

  //     if (response.user != null) {
  //       props.setSuccess();
  //       notifyListeners();
  //       return true;
  //     } else {
  //       props.setSuccess();
  //       notifyListeners();
  //       return false;
  //     }
  //   } on NoInternetException catch (error) {
  //     console.internet(error, trace);
  //     props.setError(currentError: error.toString());
  //     notifyListeners();
  //     return false;
  //   } on CustomException catch (error) {
  //     console.custom(error, trace);
  //     props.setError(currentError: error.toString());
  //     notifyListeners();
  //     return false;
  //   } on AuthException catch (error) {
  //     console.authentication(error, trace);
  //     props.setUnauthorized(currentError: error.message.toString());
  //     notifyListeners();
  //     return false;
  //   } catch (error) {
  //     console.error(error, trace);
  //     props.setError(currentError: "something_went_wrong".tr);
  //     notifyListeners();
  //     return false;
  //   }
  // }

  // Future<bool> updateUserMetadata(Object? data) async {
  //   try {
  //     props.setProcessing();
  //     notifyListeners();

  //     if (!connectivity.isConnected) {
  //       throw NoInternetException();
  //     }

  //     UserResponse response = await supabase.auth.updateUser(
  //       UserAttributes(
  //         data: data,
  //       ),
  //     );

  //     if (response.user != null) {
  //       props.setSuccess();
  //       notifyListeners();
  //       return true;
  //     } else {
  //       props.setSuccess();
  //       notifyListeners();
  //       return false;
  //     }
  //   } on NoInternetException catch (error) {
  //     console.internet(error, trace);
  //     props.setError(currentError: error.toString());
  //     notifyListeners();
  //     return false;
  //   } on CustomException catch (error) {
  //     console.custom(error, trace);
  //     props.setError(currentError: error.toString());
  //     notifyListeners();
  //     return false;
  //   } on AuthException catch (error) {
  //     console.authentication(error, trace);
  //     props.setUnauthorized(currentError: error.message.toString());
  //     notifyListeners();
  //     return false;
  //   } catch (error) {
  //     console.error(error, trace);
  //     props.setError(currentError: "something_went_wrong".tr);
  //     notifyListeners();
  //     return false;
  //   }
  // }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}
