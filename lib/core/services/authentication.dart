import 'package:flutter/material.dart';
import '/core/app_export.dart';

enum Sheet {
  none,
  initial,
  forgetPassword,
  signInWithEmail,
  signup,
  otpVerification,
  resetPassword,
  update
}

enum Event { none, signup, recovery, update }

class AuthenticationService with ChangeNotifier {
  bool isSheetOpen = false;
  Sheet sheet = Sheet.initial;
  Sheet prevScreen = Sheet.none;
  Event event = Event.none;

  ImagePicker picker = ImagePicker();
  Session? session;

  late AuthenticationProvider auth;
  late CurrentUserProvider currentUser;
  late DependenciesProvider dependencies;
  late ConnectivityProvider connectivity;
  late PersistentBottomSheetController controller;

  final BuildContext context;
  final supabase = Supabase.instance.client;

  String? errMsg;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool agree = false;
  bool rememberMe = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  TextEditingController tokenController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  Props props = Props(data: [], initialData: []);

  AuthenticationService(this.context) {
    auth = context.read<AuthenticationProvider>();
    currentUser = context.read<CurrentUserProvider>();
    connectivity = context.read<ConnectivityProvider>();
    dependencies = context.read<DependenciesProvider>();
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

  void onSignIn({Function(AuthResponse)? callback}) {
    Props props = auth.props;
    if (!props.isProcessing) {
      if (formKey.currentState!.validate()) {
        auth
            .signinWithEmail(
          email: emailController.text,
          password: passwordController.text,
        )
            .then((response) {
          if (callback != null) callback(response);
        });
      }
    }
  }

  void onRegisterNow({Function(AuthResponse)? callback}) {
    Props props = auth.props;
    if (!props.isProcessing) {
      if (formKey.currentState!.validate()) {
        auth.signupWithEmail(
          email: emailController.text,
          phone: phoneController.text,
          password: passwordController.text,
          data: {
            'full_name': usernameController.text,
          },
        ).then((response) {
          if (callback != null) callback(response);
        });
      }
    }
  }

  void onSendOTP({Function(dynamic)? callback}) {
    Props props = auth.props;
    if (!props.isProcessing) {
      if (event == Event.signup) {
        auth.resend(email: emailController.text).then((response) {
          if (callback != null) callback(response);
        });
      }

      if (event == Event.recovery) {
        auth.send(email: emailController.text).then((response) {
          if (callback != null) callback(response);
        });
      }
    }
  }

  void onVeifyOTP({Function(AuthResponse)? callback}) {
    Props props = auth.props;
    if (!props.isProcessing) {
      if (event == Event.signup) {
        auth
            .verifyOTP(
          email: emailController.text,
          token: tokenController.text,
          type: OtpType.signup,
        )
            .then((response) {
          if (callback != null) callback(response);
        });
      }

      if (event == Event.recovery) {
        auth
            .verifyOTP(
          email: emailController.text,
          token: tokenController.text,
          type: OtpType.recovery,
        )
            .then((response) {
          if (callback != null) callback(response);
        });
      }
    }
  }

  void onResetPassword({Function(UserResponse)? callback}) {
    Props props = auth.props;
    if (!props.isProcessing) {
      if (formKey.currentState!.validate()) {
        auth.resetPassword(password: passwordController.text).then((response) {
          if (callback != null) callback(response);
        });
      }
    }
  }

  void onUpdateName({Function(dynamic)? callback}) {
    Props props = auth.props;
    if (!props.isProcessing) {
      if (formKey.currentState!.validate()) {
        auth.onUpdateName(usernameController.text).then((response) {
          if (callback != null) callback(response);
        });
      }
    }
  }

  void onUpdateEmail({Function(dynamic)? callback}) {
    Props props = auth.props;
    if (!props.isProcessing) {
      if (formKey.currentState!.validate()) {
        auth.onUpdateName(usernameController.text).then((response) {
          if (callback != null) callback(response);
        });
      }
    }
  }

  void onUpdatePhone({Function(dynamic)? callback}) {
    Props props = auth.props;
    if (!props.isProcessing) {
      if (formKey.currentState!.validate()) {
        auth.onUpdateName(usernameController.text).then((response) {
          if (callback != null) callback(response);
        });
      }
    }
  }

  void openBottomSheet({
    Event event = Event.none,
    Map<String, dynamic> params = const {},
  }) {
    session = supabase.auth.currentSession;
    auth.setNone();
    if (session == null && event == Event.none) {
      sheet = Sheet.initial;

      errMsg = null;
      agree = false;
      rememberMe = false;
      obscurePassword = true;
      obscureConfirmPassword = true;

      tokenController.clear();
      emailController.clear();
      phoneController.clear();
      usernameController.clear();
      passwordController.clear();
      passwordConfirmController.clear();

      showBottomSheet();
    } else if (event == Event.update) {
      sheet = Sheet.update;
      showBottomSheet(params: params);
    }
  }

  Widget input({
    TextEditingController? controller,
    String? hintText,
    TextInputType? keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    TextInputAction? textInputAction,
    Widget? suffix,
    BoxConstraints? suffixConstraints,
    bool obscureText = false,
  }) {
    return CustomTextFormField(
      hintText: hintText,
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      fillColor: appTheme.blue5001,
      hintStyle: theme.textTheme.titleLarge!,
      textInputAction: textInputAction,
      suffix: suffix,
      suffixConstraints: suffixConstraints,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 14.h,
        vertical: 12.v,
      ),
      borderDecoration: TextFormFieldStyleHelper.fillBlue,
    );
  }

