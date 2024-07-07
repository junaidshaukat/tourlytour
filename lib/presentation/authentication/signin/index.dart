import 'package:flutter/material.dart';
import '/core/app_export.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  bool preloader = true;
  bool rememberMe = false;
  bool isShowPassword = true;

  late AuthenticationProvider auth;
  late CurrentUserProvider currentUser;
  late DependenciesProvider dependencies;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      auth = context.read<AuthenticationProvider>();
      currentUser = context.read<CurrentUserProvider>();
      dependencies = context.read<DependenciesProvider>();

      setState(() {
        preloader = false;
      });
    });
  }

  Future<void> onPressed() async {
    Props props = auth.props;
    if (!props.isProcessing) {
      if (formKey.currentState!.validate()) {
        auth
            .signinWithEmail(
                email: emailController.text, password: passwordController.text)
            .then((response) {
          NavigatorService.pushNamedAndRemoveUntil(
            AppRoutes.splash,
          );
        });
      }
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

  @override
  Widget build(BuildContext context) {
    return Preloader(
      preloader: preloader,
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: formKey,
            child: Container(
              width: SizeUtils.width,
              padding: EdgeInsets.symmetric(
                horizontal: 36.h,
                vertical: 45.v,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 64.v,
                    width: 193.h,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10.v),
                            child: Text(
                              "tourly_tours".tr,
                              style:
                                  CustomTextStyles.titleLargePoppinsGray90002,
                            ),
                          ),
                        ),
                        CustomImageView(
                          width: 90.h,
                          height: 64.v,
                          imagePath: "logo".icon.svg,
                          alignment: Alignment.centerLeft,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 28.v),
                  Text(
                    "login".tr,
                    style: theme.textTheme.headlineSmall,
                  ),
                  SizedBox(height: 27.v),
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
                    obscureText: isShowPassword,
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
                        if (isShowPassword) {
                          setState(() {
                            isShowPassword = false;
                          });
                        } else {
                          setState(() {
                            isShowPassword = true;
                          });
                        }
                      },
                      icon: CustomImageView(
                        imagePath: isShowPassword == false
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
                            NavigatorService.push(
                                context, const ForgetPasswordScreen());
                          },
                          child: Text(
                            "forget_password?".tr,
                            style: CustomTextStyles.bodyMediumJaldiBlue500
                                .copyWith(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 44.v),
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
                                text: "login".tr,
                                buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                                buttonTextStyle:
                                    CustomTextStyles.titleLargeWhite900,
                                onPressed: onPressed,
                              )
                            ],
                          );
                        }

                        return CustomElevatedButton(
                          height: 50.v,
                          text: "login".tr,
                          buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                          buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                          onPressed: onPressed,
                        );
                      }
                    },
                  ),
                  SizedBox(height: 7.v),
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
                  SizedBox(height: 16.v),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50.adaptSize,
                        height: 50.adaptSize,
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
                            imagePath: 'google'.icon.svg,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.h),
                      Container(
                        width: 50.adaptSize,
                        height: 50.adaptSize,
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
                            imagePath: 'facebook'.icon.svg,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 31.v),
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
                          NavigatorService.push(context, const SignUpScreen());
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
                  SizedBox(height: 5.v)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
