import 'package:flutter/material.dart';
import '/core/app_export.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  bool preloader = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool readme = false;
  bool isShowPassword = true;
  bool isShowConfirmPassword = true;
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  late AuthenticationProvider auth;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      auth = context.read<AuthenticationProvider>();

      setState(() {
        preloader = false;
      });
    });
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

  Future<void> onPressed() async {
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
          NavigatorService.push(
            context,
            const OtpVerificationScreen(),
            arguments: {'event': Event.signup, 'email': emailController.text},
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Preloader(
      preloader: preloader,
      child: Scaffold(
        key: scaffoldKey,
        appBar: CustomAppBar(
          centerTitle: false,
          title: Padding(
            padding: EdgeInsets.only(left: 16.h),
            child: AppbarTitle(
              text: "".tr,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.h,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: CustomImageView(
                    size: 34.adaptSize,
                    imagePath: "arrow_back".icon.svg,
                  ),
                  onPressed: () {
                    NavigatorService.goBack();
                  },
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: formKey,
            child: Container(
              width: double.maxFinite,
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
                  SizedBox(height: 12.v),
                  Text(
                    "create_account".tr,
                    style: theme.textTheme.headlineSmall,
                  ),
                  SizedBox(height: 27.v),
                  input(
                    controller: usernameController,
                    hintText: "username".tr,
                    keyboardType: TextInputType.emailAddress,
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
                  input(
                    hintText: "confirm_password".tr,
                    obscureText: isShowConfirmPassword,
                    controller: passwordConfirmController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                    suffixConstraints: BoxConstraints(
                      maxHeight: 60.v,
                    ),
                    validator: (key) {
                      return Validator.confirmPassword(
                        key,
                        passwordController.text,
                      );
                    },
                    suffix: IconButton(
                      onPressed: () {
                        if (isShowConfirmPassword) {
                          setState(() {
                            isShowConfirmPassword = false;
                          });
                        } else {
                          setState(() {
                            isShowConfirmPassword = true;
                          });
                        }
                      },
                      icon: CustomImageView(
                        imagePath: isShowConfirmPassword == false
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
                    child: FormField<bool>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (!readme) {
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
                                    value: readme,
                                    onChange: (value) {
                                      setState(() {
                                        readme = value;
                                        field.didChange(value);
                                      });
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    "terms_condition".tr,
                                    style: CustomTextStyles
                                        .bodyMediumJaldiBlue500
                                        .copyWith(
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
                                text: "register_now".tr,
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
                          text: "register_now".tr,
                          buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                          buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                          onPressed: onPressed,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