  void showBottomSheet({Map<String, dynamic> params = const {}}) {
    controller = scaffoldKey.currentState!.showBottomSheet(
      enableDrag: true,
      backgroundColor: appTheme.amber100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.h),
        ),
      ),
      (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Consumer<AuthenticationProvider>(
              builder: (context, provider, child) {
                return SizedBox(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Container(
                        width: SizeUtils.width,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.h,
                        ),
                        child: body(setState, provider.props, params: params),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  dynamic body(setState, Props props,
      {Map<String, dynamic> params = const {}}) {
    if (props.isSignedOut) {
      Future.delayed(const Duration(milliseconds: 300), () async {
        await dependencies.onReady();
        controller.close();
      });
    }

    if (props.isSignedIn) {
      Future.delayed(const Duration(milliseconds: 300), () async {
        await dependencies.onReady();
        controller.close();
      });
    }

    if (props.isUserUpdated) {
      Future.delayed(const Duration(milliseconds: 300), () async {
        await dependencies.onReady();
        controller.close();
      });
    }

    switch (sheet) {
      case Sheet.initial:
        return initialSheet(setState);
      case Sheet.signup:
        return signupSheet(setState);
      case Sheet.signInWithEmail:
        return signInWithEmailSheet(setState);
      case Sheet.forgetPassword:
        return forgetPasswordSheet(setState);
      case Sheet.resetPassword:
        return resetPasswordSheet(setState);
      case Sheet.otpVerification:
        return otpVerificationSheet(setState);
      case Sheet.update:
        return updateProfile(setState, params);
      default:
        return const SizedBox();
    }
  }

  Widget sheetHeader({
    bool backward = false,
    String title = '',
    String description = '',
    void Function()? onBack,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (backward)
              InkWell(
                onTap: onBack,
                child: CustomImageView(
                  size: 24.adaptSize,
                  imagePath: "back_square".icon.svg,
                ),
              ),
            if (!backward) const SizedBox(),
            Text(
              title,
              style: theme.textTheme.headlineSmall,
            ),
            InkWell(
              onTap: () {
                controller.close();
              },
              child: CustomImageView(
                size: 24.adaptSize,
                imagePath: "close_square".icon.svg,
              ),
            ),
          ],
        ),
        Opacity(
          opacity: 0.8,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 30.h,
            ),
            child: Text(
              description,
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
              style: CustomTextStyles.bodyLargeJaldiGray90001,
            ),
          ),
        ),
      ],
    );
  }

  Widget initialSheet(StateSetter setState) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 12.v),
        sheetHeader(
          backward: false,
          title: "welcome_back".tr,
          description: "please_sign_in_to_continue".tr,
        ),
        SizedBox(height: 18.v),
        CustomElevatedButton(
          height: 50.v,
          text: "sign_in_with_email".tr,
          buttonStyle: CustomButtonStyles.fillPrimaryTL29,
          buttonTextStyle: CustomTextStyles.titleLargeWhite900,
          onPressed: () {
            setState(() {
              prevScreen = Sheet.initial;
              sheet = Sheet.signInWithEmail;
            });
          },
        ),
        SizedBox(height: 12.v),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 18.v,
                bottom: 14.v,
              ),
              child: SizedBox(
                width: 63.h,
                child: Divider(
                  color: appTheme.black900,
                ),
              ),
            ),
            Opacity(
              opacity: 0.5,
              child: Padding(
                padding: EdgeInsets.only(left: 15.h),
                child: Text(
                  "or".tr,
                  style: CustomTextStyles.titleLargeGray90001,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 18.v,
                bottom: 14.v,
              ),
              child: SizedBox(
                width: 78.h,
                child: Divider(
                  color: appTheme.black900,
                  indent: 15.h,
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 12.v),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44.adaptSize,
              height: 44.adaptSize,
              decoration: BoxDecoration(
                color: theme.colorScheme.onPrimaryContainer,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: appTheme.black900.withOpacity(0.25),
                    spreadRadius: 1.h,
                    blurRadius: 1.h,
                    offset: const Offset(0, 1),
                  )
                ],
              ),
              child: IconButton(
                onPressed: () async {
                  await context
                      .read<AuthenticationProvider>()
                      .signinWithGoogle();
                },
                icon: CustomImageView(
                  size: 30.adaptSize,
                  imagePath: 'google'.icon.svg,
                ),
              ),
            ),
            SizedBox(width: 12.v),
            Container(
              width: 44.adaptSize,
              height: 44.adaptSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.onPrimaryContainer,
                boxShadow: [
                  BoxShadow(
                    color: appTheme.black900.withOpacity(0.25),
                    spreadRadius: 1.h,
                    blurRadius: 1.h,
                    offset: const Offset(0, 1),
                  )
                ],
              ),
              child: IconButton(
                onPressed: () async {
                  await context
                      .read<AuthenticationProvider>()
                      .signinWithFacebook();
                },
                icon: CustomImageView(
                  size: 30.adaptSize,
                  imagePath: 'facebook'.icon.svg,
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 12.v),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: 0.7,
              child: Padding(
                padding: EdgeInsets.only(bottom: 1.v),
                child: Text(
                  "new_member".tr,
                  style: CustomTextStyles.bodyMediumJaldiBlack900_1,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  prevScreen = Sheet.initial;
                  sheet = Sheet.signup;
                });
              },
              child: Padding(
                padding: EdgeInsets.only(left: 4.h),
                child: Text(
                  "register_now".tr,
                  style: CustomTextStyles.bodyMediumJaldiBlue500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.v),
      ],
    );
  }

  Widget signInWithEmailSheet(StateSetter setState) {
    return Column(
      children: [
        SizedBox(height: 12.v),
        sheetHeader(
          title: "welcome_back".tr,
          description: "please_enter_your_email_or_phone_number_to_continue".tr,
          onBack: () async {
            if (prevScreen == Sheet.initial) {
              setState(() {
                sheet = Sheet.initial;
              });
            }
          },
        ),
        SizedBox(height: 18.v),
        input(
          controller: emailController,
          hintText: "email".tr,
          keyboardType: TextInputType.emailAddress,
          validator: (key) {
            return Validator.email(key);
          },
          suffixConstraints: BoxConstraints(
            maxHeight: 60.v,
          ),
          suffix: IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: CustomImageView(
              imagePath: "email".icon.svg,
            ),
          ),
        ),
        SizedBox(height: 12.v),
        input(
          hintText: "password".tr,
          obscureText: obscurePassword,
          controller: passwordController,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.visiblePassword,
          suffixConstraints: BoxConstraints(
            maxHeight: 60.v,
          ),
          validator: (key) {
            return Validator.password(key);
          },
          suffix: IconButton(
            onPressed: () {
              setState(() {
                obscurePassword = !obscurePassword;
              });
            },
            icon: CustomImageView(
              imagePath: obscurePassword == false
                  ? "eye_slash".icon.svg
                  : "eye".icon.svg,
            ),
          ),
        ),
        SizedBox(height: 12.v),
        Padding(
          padding: EdgeInsets.only(
            left: 5.h,
            right: 3.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 1.v),
                child: CustomCheckboxButton(
                  text: "remember_me".tr,
                  value: rememberMe,
                  onChange: (value) {
                    setState(() {
                      rememberMe = value;
                    });
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    prevScreen = Sheet.signInWithEmail;
                    sheet = Sheet.forgetPassword;
                  });
                },
                child: Text(
                  "forget_password?".tr,
                  style: CustomTextStyles.bodyMediumJaldiBlue500.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 12.v),
        Consumer<AuthenticationProvider>(
          builder: (BuildContext context, provider, Widget? child) {
            Props props = provider.props;
            if (props.isProcessing) {
              return CustomElevatedButton(
                text: "",
                height: 50.v,
                leftIcon: CustomProgressButton(
                  lable: 'processing'.tr,
                  textStyle: CustomTextStyles.titleLargeWhite900,
                ),
                buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                buttonTextStyle: CustomTextStyles.titleLargeWhite900,
              );
            } else {
              if (props.isError || props.isAuthException) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      props.error ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.fSize,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    SizedBox(height: 6.v),
                    CustomElevatedButton(
                      height: 50.v,
                      text: "signin".tr,
                      buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                      buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                      onPressed: () {
                        onSignIn(callback: (res) {});
                      },
                    )
                  ],
                );
              }

              return CustomElevatedButton(
                height: 50.v,
                text: "signin".tr,
                buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                onPressed: () {
                  onSignIn(callback: (res) {});
                },
              );
            }
          },
        ),
        SizedBox(height: 12.v),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44.adaptSize,
              height: 44.adaptSize,
              decoration: BoxDecoration(
                color: theme.colorScheme.onPrimaryContainer,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: appTheme.black900.withOpacity(0.25),
                    spreadRadius: 1.h,
                    blurRadius: 1.h,
                    offset: const Offset(0, 1),
                  )
                ],
              ),
              child: IconButton(
                onPressed: () async {
                  await context
                      .read<AuthenticationProvider>()
                      .signinWithGoogle();
                },
                icon: CustomImageView(
                  size: 30.adaptSize,
                  imagePath: 'google'.icon.svg,
                ),
              ),
            ),
            SizedBox(width: 12.h),
            Container(
              width: 44.adaptSize,
              height: 44.adaptSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.onPrimaryContainer,
                boxShadow: [
                  BoxShadow(
                    color: appTheme.black900.withOpacity(0.25),
                    spreadRadius: 1.h,
                    blurRadius: 1.h,
                    offset: const Offset(0, 1),
                  )
                ],
              ),
              child: IconButton(
                onPressed: () async {
                  await context
                      .read<AuthenticationProvider>()
                      .signinWithFacebook();
                },
                icon: CustomImageView(
                  size: 30.adaptSize,
                  imagePath: 'facebook'.icon.svg,
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 12.v),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: 0.7,
              child: Padding(
                padding: EdgeInsets.only(bottom: 1.v),
                child: Text(
                  "new_member".tr,
                  style: CustomTextStyles.bodyMediumJaldiBlack900_1,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  prevScreen = Sheet.signInWithEmail;
                  sheet = Sheet.signup;
                });
              },
              child: Padding(
                padding: EdgeInsets.only(left: 4.h),
                child: Text(
                  "register_now".tr,
                  style: CustomTextStyles.bodyMediumJaldiBlue500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.v),
      ],
    );
  }

  Widget signupSheet(StateSetter setState) {
    return Column(
      children: [
        SizedBox(height: 12.v),
        sheetHeader(
          title: "create_account".tr,
          description: "please_enter_your_details_to_create_an_account".tr,
        ),
        SizedBox(height: 18.v),
        input(
          hintText: "username".tr,
          controller: usernameController,
          keyboardType: TextInputType.text,
          validator: (key) {
            return Validator.username(key);
          },
        ),
        SizedBox(height: 8.v),
        input(
          hintText: "email".tr,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (key) {
            return Validator.email(key);
          },
          suffixConstraints: BoxConstraints(
            maxHeight: 60.v,
          ),
          suffix: IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: CustomImageView(
              imagePath: "email".icon.svg,
            ),
          ),
        ),
        SizedBox(height: 8.v),
        input(
          hintText: "password".tr,
          obscureText: obscurePassword,
          controller: passwordController,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.visiblePassword,
          suffixConstraints: BoxConstraints(
            maxHeight: 60.v,
          ),
          validator: (key) {
            return Validator.password(key);
          },
          suffix: IconButton(
            onPressed: () {
              setState(() {
                obscurePassword = !obscurePassword;
              });
            },
            icon: CustomImageView(
              imagePath: obscurePassword == false
                  ? "eye_slash".icon.svg
                  : "eye".icon.svg,
            ),
          ),
        ),
        SizedBox(height: 8.v),
        input(
          hintText: "confirm_password".tr,
          obscureText: obscureConfirmPassword,
          controller: passwordConfirmController,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.visiblePassword,
          suffixConstraints: BoxConstraints(
            maxHeight: 60.v,
          ),
          validator: (key) {
            return Validator.confirmPassword(key, passwordController.text);
          },
          suffix: IconButton(
            onPressed: () {
              if (obscureConfirmPassword) {
                setState(() {
                  obscureConfirmPassword = false;
                });
              } else {
                setState(() {
                  obscureConfirmPassword = true;
                });
              }
            },
            icon: CustomImageView(
              imagePath: obscureConfirmPassword == false
                  ? "eye_slash".icon.svg
                  : "eye".icon.svg,
            ),
          ),
        ),
        SizedBox(height: 8.v),
        Padding(
          padding: EdgeInsets.only(
            left: 5.h,
            right: 3.h,
          ),
          child: FormField<bool>(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (!agree) {
                return 'accept_terms'.tr;
              } else {
                return null;
              }
            },
            builder: (FormFieldState<bool> field) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 1.v),
                        child: CustomCheckboxButton(
                          text: "i_read_and_agree".tr,
                          value: agree,
                          onChange: (value) {
                            setState(() {
                              agree = value;
                              field.didChange(value);
                            });
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          "terms_condition".tr,
                          style:
                              CustomTextStyles.bodyMediumJaldiBlue500.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  ),
                  Text(
                    field.errorText ?? '',
                    style: TextStyle(
                      fontSize: 8.fSize,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  )
                ],
              );
            },
          ),
        ),
        SizedBox(height: 8.v),
        Consumer<AuthenticationProvider>(
          builder: (BuildContext context, provider, Widget? child) {
            Props props = provider.props;
            if (props.isProcessing) {
              return CustomElevatedButton(
                text: "",
                height: 50.v,
                leftIcon: CustomProgressButton(
                  lable: 'processing'.tr,
                  textStyle: CustomTextStyles.titleLargeWhite900,
                ),
                buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                buttonTextStyle: CustomTextStyles.titleLargeWhite900,
              );
            } else {
              if (props.isAuthException) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      props.error ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.fSize,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    SizedBox(height: 6.v),
                    CustomElevatedButton(
                      height: 50.v,
                      text: "register_now".tr,
                      buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                      buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                      onPressed: () {
                        event = Event.signup;
                        onRegisterNow(callback: (response) {
                          setState(() {
                            prevScreen = Sheet.signup;
                            sheet = Sheet.otpVerification;
                          });
                        });
                      },
                    )
                  ],
                );
              }

              return CustomElevatedButton(
                height: 50.v,
                text: "register_now".tr,
                buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                onPressed: () {
                  event = Event.signup;
                  onRegisterNow(callback: (response) {
                    setState(() {
                      prevScreen = Sheet.signup;
                      sheet = Sheet.otpVerification;
                    });
                  });
                },
              );
            }
          },
        ),
        SizedBox(height: 12.v),
      ],
    );
  }

  Widget forgetPasswordSheet(StateSetter setState) {
    return Column(
      children: [
        SizedBox(height: 12.v),
        sheetHeader(
          title: "forget_password".tr,
          description: "please_enter_your_email_or_phone".tr,
        ),
        SizedBox(height: 18.v),
        input(
          controller: emailController,
          hintText: "email".tr,
          keyboardType: TextInputType.emailAddress,
          validator: (key) {
            return Validator.email(key);
          },
          suffixConstraints: BoxConstraints(
            maxHeight: 60.v,
          ),
          suffix: IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: CustomImageView(
              imagePath: "email".icon.svg,
            ),
          ),
        ),
        SizedBox(height: 24.v),
        Consumer<AuthenticationProvider>(
          builder: (BuildContext context, provider, Widget? child) {
            Props props = provider.props;
            if (props.isSending) {
              return CustomElevatedButton(
                text: "",
                height: 50.v,
                leftIcon: CustomProgressButton(
                  lable: 'processing'.tr,
                  textStyle: CustomTextStyles.titleLargeWhite900,
                ),
                buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                buttonTextStyle: CustomTextStyles.titleLargeWhite900,
              );
            } else {
              if (props.isError || props.isAuthException) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      props.error ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.fSize,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    SizedBox(height: 6.v),
                    CustomElevatedButton(
                      height: 50.v,
                      text: "send_code".tr,
                      buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                      buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                      onPressed: () {
                        event = Event.recovery;
                        onSendOTP(callback: (res) {
                          setState(() {
                            prevScreen = Sheet.forgetPassword;
                            sheet = Sheet.otpVerification;
                          });
                        });
                      },
                    )
                  ],
                );
              }

              return CustomElevatedButton(
                height: 50.v,
                text: "send_code".tr,
                buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                onPressed: () {
                  event = Event.recovery;
                  onSendOTP(callback: (res) {
                    setState(() {
                      prevScreen = Sheet.forgetPassword;
                      sheet = Sheet.otpVerification;
                    });
                  });
                },
              );
            }
          },
        ),
        SizedBox(height: 12.v),
      ],
    );
  }

  Widget resetPasswordSheet(StateSetter setState) {
    return Column(
      children: [
        SizedBox(height: 12.v),
        sheetHeader(
          title: "reset_password".tr,
          description: "please_enter_your_new_password".tr,
        ),
        SizedBox(height: 18.v),
        input(
          hintText: "password".tr,
          obscureText: obscurePassword,
          controller: passwordController,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.visiblePassword,
          suffixConstraints: BoxConstraints(
            maxHeight: 60.v,
          ),
          validator: (key) {
            return Validator.password(key);
          },
          suffix: IconButton(
            onPressed: () {
              setState(() {
                obscurePassword = !obscurePassword;
              });
            },
            icon: CustomImageView(
              imagePath: obscurePassword == false
                  ? "eye_slash".icon.svg
                  : "eye".icon.svg,
            ),
          ),
        ),
        SizedBox(height: 12.v),
        input(
          hintText: "confirm_password".tr,
          obscureText: obscureConfirmPassword,
          controller: passwordConfirmController,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.visiblePassword,
          suffixConstraints: BoxConstraints(
            maxHeight: 60.v,
          ),
          validator: (key) {
            return Validator.password(key);
          },
          suffix: IconButton(
            onPressed: () {
              if (obscureConfirmPassword) {
                setState(() {
                  obscureConfirmPassword = false;
                });
              } else {
                setState(() {
                  obscureConfirmPassword = true;
                });
              }
            },
            icon: CustomImageView(
              imagePath: obscureConfirmPassword == false
                  ? "eye_slash".icon.svg
                  : "eye".icon.svg,
            ),
          ),
        ),
        SizedBox(height: 12.v),
        Consumer<AuthenticationProvider>(
          builder: (BuildContext context, provider, Widget? child) {
            Props props = provider.props;
            if (props.isProcessing) {
              return CustomElevatedButton(
                text: "",
                height: 50.v,
                leftIcon: CustomProgressButton(
                  lable: 'processing'.tr,
                  textStyle: CustomTextStyles.titleLargeWhite900,
                ),
                buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                buttonTextStyle: CustomTextStyles.titleLargeWhite900,
              );
            } else {
              if (props.isError || props.isAuthException) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      props.error ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.fSize,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    SizedBox(height: 6.v),
                    CustomElevatedButton(
                      height: 50.v,
                      text: "reset_password".tr,
                      buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                      buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                      onPressed: () {
                        onResetPassword(callback: (res) {
                          setState(() {
                            prevScreen = Sheet.initial;
                            sheet = Sheet.signInWithEmail;
                          });
                        });
                      },
                    )
                  ],
                );
              }

              return CustomElevatedButton(
                height: 50.v,
                text: "reset_password".tr,
                buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                onPressed: () {
                  onResetPassword(callback: (res) {
                    setState(() {
                      prevScreen = Sheet.initial;
                      sheet = Sheet.signInWithEmail;
                    });
                  });
                },
              );
            }
          },
        ),
        SizedBox(height: 12.v),
      ],
    );
  }

  Widget otpVerificationSheet(StateSetter setState) {
    return Column(
      children: [
        SizedBox(height: 12.v),
        sheetHeader(
          title: "enter_otp".tr,
          description: "we_will_send_you".tr,
        ),
        SizedBox(height: 18.v),
        CustomPinCodeTextField(
          length: 6,
          context: context,
          controller: tokenController,
          onChanged: (value) {},
          validator: (key) {
            return Validator.otp(key);
          },
        ),
        SizedBox(height: 12.v),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Opacity(
              opacity: 0.5,
              child: Text(
                "didn_t_received".tr,
                style: CustomTextStyles.bodyLargeJaldiGray90001,
              ),
            ),
            Consumer<AuthenticationProvider>(
                builder: (BuildContext context, provider, Widget? child) {
              Props props = provider.props;

              if (props.isResending || props.isSending) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 4.v),
                  child: SizedBox(
                    width: 60.h,
                    child: CustomProgressButton(
                      indicator: false,
                      lable: 'sending'.tr,
                      textStyle: CustomTextStyles.bodyMediumJaldiBlue500,
                    ),
                  ),
                );
              }

              return GestureDetector(
                onTap: () {
                  onSendOTP(callback: (res) {});
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 4.v),
                  child: Text(
                    "re_send_code".tr,
                    style: CustomTextStyles.bodyMediumJaldiBlue500.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
        SizedBox(height: 12.v),
        Consumer<AuthenticationProvider>(
          builder: (BuildContext context, provider, Widget? child) {
            Props props = provider.props;
            if (props.isProcessing) {
              return CustomElevatedButton(
                text: "",
                height: 50.v,
                leftIcon: CustomProgressButton(
                  lable: 'processing'.tr,
                  textStyle: CustomTextStyles.titleLargeWhite900,
                ),
                buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                buttonTextStyle: CustomTextStyles.titleLargeWhite900,
              );
            } else {
              if (props.isError || props.isAuthException) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      props.error ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.fSize,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    SizedBox(height: 6.v),
                    CustomElevatedButton(
                      height: 50.v,
                      text: "submit_code".tr,
                      buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                      buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                      onPressed: () {
                        onVeifyOTP(callback: (res) {
                          if (event == Event.recovery) {
                            setState(() {
                              prevScreen = Sheet.otpVerification;
                              sheet = Sheet.resetPassword;
                            });
                          }
                        });
                      },
                    )
                  ],
                );
              }

              return CustomElevatedButton(
                height: 50.v,
                text: "submit_code".tr,
                buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                onPressed: () {
                  onVeifyOTP(callback: (res) {
                    if (event == Event.recovery) {
                      setState(() {
                        prevScreen = Sheet.otpVerification;
                        sheet = Sheet.resetPassword;
                      });
                    }
                  });
                },
              );
            }
          },
        ),
        SizedBox(height: 12.v),
      ],
    );
  }

  Widget updateProfile(StateSetter setState, Map<String, dynamic> params) {
    if (params.containsKey('name')) {
      usernameController.text = params['name'];
    }

    if (params.containsKey('email')) {
      emailController.text = params['email'];
    }

    if (params.containsKey('phone')) {
      phoneController.text = params['phone'];
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.v),
        if (params.containsKey('name')) ...[
          sheetHeader(
            title: "update_user_profile".tr,
          ),
          Text(
            "name".tr,
            textAlign: TextAlign.left,
            style: theme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.v),
          input(
            hintText: params["name"],
            controller: usernameController,
            keyboardType: TextInputType.text,
            validator: (key) {
              return Validator.username(key);
            },
          ),
          SizedBox(height: 18.v),
          Consumer<AuthenticationProvider>(
            builder: (BuildContext context, provider, Widget? child) {
              Props props = provider.props;
              if (props.isProcessing) {
                return CustomElevatedButton(
                  text: "",
                  height: 50.v,
                  leftIcon: CustomProgressButton(
                    lable: 'processing'.tr,
                    textStyle: CustomTextStyles.titleLargeWhite900,
                  ),
                  buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                  buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                );
              } else {
                if (props.isError || props.isAuthException) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        props.error ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.fSize,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      SizedBox(height: 6.v),
                      CustomElevatedButton(
                        height: 50.v,
                        text: "update".tr,
                        buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                        buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                        onPressed: () {
                          onUpdateName(callback: (res) {
                            setState(() {});
                          });
                        },
                      )
                    ],
                  );
                }

                return CustomElevatedButton(
                  height: 50.v,
                  text: "update".tr,
                  buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                  buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                  onPressed: () {
                    onUpdateName(callback: (res) {
                      setState(() {});
                    });
                  },
                );
              }
            },
          ),
        ],
        if (params.containsKey('email')) ...[
          sheetHeader(
            title: "update_user_profile".tr,
          ),
          Text(
            "email".tr,
            textAlign: TextAlign.left,
            style: theme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.v),
          input(
            hintText: params["email"],
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (key) {
              return Validator.email(key);
            },
          ),
          SizedBox(height: 18.v),
          Consumer<AuthenticationProvider>(
            builder: (BuildContext context, provider, Widget? child) {
              Props props = provider.props;
              if (props.isProcessing) {
                return CustomElevatedButton(
                  text: "",
                  height: 50.v,
                  leftIcon: CustomProgressButton(
                    lable: 'processing'.tr,
                    textStyle: CustomTextStyles.titleLargeWhite900,
                  ),
                  buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                  buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                );
              } else {
                if (props.isError || props.isAuthException) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        props.error ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.fSize,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      SizedBox(height: 6.v),
                      CustomElevatedButton(
                        height: 50.v,
                        text: "update".tr,
                        buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                        buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                        onPressed: () {
                          onUpdateEmail(callback: (res) {
                            setState(() {});
                          });
                        },
                      )
                    ],
                  );
                }

                return CustomElevatedButton(
                  height: 50.v,
                  text: "update".tr,
                  buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                  buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                  onPressed: () {
                    onUpdateEmail(callback: (res) {
                      setState(() {});
                    });
                  },
                );
              }
            },
          ),
        ],
        SizedBox(height: 12.v),
      ],
    );
  }
}
