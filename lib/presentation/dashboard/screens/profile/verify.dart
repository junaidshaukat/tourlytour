import 'package:flutter/material.dart';
import '/core/app_export.dart';

class ProfileVerifyScreen extends StatefulWidget {
  const ProfileVerifyScreen({super.key});

  @override
  ProfileVerifyScreenState createState() => ProfileVerifyScreenState();
}

class ProfileVerifyScreenState extends State<ProfileVerifyScreen> {
  bool preloader = true;
  late AuthenticationProvider auth;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();

  dynamic arguments;
  late AuthForm body;
  String? field;
  String? hintText;
  bool verified = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      auth = context.read<AuthenticationProvider>();
      arguments = ModalRoute.of(context)!.settings.arguments;
      body = arguments['body'] as AuthForm;
      field = arguments['field'] as String?;
      hintText = arguments['hintText'] as String?;
      verified = arguments['verified'] as bool;
      setState(() {
        preloader = false;
      });
    });
  }

  Future<void> onPressed() async {
    Props props = auth.props;
    if (!props.isProcessing) {
      if (formKey.currentState!.validate()) {
        bool response = await auth.verifyOtp(
          body: body,
          token: controller.text,
        );

        if (response) {
          NavigatorService.popAndPushNamed(
            AppRoutes.profileUpdate,
            arguments: {
              'verified': true,
              'field': field,
              'hintText': hintText,
            },
          );
        }
      }
    }
  }

  Future<void> onSendOTP() async {
    Props props = auth.props;
    if (!props.isProcessing) {
      await auth.sendOTP(body);
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
                  controller: controller,
                  onChanged: (value) {
                    controller.text = value;
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

                      if (props.isSending) {
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
                        onTap: onSendOTP,
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
