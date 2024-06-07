import 'package:flutter/material.dart';
import '/core/app_export.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late BookingRequest request;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    request = ModalRoute.of(context)!.settings.arguments as BookingRequest;
  }

  @override
  Widget build(BuildContext context) {
    for (var guest in request.guests) {
      console.log(guest.toJson());
    }

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          backgroundColor: appTheme.primary,
          centerTitle: false,
          title: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.h,
            ),
            child: AppbarTitle(
              color: appTheme.whiteA700,
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
        body: SizedBox(
          width: SizeUtils.width,
          height: SizeUtils.height,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                top: 0,
                child: Container(
                  width: SizeUtils.width,
                  height: SizeUtils.height * 0.5,
                  decoration: BoxDecoration(
                    color: appTheme.primary,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: SizeUtils.width,
                  height: SizeUtils.height * 0.5,
                  decoration: BoxDecoration(
                    color: appTheme.whiteA700,
                  ),
                ),
              ),
              Positioned(
                child: SizedBox(
                  width: SizeUtils.width,
                  child: Column(
                    children: [
                      SizedBox(height: 12.v),
                      SizedBox(
                        width: SizeUtils.width,
                        child: BookingSteps(
                          step: 3,
                          activeBorderColor: appTheme.whiteA700,
                          activeLineColor: appTheme.whiteA700,
                          activeTextColor: appTheme.whiteA700,
                        ),
                      ),
                      SizedBox(height: 24.v),
                      SizedBox(
                        width: SizeUtils.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomImageView(
                              height: 37.v,
                              color: appTheme.whiteA700,
                              imagePath: "logo".icon.svg,
                            ),
                            Text(
                              "tourly_tours".tr,
                              style: TextStyle(
                                fontSize: 24.fSize,
                                fontFamily: 'Poppins',
                                color: appTheme.whiteA700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.v),
                      SizedBox(
                        width: SizeUtils.width,
                        child: Container(
                          width: SizeUtils.width,
                          margin: EdgeInsets.symmetric(horizontal: 16.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.h,
                            vertical: 16.v,
                          ),
                          decoration: BoxDecoration(
                            color: appTheme.whiteA700,
                            border: Border.all(
                              color: appTheme.whiteA700,
                            ),
                            borderRadius: BorderRadius.circular(16.adaptSize),
                            boxShadow: [
                              BoxShadow(
                                color: appTheme.blueA200.withOpacity(0.25),
                                spreadRadius: 1.h,
                                blurRadius: 1.h,
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 15.v),
                              Text(
                                "pay_tourly_tours".tr,
                                style: CustomTextStyles.labelLargeSemiBold,
                              ),
                              SizedBox(height: 30.v),
                              SizedBox(
                                width: SizeUtils.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 70.h,
                                      child: Text(
                                        "email".tr,
                                        style: theme.textTheme.labelMedium,
                                      ),
                                    ),
                                    Expanded(
                                      child: CustomTextFormField(
                                        hintText: "name".tr,
                                        hintStyle: CustomTextStyles
                                            .labelMediumBluegray500,
                                        suffix: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              30.h, 9.v, 9.h, 9.v),
                                          child: CustomImageView(
                                            imagePath: "question_mark".icon.svg,
                                            height: 10.adaptSize,
                                            width: 10.adaptSize,
                                          ),
                                        ),
                                        suffixConstraints: BoxConstraints(
                                          maxHeight: 28.v,
                                        ),
                                        validator: (value) {
                                          return null;
                                        },
                                        contentPadding: EdgeInsets.only(
                                          left: 9.h,
                                          top: 8.v,
                                          bottom: 8.v,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 15.v),
                              SizedBox(
                                width: SizeUtils.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 70.h,
                                      child: Text(
                                        "card_information".tr,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.labelMedium,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration:
                                            AppDecoration.outlineBlueA.copyWith(
                                          borderRadius:
                                              BorderRadiusStyle.roundedBorder10,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(height: 5.v),
                                            Padding(
                                              padding:
                                                  EdgeInsets.all(2.adaptSize),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: CustomTextFormField(
                                                      borderDecoration:
                                                          InputBorder.none,
                                                      hintText:
                                                          "1234-1234-1234".tr,
                                                      hintStyle: CustomTextStyles
                                                          .labelMediumBluegray500,
                                                      validator: (value) {
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  CustomImageView(
                                                    imagePath: "visa".icon.svg,
                                                  ),
                                                  SizedBox(width: 6.h),
                                                  CustomImageView(
                                                    imagePath:
                                                        "master".icon.svg,
                                                  ),
                                                  SizedBox(width: 6.h),
                                                  CustomImageView(
                                                    imagePath: "amex".icon.svg,
                                                  ),
                                                  SizedBox(width: 6.h),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 5.v),
                                            Divider(color: appTheme.blueA2007f),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        4.adaptSize),
                                                    child: CustomTextFormField(
                                                      borderDecoration:
                                                          InputBorder.none,
                                                      hintStyle: CustomTextStyles
                                                          .labelMediumBluegray500,
                                                      hintText:
                                                          "cardholder_name".tr,
                                                      validator: (value) {
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 50.v,
                                                  child: VerticalDivider(
                                                    width: 1.h,
                                                    thickness: 1.v,
                                                    color: appTheme.blueA200,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        4.adaptSize),
                                                    child: CustomTextFormField(
                                                      borderDecoration:
                                                          InputBorder.none,
                                                      hintStyle: CustomTextStyles
                                                          .labelMediumBluegray500,
                                                      hintText: "name".tr,
                                                      validator: (value) {
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 15.v),
                              SizedBox(
                                width: SizeUtils.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 70.h,
                                      child: Text(
                                        "cardholder_name".tr,
                                        style: theme.textTheme.labelMedium,
                                      ),
                                    ),
                                    Expanded(
                                      child: CustomTextFormField(
                                        hintText: "name".tr,
                                        hintStyle: CustomTextStyles
                                            .labelMediumBluegray500,
                                        suffix: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              30.h, 9.v, 9.h, 9.v),
                                          child: CustomImageView(
                                            imagePath: "question_mark".icon.svg,
                                            height: 10.adaptSize,
                                            width: 10.adaptSize,
                                          ),
                                        ),
                                        suffixConstraints: BoxConstraints(
                                          maxHeight: 28.v,
                                        ),
                                        validator: (value) {
                                          return null;
                                        },
                                        contentPadding: EdgeInsets.only(
                                          left: 9.h,
                                          top: 8.v,
                                          bottom: 8.v,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 15.v),
                              SizedBox(
                                width: SizeUtils.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 70.h,
                                      child: Text(
                                        "cardholder_name".tr,
                                        style: theme.textTheme.labelMedium,
                                      ),
                                    ),
                                    Expanded(
                                      child: CustomTextFormField(
                                        hintText: "name".tr,
                                        hintStyle: CustomTextStyles
                                            .labelMediumBluegray500,
                                        suffix: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              30.h, 9.v, 9.h, 9.v),
                                          child: CustomImageView(
                                            imagePath: "question_mark".icon.svg,
                                            height: 10.adaptSize,
                                            width: 10.adaptSize,
                                          ),
                                        ),
                                        suffixConstraints: BoxConstraints(
                                          maxHeight: 28.v,
                                        ),
                                        validator: (value) {
                                          return null;
                                        },
                                        contentPadding: EdgeInsets.only(
                                          left: 9.h,
                                          top: 8.v,
                                          bottom: 8.v,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 15.v),
                              SizedBox(
                                width: SizeUtils.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 70.h,
                                      child: Text(
                                        "country_of_origin".tr,
                                        style: theme.textTheme.labelMedium,
                                      ),
                                    ),
                                    Expanded(
                                      child: CustomTextFormField(
                                        hintText: "name".tr,
                                        hintStyle: CustomTextStyles
                                            .labelMediumBluegray500,
                                        suffix: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              30.h, 9.v, 9.h, 9.v),
                                          child: CustomImageView(
                                            imagePath: "question_mark".icon.svg,
                                            height: 10.adaptSize,
                                            width: 10.adaptSize,
                                          ),
                                        ),
                                        suffixConstraints: BoxConstraints(
                                          maxHeight: 28.v,
                                        ),
                                        validator: (value) {
                                          return null;
                                        },
                                        contentPadding: EdgeInsets.only(
                                          left: 9.h,
                                          top: 8.v,
                                          bottom: 8.v,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 30.v),
                              CustomElevatedButton(
                                width: 189.h,
                                text: "pay_now".tr,
                              ),
                              SizedBox(height: 15.v),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24.v),
                      SizedBox(
                        width: SizeUtils.width,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: 10.v,
                                bottom: 33.v,
                              ),
                              child: Text(
                                "power_by".tr,
                                style: CustomTextStyles.bodyMediumBlack900_1,
                              ),
                            ),
                            CustomImageView(
                              imagePath: "stripe".icon.svg,
                              height: 27.v,
                              margin: EdgeInsets.only(
                                top: 7.v,
                                right: 8.h,
                                left: 8.h,
                              ),
                            ),
                            Opacity(
                              opacity: 0.2,
                              child: Padding(
                                padding: EdgeInsets.only(left: 5.h),
                                child: SizedBox(
                                  height: 65.v,
                                  child: VerticalDivider(
                                    width: 1.h,
                                    thickness: 1.v,
                                    endIndent: 28.h,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 9.h,
                                top: 9.v,
                                bottom: 33.v,
                              ),
                              child: Text(
                                "terms_privacy".tr,
                                style: CustomTextStyles.bodyMediumBlack900_2,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
