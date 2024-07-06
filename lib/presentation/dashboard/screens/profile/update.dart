import 'package:flutter/material.dart';
import '/core/app_export.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});

  @override
  ProfileUpdateScreenState createState() => ProfileUpdateScreenState();
}

class ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  bool preloader = true;
  late AuthenticationProvider auth;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();

  dynamic arguments;
  String? field;
  String? hintText;
  bool? verified;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      auth = context.read<AuthenticationProvider>();
      arguments = ModalRoute.of(context)!.settings.arguments;
      field = arguments['field'] as String?;
      hintText = arguments['hintText'] as String?;
      verified = arguments['verified'] as bool?;
      controller.text = hintText ?? '';
      setState(() {
        preloader = false;
      });
    });
  }

  Future<void> onUpdateEmail() async {
    Props props = auth.props;
    if (!props.isProcessing) {
      if (formKey.currentState!.validate()) {
        bool response = await auth.onUpdateEmail(controller.text);
        if (response && mounted) {
          await context.read<CurrentUserProvider>().onReady();
          NavigatorService.goBack();
        }
      }
    }
  }

  Future<void> onUpdatePhone() async {
    Props props = auth.props;
    if (!props.isProcessing) {
      if (formKey.currentState!.validate()) {
        bool response = await auth.onUpdatePhone(controller.text);
        if (response && mounted) {
          await context.read<CurrentUserProvider>().onReady();
          NavigatorService.goBack();
        }
      }
    }
  }

  Future<void> onUpdateName() async {
    Props props = auth.props;
    if (!props.isProcessing) {
      if (formKey.currentState!.validate()) {
        bool response = await auth.updateUserMetadata({
          "name": controller.text,
          "full_name": controller.text,
        });
        if (response && mounted) {
          await context.read<CurrentUserProvider>().onReady();
          NavigatorService.goBack();
        }
      }
    }
  }

  Future<void> onSendCode() async {
    Props props = auth.props;
    if (!props.isProcessing) {
      if (formKey.currentState!.validate()) {
        AuthForm body = AuthForm(
          event: AuthEvent.update,
          provider: field,
          email: hintText,
          phone: hintText,
        );

        bool response = await auth.sendOTP(body);
        if (response) {
          NavigatorService.popAndPushNamed(
            AppRoutes.profileVerify,
            arguments: {
              'body': body,
              'field': field,
              'hintText': hintText,
              'verified': verified,
            },
          );
        }
      }
    }
  }

  Widget input({
    required String label,
    required String hintText,
    TextEditingController? controller,
    String? Function(String?)? validator,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall,
        ),
        SizedBox(height: 4.v),
        CustomTextFormField(
          readOnly: readOnly,
          controller: controller,
          hintText: hintText,
          hintStyle: CustomTextStyles.bodyMediumBlack900,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.h,
            vertical: 14.v,
          ),
          borderDecoration: TextFormFieldStyleHelper.fillBlue,
          fillColor: appTheme.blue50,
          validator: validator,
        ),
      ],
    );
  }

  Widget name() {
    return Column(
      children: [
        input(
          label: "name".tr,
          controller: controller,
          hintText: hintText ?? "",
          validator: (value) {
            return Validator.username(value);
          },
        ),
        SizedBox(height: 16.v),
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
                      text: "update".tr,
                      buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                      buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                      onPressed: onUpdateName,
                    )
                  ],
                );
              }

              return CustomElevatedButton(
                height: 50.v,
                text: "update".tr,
                buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                onPressed: onUpdateName,
              );
            }
          },
        ),
      ],
    );
  }

  Widget email() {
    if (verified == true) {
      return Column(
        children: [
          input(
            label: "email".tr,
            controller: controller,
            hintText: hintText ?? "",
            validator: (value) {
              return Validator.email(value);
            },
          ),
          SizedBox(height: 16.v),
          Consumer<AuthenticationProvider>(
            builder: (BuildContext context, provider, Widget? child) {
              Props props = provider.props;
              if (props.isProcessing || props.isSending) {
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
                        text: "update".tr,
                        buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                        buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                        onPressed: onUpdateEmail,
                      )
                    ],
                  );
                }

                return CustomElevatedButton(
                  height: 50.v,
                  text: "update".tr,
                  buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                  buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                  onPressed: onUpdateEmail,
                );
              }
            },
          ),
        ],
      );
    }

    return Column(
      children: [
        input(
          readOnly: true,
          label: "email".tr,
          controller: controller,
          hintText: hintText ?? "",
          validator: (value) {
            return Validator.email(value);
          },
        ),
        SizedBox(height: 16.v),
        Consumer<AuthenticationProvider>(
          builder: (BuildContext context, provider, Widget? child) {
            Props props = provider.props;
            if (props.isProcessing || props.isSending) {
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
                      text: "send_otp".tr,
                      buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                      buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                      onPressed: onSendCode,
                    )
                  ],
                );
              }

              return CustomElevatedButton(
                height: 50.v,
                text: "send_otp".tr,
                buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                onPressed: onSendCode,
              );
            }
          },
        ),
      ],
    );
  }

  Widget phone({bool verified = false}) {
    if (verified) {
      return Column(
        children: [
          input(
            label: "phone".tr,
            controller: controller,
            hintText: hintText ?? "",
            validator: (value) {
              return Validator.phone(value);
            },
          ),
          SizedBox(height: 16.v),
          Consumer<AuthenticationProvider>(
            builder: (BuildContext context, provider, Widget? child) {
              Props props = provider.props;
              if (props.isProcessing || props.isSending) {
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
                        text: "update".tr,
                        buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                        buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                        onPressed: onUpdatePhone,
                      )
                    ],
                  );
                }

                return CustomElevatedButton(
                  height: 50.v,
                  text: "update".tr,
                  buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                  buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                  onPressed: onUpdatePhone,
                );
              }
            },
          ),
        ],
      );
    }

    return Column(
      children: [
        input(
          readOnly: true,
          label: "phone".tr,
          controller: controller,
          hintText: hintText ?? "",
          validator: (value) {
            return Validator.phone(value);
          },
        ),
        SizedBox(height: 16.v),
        Consumer<AuthenticationProvider>(
          builder: (BuildContext context, provider, Widget? child) {
            Props props = provider.props;
            if (props.isProcessing || props.isSending) {
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
                      text: "send_otp".tr,
                      buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                      buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                      onPressed: onSendCode,
                    )
                  ],
                );
              }

              return CustomElevatedButton(
                height: 50.v,
                text: "send_otp".tr,
                buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                buttonTextStyle: CustomTextStyles.titleLargeWhite900,
                onPressed: onSendCode,
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Preloader(
      preloader: preloader,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          centerTitle: false,
          title: Padding(
            padding: EdgeInsets.only(left: 16.h),
            child: AppbarTitle(
              text: "update_profile".tr,
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
                    color: appTheme.black900,
                    imagePath: "arrow_left".icon.svg,
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
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Form(
            key: formKey,
            child: field == 'name'
                ? name()
                : field == 'email'
                    ? email()
                    : field == 'phone'
                        ? phone()
                        : const SizedBox(),
          ),
        ),
      ),
    );
  }
}
