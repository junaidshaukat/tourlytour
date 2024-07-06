import 'package:flutter/material.dart';
import '/core/app_export.dart';

enum Sheet {
  initial,
  forgetPassword,
  signInWithEmail,
  signup,
  otpVerification,
  resetPassword
}

class AuthenticationService with ChangeNotifier {
  bool isSheetOpen = false;
  Sheet sheet = Sheet.initial;
  ImagePicker picker = ImagePicker();

  late AuthenticationProvider auth;
  late CurrentUserProvider currentUser;
  late ConnectivityProvider connectivity;
  late PersistentBottomSheetController controller;

  final BuildContext context;
  final supabase = Supabase.instance.client;

  String? errMsg;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool rememberMe = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

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

  void onSignin(BuildContext context) {
    sheet = Sheet.initial;
    rememberMe = false;
    obscurePassword = true;
    obscureConfirmPassword = true;

    emailController.clear();
    phoneController.clear();
    usernameController.clear();
    passwordController.clear();
    passwordConfirmController.clear();

    showBottomSheet(context);
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

  void showBottomSheet(BuildContext context) {
    controller = Scaffold.of(context).showBottomSheet(
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
                        child: body(setState, provider.props),
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

  dynamic body(setState, Props props) {
    if (props.isSignedIn) {
      Future.delayed(const Duration(milliseconds: 300), () {
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
      default:
        return const SizedBox();
    }
  }

  Widget initialSheet(StateSetter setState) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 12.v),
        Text(
          "welcome_back".tr,
          style: theme.textTheme.headlineSmall,
        ),
        Opacity(
          opacity: 0.8,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 30.h,
            ),
            child: Text(
              textAlign: TextAlign.center,
              "please_sign_in_to_continue".tr,
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyles.bodyLargeJaldiGray90001,
            ),
          ),
        ),
        SizedBox(height: 18.v),
        CustomElevatedButton(
          height: 50.v,
          text: "sign_in_with_email".tr,
          buttonStyle: CustomButtonStyles.fillPrimaryTL29,
          buttonTextStyle: CustomTextStyles.titleLargeWhite900,
          onPressed: () {
            setState(() {
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
        Text(
          "welcome_back".tr,
          style: theme.textTheme.headlineSmall,
        ),
        Opacity(
          opacity: 0.5,
          child: Container(
            width: 255.h,
            margin: EdgeInsets.only(
              left: 30.h,
              right: 34.h,
            ),
            child: Text(
              "please_enter_your_email_or_phone_number_to_continue".tr,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: CustomTextStyles.bodyLargeJaldiGray90001,
            ),
          ),
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
        CustomElevatedButton(
          height: 50.v,
          text: "signin".tr,
          buttonStyle: CustomButtonStyles.fillPrimaryTL29,
          buttonTextStyle: CustomTextStyles.titleLargeWhite900,
          onPressed: () {
            setState(() {});
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
        Text(
          "create_account".tr,
          style: theme.textTheme.headlineSmall,
        ),
        Opacity(
          opacity: 0.5,
          child: Container(
            width: 255.h,
            margin: EdgeInsets.only(
              left: 30.h,
              right: 34.h,
            ),
            child: Text(
              "please_enter_your_details_to_create_an_account".tr,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: CustomTextStyles.bodyLargeJaldiGray90001,
            ),
          ),
        ),
        SizedBox(height: 24.v),
        input(
          hintText: "username".tr,
          controller: usernameController,
          keyboardType: TextInputType.text,
          validator: (key) {
            return Validator.username(key);
          },
        ),
        SizedBox(height: 12.v),
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
        SizedBox(height: 12.v),
        Column(
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
                    value: false,
                    onChange: (value) {
                      setState(() {});
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "terms_condition".tr,
                    style: CustomTextStyles.bodyMediumJaldiBlue500.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            ),
            // Text(
            //   field.errorText ?? '',
            //   style: TextStyle(
            //     fontSize: 8.fSize,
            //     fontFamily: 'Inter',
            //     fontWeight: FontWeight.w400,
            //     color: Theme.of(context).colorScheme.error,
            //   ),
            // )
          ],
        ),
        SizedBox(height: 12.v),
        if (props.isProcessing)
          CustomElevatedButton(
            text: "",
            height: 50.v,
            leftIcon: CustomProgressButton(
              lable: 'processing'.tr,
              textStyle: CustomTextStyles.titleLargeWhite900,
            ),
            buttonStyle: CustomButtonStyles.fillPrimaryTL29,
            buttonTextStyle: CustomTextStyles.titleLargeWhite900,
          ),
        CustomElevatedButton(
          height: 50.v,
          text: "register_now".tr,
          buttonStyle: CustomButtonStyles.fillPrimaryTL29,
          buttonTextStyle: CustomTextStyles.titleLargeWhite900,
          onPressed: () {
            setState(() {
              props.setProcessing();
            });

            Future.delayed(const Duration(seconds: 5), () {
              setState(() {
                props.setNone();
                sheet = Sheet.otpVerification;
              });
            });
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
        Text(
          "forget_password".tr,
          style: theme.textTheme.headlineSmall,
        ),
        Opacity(
          opacity: 0.5,
          child: Container(
            width: 255.h,
            margin: EdgeInsets.only(
              left: 30.h,
              right: 34.h,
            ),
            child: Text(
              "please_enter_your_email_or_phone".tr,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: CustomTextStyles.bodyLargeJaldiGray90001,
            ),
          ),
        ),
        SizedBox(height: 24.v),
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
        CustomElevatedButton(
          height: 50.v,
          text: "send_code".tr,
          buttonStyle: CustomButtonStyles.fillPrimaryTL29,
          buttonTextStyle: CustomTextStyles.titleLargeWhite900,
          onPressed: () {
            setState(() {
              sheet = Sheet.resetPassword;
            });
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
        Text(
          "reset_password".tr,
          style: theme.textTheme.headlineSmall,
        ),
        Opacity(
          opacity: 0.5,
          child: Container(
            width: 255.h,
            margin: EdgeInsets.only(
              left: 30.h,
              right: 34.h,
            ),
            child: Text(
              "please_enter_your_new_password".tr,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: CustomTextStyles.bodyLargeJaldiGray90001,
            ),
          ),
        ),
        SizedBox(height: 24.v),
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
        Column(
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
                    value: false,
                    onChange: (value) {
                      setState(() {});
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "terms_condition".tr,
                    style: CustomTextStyles.bodyMediumJaldiBlue500.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            ),
            // Text(
            //   field.errorText ?? '',
            //   style: TextStyle(
            //     fontSize: 8.fSize,
            //     fontFamily: 'Inter',
            //     fontWeight: FontWeight.w400,
            //     color: Theme.of(context).colorScheme.error,
            //   ),
            // )
          ],
        ),
        SizedBox(height: 12.v),
        CustomElevatedButton(
          height: 50.v,
          text: "reset_password".tr,
          buttonStyle: CustomButtonStyles.fillPrimaryTL29,
          buttonTextStyle: CustomTextStyles.titleLargeWhite900,
          onPressed: () {
            setState(() {
              sheet = Sheet.otpVerification;
            });
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
        Text(
          "enter_otp".tr,
          style: theme.textTheme.headlineSmall,
        ),
        SizedBox(height: 1.v),
        Text(
          "we_will_send_you".tr,
          textAlign: TextAlign.center,
          style: CustomTextStyles.bodyLargeJaldiGray90001,
        ),
        SizedBox(height: 12.v),
        CustomPinCodeTextField(
          length: 6,
          context: context,
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

              if (props.isSending) {
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
                onTap: () {},
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
              if (props.isError) {
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
                      onPressed: () {},
                    )
                  ],
                );
              }

              return CustomElevatedButton(
                height: 50.v,
                text: "submit_code".tr,
                buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                onPressed: () {},
              );
            }
          },
        ),
        SizedBox(height: 12.v),
      ],
    );
  }
}
