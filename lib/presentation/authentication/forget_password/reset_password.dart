import 'package:flutter/material.dart';
import '/core/app_export.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isShowPassword = true;
  bool isShowConfirmPassword = true;
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
    Props props = auth.props;
    if (!props.isProcessing) {
      if (formKey.currentState!.validate()) {
        bool response = await auth.resetPassword(passwordController.text);
        if (response) {
          NavigatorService.popAndPushNamed(AppRoutes.splash);
        }
      }
    }
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
                  SizedBox(height: 35.v),
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
                                text: "reset_password".tr,
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
                          text: "reset_password".tr,
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
