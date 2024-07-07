import 'package:flutter/material.dart';
import '/core/app_export.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  OtpVerificationScreenState createState() => OtpVerificationScreenState();
}

class OtpVerificationScreenState extends State<OtpVerificationScreen> {
  bool preloader = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController tokenController = TextEditingController();

  late AuthenticationProvider auth;
  late Map<String, dynamic> body;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    body = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  }

  Future<void> onPressed() async {
    Props props = auth.props;
    if (!props.isProcessing) {
      if (formKey.currentState!.validate()) {
        if (body['event'] == Event.signup) {
          auth
              .verifyOTP(
            email: body['email'],
            token: tokenController.text,
            type: OtpType.signup,
          )
              .then((response) {
            NavigatorService.pushNamedAndRemoveUntil(
              AppRoutes.signin,
            );
          });
        }

        if (body['event'] == Event.recovery) {
          auth
              .verifyOTP(
            email: body['email'],
            token: tokenController.text,
            type: OtpType.recovery,
          )
              .then((response) {
            NavigatorService.push(
              context,
              const ResetPasswordScreen(),
            );
          });
        }
      }
    }
  }

  void onReSendOTP() {
    Props props = auth.props;
    if (!props.isProcessing) {
      if (body['event'] == Event.signup) {
        auth.resend(email: body['email']).then((response) {});
      }
      if (body['event'] == Event.recovery) {
        auth.send(email: body['email']).then((response) {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Preloader(
      preloader: preloader,
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
          padding: EdgeInsets.symmetric(horizontal: 12.h),
          child: Form(
            key: formKey,
            child: Column(
              children: [
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
                SizedBox(height: 32.v),
                CustomPinCodeTextField(
                  length: 6,
                  context: context,
                  controller: tokenController,
                  onChanged: (value) {
                    tokenController.text = value;
                  },
                  validator: (key) {
                    return Validator.otp(key);
                  },
                ),
                SizedBox(height: 16.v),
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
                    Consumer<AuthenticationProvider>(builder:
                        (BuildContext context, provider, Widget? child) {
                      Props props = provider.props;

                      if (props.isSending || props.isResending) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 4.v),
                          child: SizedBox(
                            width: 60.h,
                            child: CustomProgressButton(
                              indicator: false,
                              lable: 'sending'.tr,
                              textStyle:
                                  CustomTextStyles.bodyMediumJaldiBlue500,
                            ),
                          ),
                        );
                      }

                      return GestureDetector(
                        onTap: onReSendOTP,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 4.v),
                          child: Text(
                            "re_send_code".tr,
                            style: CustomTextStyles.bodyMediumJaldiBlue500
                                .copyWith(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
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
                              buttonTextStyle:
                                  CustomTextStyles.titleLargeWhite900,
                              onPressed: onPressed,
                            )
                          ],
                        );
                      }

                      return CustomElevatedButton(
                        height: 50.v,
                        text: "submit_code".tr,
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
    );
  }
}
