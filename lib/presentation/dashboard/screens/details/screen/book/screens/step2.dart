import 'package:flutter/material.dart';
import '/core/app_export.dart';

class OtherInformationScreen extends StatefulWidget {
  const OtherInformationScreen({super.key});

  @override
  OtherInformationScreenState createState() => OtherInformationScreenState();
}

class OtherInformationScreenState extends State<OtherInformationScreen> {
  late BookingRequest request;
  bool preloader = true;

  String phoneCode = "+93";
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Map<int, Map<String, dynamic>> controllers = {};
  Map<int, Map<String, dynamic>> values = {};

  TextEditingController fullName = TextEditingController();
  TextEditingController emailAddress = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController hotelName = TextEditingController();
  TextEditingController hotelAddress = TextEditingController();
  TextEditingController hotelRoomNumber = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      for (var i = 0; i < request.totalNumberOfGuest; i++) {
        controllers[i] = {
          'name': TextEditingController(),
          'passport': TextEditingController(),
          'date_of_birth': TextEditingController(),
        };
        values[i] = {
          'name': null,
          'passport': null,
          'date_of_birth': null,
        };
      }

      setState(() {
        preloader = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    request = ModalRoute.of(context)!.settings.arguments as BookingRequest;
  }

  Future<void> onContinue() async {
    if (formKey.currentState!.validate()) {
      List<Guests> guests = [];
      values.forEach((int key, Map<String, dynamic> value) {
        guests.add(Guests.toGuest(value));
      });

      request.setStep02(
        phoneCode: phoneCode,
        fullName: fullName.text,
        emailAddress: emailAddress.text,
        mobileNumber: mobileNumber.text,
        hotelName: hotelName.text,
        hotelAddress: hotelAddress.text,
        hotelRoomNumber: hotelRoomNumber.text,
        guests: guests,
      );

      context.read<BookingProvider>().booking(request: request).then(
        (orders) {
          request.setOrders(orders.toJson());
          NavigatorService.push(
            context,
            const ConfirmationScreen(),
            arguments: request,
          );
        },
        onError: (error) {
          console.log(error, 'booking');
        },
      );
    }
  }

  Widget input({
    String? code,
    String? hintText,
    String label = '',
    String type = 'text',
    void Function()? onTap,
    TextInputType? keyboardType,
    void Function(String)? onChanged,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 120.h,
          child: Text(
            label,
            style: theme.textTheme.labelMedium,
          ),
        ),
        Expanded(
          child: type == 'text'
              ? CustomTextFormField(
                  hintText: hintText,
                  validator: validator,
                  onChanged: onChanged,
                  controller: controller,
                  keyboardType: keyboardType,
                  textInputAction: TextInputAction.done,
                  hintStyle: CustomTextStyles.labelMediumBluegray500,
                )
              : type == 'date_of_birth'
                  ? CustomTextFormField(
                      onTap: onTap,
                      readOnly: true,
                      hintText: hintText,
                      validator: validator,
                      onChanged: onChanged,
                      controller: controller,
                      hintStyle: CustomTextStyles.labelMediumBluegray500,
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: onTap,
                          child: Container(
                            width: 58.h,
                            height: 38.v,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: appTheme.blueA2007f,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10.h),
                            ),
                            child: Center(
                              child: Text(
                                code ?? "",
                                style: CustomTextStyles.labelMediumBlue500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 4.h),
                        Expanded(
                          child: CustomTextFormField(
                            hintText: hintText,
                            validator: validator,
                            onChanged: onChanged,
                            controller: controller,
                            keyboardType: keyboardType,
                            textInputAction: TextInputAction.done,
                            hintStyle: CustomTextStyles.labelMediumBluegray500,
                          ),
                        ),
                      ],
                    ),
        ),
      ],
    );
  }

  Widget label({
    String title = '',
    String subtitle = '',
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 150.h,
          child: Text(
            title,
            style: CustomTextStyles.labelMediumSemiBold.copyWith(
              fontSize: 10.fSize,
            ),
          ),
        ),
        Expanded(
          child: Opacity(
            opacity: 0.8,
            child: Text(
              subtitle,
              style: CustomTextStyles.bodySmallOnErrorContainer.copyWith(
                fontSize: 12.fSize,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void onCountryPicker() {
    showCountryPicker(
      context: context,
      exclude: <String>[],
      favorite: <String>[],
      showPhoneCode: true,
      onSelect: (Country country) {
        setState(() {
          phoneCode = "+${country.phoneCode}";
        });
      },
      moveAlongWithKeyboard: false,
      countryListTheme: CountryListThemeData(
        bottomSheetHeight: 500.v,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.v),
          topRight: Radius.circular(24.v),
        ),
        inputDecoration: InputDecoration(
          hintText: 'search'.tr,
          prefixIcon: Icon(
            Icons.search,
            color: appTheme.blueA2007f,
          ),
          hintStyle: CustomTextStyles.labelMediumBluegray500,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.h),
            borderSide: BorderSide(
              color: appTheme.blueA2007f,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.h),
            borderSide: BorderSide(
              color: appTheme.blueA2007f,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.h),
            borderSide: BorderSide(
              color: appTheme.blueA200,
              width: 1,
            ),
          ),
        ),
        searchTextStyle: CustomTextStyles.labelMediumBluegray500,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Preloader(
      preloader: preloader,
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        appBar: CustomAppBar(
          centerTitle: false,
          title: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.h,
            ),
            child: AppbarTitle(
              text: "booking".tr,
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
                    imagePath: "arrow-back".icon.svg,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: SizeUtils.width,
                  child: const BookingSteps(
                    step: 2,
                  ),
                ),
                SizedBox(height: 16.v),
                Text(
                  "selected_package".tr,
                  style: CustomTextStyles.labelLargeSemiBold,
                ),
                SizedBox(height: 21.v),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomImageView(
                      fit: BoxFit.cover,
                      height: 94.adaptSize,
                      width: 100.adaptSize,
                      imagePath: request.product.thumbnailUrl,
                      radius: BorderRadius.circular(
                        10.h,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 13.h,
                        bottom: 26.v,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 196.h,
                            child: Text(
                              request.product.name ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: CustomTextStyles.labelLargeSemiBold,
                            ),
                          ),
                          SizedBox(height: 5.v),
                          Text(
                            "${request.product.price} ${"usd".tr}",
                            style: theme.textTheme.titleMedium,
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 12.v),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.h, vertical: 16.v),
                  decoration: AppDecoration.fillGray.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder10,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "who_should_we_get".tr,
                        style: CustomTextStyles.labelLargeSemiBold,
                      ),
                      SizedBox(height: 12.v),
                      input(
                        controller: fullName,
                        label: "full_name".tr,
                        hintText: "full_name".tr,
                        keyboardType: TextInputType.text,
                        onChanged: (val) {
                          setState(() {
                            fullName.text = val;
                          });
                        },
                        validator: (val) {
                          return Validator.fullName(val);
                        },
                      ),
                      SizedBox(height: 12.v),
                      input(
                        controller: emailAddress,
                        label: "email_address".tr,
                        hintText: "email_address".tr,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (val) {
                          setState(() {
                            emailAddress.text = val;
                          });
                        },
                        validator: (val) {
                          return Validator.emailAddress(val);
                        },
                      ),
                      SizedBox(height: 12.v),
                      input(
                        type: 'mobile_number',
                        controller: mobileNumber,
                        label: "mobile_number".tr,
                        hintText: "mobile_number".tr,
                        code: phoneCode,
                        onTap: onCountryPicker,
                        keyboardType: TextInputType.phone,
                        onChanged: (val) {
                          setState(() {
                            mobileNumber.text = val;
                          });
                        },
                        validator: (val) {
                          return Validator.mobileNumber(val);
                        },
                      ),
                      SizedBox(height: 12.v),
                      input(
                        controller: hotelName,
                        label: "hotel_name".tr,
                        hintText: "hotel_name".tr,
                        keyboardType: TextInputType.text,
                        onChanged: (val) {
                          setState(() {
                            hotelName.text = val;
                          });
                        },
                        validator: (val) {
                          return Validator.hotelName(val);
                        },
                      ),
                      SizedBox(height: 12.v),
                      input(
                        controller: hotelAddress,
                        label: "hotel_address".tr,
                        hintText: "hotel_address".tr,
                        keyboardType: TextInputType.text,
                        onChanged: (val) {
                          setState(() {
                            hotelAddress.text = val;
                          });
                        },
                        validator: (val) {
                          return Validator.hotelAddress(val);
                        },
                      ),
                      SizedBox(height: 12.v),
                      input(
                        controller: hotelRoomNumber,
                        label: "hotel_room_number".tr,
                        hintText: "hotel_room_number".tr,
                        keyboardType: TextInputType.text,
                        onChanged: (val) {
                          setState(() {
                            hotelRoomNumber.text = val;
                          });
                        },
                        validator: (val) {
                          return Validator.hotelRoomNumber(val);
                        },
                      ),
                      SizedBox(height: 12.v),
                      Text(
                        "how_many_of_you".tr,
                        style: CustomTextStyles.labelLargeSemiBold,
                      ),
                      SizedBox(height: 12.v),
                      Wrap(
                        children:
                            List.generate(request.totalNumberOfGuest, (i) {
                          final name = controllers[i]?['name'];
                          final passport = controllers[i]?['passport'];
                          final dateOfBirth = controllers[i]?['date_of_birth'];

                          return Column(
                            children: [
                              input(
                                label:
                                    "${"guest".tr} #${(i + 1).toString().padLeft(2, '0')}",
                                hintText: "name".tr,
                                keyboardType: TextInputType.text,
                                controller: name,
                                onChanged: (val) {
                                  setState(() {
                                    values[i]?['name'] = val;
                                    name.text = val;
                                  });
                                },
                                validator: (val) {
                                  return Validator.name(val);
                                },
                              ),
                              SizedBox(height: 4.v),
                              input(
                                hintText: "passport".tr,
                                keyboardType: TextInputType.text,
                                controller: passport,
                                onChanged: (val) {
                                  setState(() {
                                    values[i]?['passport'] = val;
                                    passport.text = val;
                                  });
                                },
                                validator: (val) {
                                  return Validator.passport(val);
                                },
                              ),
                              SizedBox(height: 4.v),
                              input(
                                type: 'date_of_birth',
                                hintText: values[i]?['date_of_birth'] ??
                                    'date_of_birth'.tr,
                                controller: dateOfBirth,
                                onTap: () async {
                                  DateTime? dateTime =
                                      await Pickers.date(context);
                                  values[i]?['date_of_birth'] =
                                      dateTime?.format('yyyy-MM-dd');
                                  dateOfBirth.text =
                                      dateTime?.format('yyyy-MM-dd');

                                  setState(() {});
                                },
                                validator: (val) {
                                  return Validator.dateOfBirth(val);
                                },
                              ),
                              SizedBox(height: 12.v),
                            ],
                          );
                        }),
                      ),
                      SizedBox(height: 12.v),
                      Container(
                        padding: EdgeInsets.all(8.h),
                        decoration: AppDecoration.fillWhiteA70001.copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder10,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12.v),
                            Text(
                              "summary".tr,
                              style: CustomTextStyles
                                  .titleSmallOnErrorContainerSemiBold,
                            ),
                            SizedBox(height: 12.v),
                            label(
                              title: "number_of_people".tr,
                              subtitle: "${request.totalNumberOfGuest}",
                            ),
                            SizedBox(height: 12.v),
                            label(
                              title: "hotel_name".tr,
                              subtitle: hotelName.text.isNotEmpty
                                  ? hotelName.text
                                  : "hotel_name".tr,
                            ),
                            SizedBox(height: 12.v),
                            label(
                              title: "hotel_address".tr,
                              subtitle: hotelAddress.text.isNotEmpty
                                  ? hotelAddress.text
                                  : "hotel_address".tr,
                            ),
                            SizedBox(height: 12.v),
                            label(
                              title: "hotel_room_number".tr,
                              subtitle: hotelRoomNumber.text.isNotEmpty
                                  ? hotelRoomNumber.text
                                  : "hotel_room_number".tr,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.v),
                      Consumer<BookingProvider>(
                        builder:
                            (BuildContext context, provider, Widget? child) {
                          Props props = provider.props;
                          if (props.isProcessing) {
                            return CustomElevatedButton(
                              text: "",
                              height: 48.v,
                              margin: EdgeInsets.only(
                                left: 16.h,
                                right: 16.h,
                              ),
                              leftIcon: CustomProgressButton(
                                lable: 'processing'.tr,
                                textStyle: CustomTextStyles.titleLargeBlack900,
                              ),
                              buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                              buttonTextStyle:
                                  CustomTextStyles.titleLargeBlack900,
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
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                  ),
                                  SizedBox(height: 6.v),
                                  CustomElevatedButton(
                                    height: 48.v,
                                    text: "continue".tr,
                                    margin: EdgeInsets.only(
                                      left: 16.h,
                                      right: 16.h,
                                    ),
                                    buttonStyle:
                                        CustomButtonStyles.fillPrimaryTL29,
                                    buttonTextStyle:
                                        CustomTextStyles.titleLargeBlack900,
                                    onPressed: onContinue,
                                  )
                                ],
                              );
                            }

                            return CustomElevatedButton(
                              height: 48.v,
                              text: "continue".tr,
                              margin: EdgeInsets.only(
                                left: 16.h,
                                right: 16.h,
                              ),
                              buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                              buttonTextStyle:
                                  CustomTextStyles.titleLargeBlack900,
                              onPressed: onContinue,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
