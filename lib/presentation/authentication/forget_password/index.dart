import 'package:flutter/material.dart';
import '/core/app_export.dart';

export './reset_password.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  ForgetPasswordScreenState createState() => ForgetPasswordScreenState();
}

class ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  late AuthenticationProvider auth;
  String provider = AuthProvider.email;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

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
        AuthForm body = AuthForm(
          provider: provider,
          event: AuthEvent.forgetPassword,
          email: emailController.text,
          phone: phoneController.text,
        );

        bool response = await auth.forgetPassword(body);
        if (response && mounted) {
          NavigatorService.push(context, const OtpVerificationScreen(),
              arguments: body);
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
              padding: EdgeInsets.only(
                left: 37.h,
                top: 68.v,
                right: 37.h,
              ),
              child: Column(
                children: [
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
                  SizedBox(height: 35.v),
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
                        size: 22.adaptSize,
                        imagePath: provider == AuthProvider.email
                            ? "phone"
                            : "email".icon.svg,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.v),
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
                                text: "send_code".tr,
                                buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                                buttonTextStyle:
                                    CustomTextStyles.titleLargeBlack900,
                                onPressed: onPressed,
                              )
                            ],
                          );
                        }

                        return CustomElevatedButton(
                          height: 50.v,
                          text: "send_code".tr,
                          buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                          buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                          onPressed: onPressed,
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
