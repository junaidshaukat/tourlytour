import 'package:flutter/material.dart';
import '/core/app_export.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String provider = AuthProvider.email;
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
    auth = context.read<AuthenticationProvider>();
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
    // Props props = auth.props;
    // if (!props.isProcessing) {
    //   if (formKey.currentState!.validate()) {
    //     AuthForm body = AuthForm(
    //       provider: provider,
    //       event: AuthEvent.signup,
    //       email: emailController.text,
    //       phone: phoneController.text,
    //       name: usernameController.text,
    //       password: passwordController.text,
    //       passwordConfirm: passwordConfirmController.text,
    //     );
    //     bool response = await auth.signup(body);

    //     if (response && mounted) {
    //       NavigatorService.push(
    //         context,
    //         const OtpVerificationScreen(),
    //         arguments: body,
    //       );
    //     }
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                    controller: provider == AuthProvider.email
                        ? emailController
                        : phoneController,
                    hintText: provider == AuthProvider.email
                        ? "email".tr
                        : "phone_number".tr,
                    keyboardType: provider == AuthProvider.email
                        ? TextInputType.emailAddress
                        : TextInputType.phone,
                    validator: (key) {
                      return provider == AuthProvider.email
                          ? Validator.email(key)
                          : Validator.phone(key);
                    },
                    suffixConstraints: BoxConstraints(
                      maxHeight: 60.v,
                    ),
                    suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          if (provider == AuthProvider.email) {
                            provider = AuthProvider.phone;
                          } else {
                            provider = AuthProvider.email;
                          }
                        });
                      },
                      icon: CustomImageView(
                        imagePath: provider == AuthProvider.email
                            ? "phone".icon.svg
                            : "email".icon.svg,
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
                          return 'you_need_to_accept_terms'.tr;
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
