import 'package:flutter/material.dart';
import '/core/app_export.dart';

class TourDetailsScreen extends StatefulWidget {
  const TourDetailsScreen({super.key});

  @override
  TourDetailsScreenState createState() => TourDetailsScreenState();
}

class TourDetailsScreenState extends State<TourDetailsScreen> {
  bool preloader = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        preloader = false;
      });
    });
  }

  void onTap() {}

  @override
  Widget build(BuildContext context) {
    return Preloader(
      preloader: preloader,
      child: Scaffold(
        appBar: CustomAppBar(
          backgroundColor: appTheme.whiteA700,
          centerTitle: false,
          title: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.h,
            ),
            child: AppbarTitle(
              color: appTheme.black900,
              text: "booking_confirmation".tr,
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
        body: Consumer<OrdersProvider>(
          builder: (context, provider, child) {
            Props props = provider.propsOrder;
            if (props.isNone || props.isLoading || props.isProcessing) {
              return SizedBox(
                height: 135.v,
                child: const Center(
                  child: Loading(),
                ),
              );
            } else if (props.isError) {
              return SizedBox(
                height: 135.v,
                child: Center(
                  child: TryAgain(
                    imagePath: "refresh".icon.svg,
                    onRefresh: () async {
                      await provider.onRefresh(
                        orderNumber: '',
                        fun: 'findByOrderNumber',
                      );
                    },
                  ),
                ),
              );
            } else {
              OrdersDetails? request = props.data as OrdersDetails?;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 8.v),
                child: Column(
                  children: [
                    Container(
                      width: double.maxFinite,
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.h, vertical: 8.v),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: appTheme.gray500,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "your_booking_reference_number_is".tr,
                            style: CustomTextStyles.bodyLargeJaldiGray90001
                                .copyWith(
                              fontSize: 12.fSize,
                            ),
                          ),
                          Text(
                            "${request!.orders!.orderNumber}",
                            style: CustomTextStyles.bodyLargeJaldiGray90001,
                          ),
                          const Divider(),
                          Row(
                            children: [
                              SizedBox(
                                width: 140.h,
                                child: Text(
                                  "booking_date".tr,
                                  style: CustomTextStyles
                                      .titleSmallOnErrorContainerSemiBold
                                      .copyWith(
                                    fontSize: 12.fSize,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16.h),
                              Expanded(
                                child: Text(
                                  "${request.orders!.date?.format('EEE, dd MMM yyyy')}",
                                  style: CustomTextStyles
                                      .bodyLargeJaldiGray90001
                                      .copyWith(
                                    fontSize: 12.fSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 140.h,
                                child: Text(
                                  "paid_on".tr,
                                  style: CustomTextStyles
                                      .titleSmallOnErrorContainerSemiBold
                                      .copyWith(
                                    fontSize: 12.fSize,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16.h),
                              Expanded(
                                child: Text(
                                  "${request.orders!.date?.format('EEE, dd MMM yyyy')}",
                                  style: CustomTextStyles
                                      .bodyLargeJaldiGray90001
                                      .copyWith(
                                    fontSize: 12.fSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "share_or_print_your_booking_details".tr,
                            style: CustomTextStyles.bodyLargeJaldiGray90001
                                .copyWith(
                              fontSize: 12.fSize,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 100.v,
                                height: 32.v,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(8.adaptSize),
                                  border: Border.all(
                                    width: 1.0,
                                    color: appTheme.gray500,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Share.share(
                                            'check out my website https://example.com')
                                        .then((res) {});
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CustomImageView(
                                        imagePath: 'share'.icon.svg,
                                      ),
                                      SizedBox(width: 4.h),
                                      Text('share'.tr)
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.h),
                              Container(
                                width: 100.v,
                                height: 32.v,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(8.adaptSize),
                                  border: Border.all(
                                    width: 1.0,
                                    color: appTheme.gray500,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Launcher.mailto('').then((res) {});
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CustomImageView(
                                        imagePath: 'email'.icon.svg,
                                      ),
                                      SizedBox(width: 4.h),
                                      Text('email'.tr)
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.h),
                              Container(
                                width: 100.v,
                                height: 32.v,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(8.adaptSize),
                                  border: Border.all(
                                    width: 1.0,
                                    color: appTheme.gray500,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: onTap,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CustomImageView(
                                        imagePath: 'print'.icon.svg,
                                      ),
                                      SizedBox(width: 4.h),
                                      Text('print'.tr)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.v),
                    Container(
                      width: double.maxFinite,
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.h, vertical: 8.v),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: appTheme.gray500,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "booking_date".tr,
                            style: CustomTextStyles
                                .titleSmallOnErrorContainerSemiBold
                                .copyWith(
                              fontSize: 12.fSize,
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '${request.product?.locations ?? 0}',
                                  style: CustomTextStyles
                                      .titleSmallOnErrorContainerSemiBold
                                      .copyWith(
                                    fontSize: 12.fSize,
                                  ),
                                ),
                                TextSpan(
                                  text: 'locations_for'.tr,
                                  style: CustomTextStyles.bodyMediumBlack900
                                      .copyWith(
                                    fontSize: 12.fSize,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                                TextSpan(
                                  text: '${request.guests?.length ?? 0}',
                                  style: CustomTextStyles
                                      .titleSmallOnErrorContainerSemiBold
                                      .copyWith(
                                    fontSize: 12.fSize,
                                  ),
                                ),
                                TextSpan(
                                  text: 'people'.tr,
                                  style: CustomTextStyles.bodyMediumBlack900
                                      .copyWith(
                                    fontSize: 12.fSize,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "${request.orders!.date?.format('EEE, dd MMM yyyy')}",
                                  style: CustomTextStyles.bodyMediumBlack900
                                      .copyWith(
                                    fontSize: 12.fSize,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 80.v,
                            child: ListView.separated(
                              itemCount: request.itineraries?.length ?? 0,
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                ProductItineraries itineraries =
                                    request.itineraries![index];

                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8.h),
                                  child: CustomImageView(
                                    width: 80.h,
                                    fit: BoxFit.cover,
                                    imagePath: itineraries.imageUrl,
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(width: 4.h);
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.h),
                            decoration: AppDecoration.fillWhiteA70001.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder10,
                            ),
                            child: Wrap(
                              runSpacing: 8.v,
                              children: List.generate(
                                  request.itineraries?.length ?? 0, (index) {
                                ProductItineraries itineraries =
                                    request.itineraries![index];
                                return Row(
                                  children: [
                                    CustomImageView(
                                      width: 18.h,
                                      height: 18.v,
                                      fit: BoxFit.cover,
                                      imagePath: itineraries.iconUrl,
                                    ),
                                    SizedBox(width: 6.h),
                                    Text('${itineraries.title}')
                                  ],
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.v),
                    Container(
                      width: double.maxFinite,
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.h, vertical: 8.v),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: appTheme.gray500,
                          width: 1.0,
                        ),
                        borderRadius:
                            BorderRadius.circular(10.0), // Border radius
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomImageView(
                                imagePath: 'guest'.icon.svg,
                              ),
                              SizedBox(width: 4.h),
                              Text(
                                'guests_information'.tr,
                                style: CustomTextStyles.bodyMediumBlack900
                                    .copyWith(
                                  fontSize: 12.fSize,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.v),
                          Wrap(
                            children: List.generate(
                              request.guests?.length ?? 0,
                              (index) {
                                OrderGuests guests = request.guests![index];
                                return Row(
                                  children: [
                                    SizedBox(
                                      width: 100.h,
                                      child: Text(
                                        "${guests.name}",
                                        style: CustomTextStyles
                                            .titleSmallOnErrorContainerSemiBold
                                            .copyWith(
                                          fontSize: 12.fSize,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.h),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Text(
                                            "passport_no".tr,
                                            style: CustomTextStyles
                                                .bodyLargeJaldiGray90001
                                                .copyWith(
                                              fontSize: 12.fSize,
                                            ),
                                          ),
                                          SizedBox(width: 4.h),
                                          Text(
                                            "${guests.passportNumber}",
                                            style: CustomTextStyles
                                                .bodyLargeJaldiGray90001
                                                .copyWith(
                                              fontSize: 12.fSize,
                                            ),
                                          ),
                                          SizedBox(width: 4.h),
                                          InkWell(
                                            onTap: () {},
                                            child: Text(
                                              "edit".tr,
                                              style: CustomTextStyles
                                                  .bodyLargeJaldiGray90001
                                                  .copyWith(
                                                color: appTheme.blue500,
                                                fontSize: 12.fSize,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.v),
                    Container(
                      width: double.maxFinite,
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.h, vertical: 8.v),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: appTheme.gray500,
                          width: 1.0,
                        ),
                        borderRadius:
                            BorderRadius.circular(10.0), // Border radius
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomImageView(
                                imagePath: 'print'.icon.svg,
                              ),
                              SizedBox(width: 4.h),
                              Text(
                                "cancellation_policy".tr,
                                style: CustomTextStyles.bodyMediumBlack900
                                    .copyWith(
                                  fontSize: 12.fSize,
                                ),
                              ),
                            ],
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'free_cancellation'.tr,
                                  style: CustomTextStyles.bodyMediumBlack900
                                      .copyWith(
                                    fontSize: 12.fSize,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      'up_to_24_hours_before_the_exprience_starts'
                                          .tr,
                                  style: CustomTextStyles.bodyMediumBlack900
                                      .copyWith(
                                    fontSize: 12.fSize,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.v),
                    Container(
                      width: double.maxFinite,
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.h, vertical: 8.v),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: appTheme.gray500,
                          width: 1.0,
                        ),
                        borderRadius:
                            BorderRadius.circular(10.0), // Border radius
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomImageView(
                                imagePath: 'support'.icon.svg,
                              ),
                              SizedBox(width: 4.h),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'contact'.tr,
                                      style: CustomTextStyles.bodyMediumBlack900
                                          .copyWith(
                                        fontSize: 12.fSize,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'tourly_tours'.tr,
                                      style: CustomTextStyles.bodyMediumBlack900
                                          .copyWith(
                                        fontSize: 12.fSize,
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.v),
                          Row(
                            children: [
                              SizedBox(
                                width: 140.h,
                                child: Text(
                                  "whatsapp".tr,
                                  style: CustomTextStyles
                                      .titleSmallOnErrorContainerSemiBold
                                      .copyWith(
                                    fontSize: 12.fSize,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16.h),
                              Expanded(
                                child: Text(
                                  "${request.contacts?.whatsapp}",
                                  style: CustomTextStyles
                                      .bodyLargeJaldiGray90001
                                      .copyWith(
                                    fontSize: 12.fSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.v),
                          Row(
                            children: [
                              SizedBox(
                                width: 140.h,
                                child: Text(
                                  "instagram".tr,
                                  style: CustomTextStyles
                                      .titleSmallOnErrorContainerSemiBold
                                      .copyWith(
                                    fontSize: 12.fSize,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16.h),
                              Expanded(
                                child: Text(
                                  "${request.contacts?.instagram}",
                                  style: CustomTextStyles
                                      .bodyLargeJaldiGray90001
                                      .copyWith(
                                    fontSize: 12.fSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.v),
                          Row(
                            children: [
                              SizedBox(
                                width: 140.h,
                                child: Text(
                                  "twitter".tr,
                                  style: CustomTextStyles
                                      .titleSmallOnErrorContainerSemiBold
                                      .copyWith(
                                    fontSize: 12.fSize,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16.h),
                              Expanded(
                                child: Text(
                                  "${request.contacts?.twitter}",
                                  style: CustomTextStyles
                                      .bodyLargeJaldiGray90001
                                      .copyWith(
                                    fontSize: 12.fSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.v),
                          Row(
                            children: [
                              SizedBox(
                                width: 140.h,
                                child: Text(
                                  "wechat".tr,
                                  style: CustomTextStyles
                                      .titleSmallOnErrorContainerSemiBold
                                      .copyWith(
                                    fontSize: 12.fSize,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16.h),
                              Expanded(
                                child: Text(
                                  "${request.contacts?.wechat}",
                                  style: CustomTextStyles
                                      .bodyLargeJaldiGray90001
                                      .copyWith(
                                    fontSize: 12.fSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.v),
                          Row(
                            children: [
                              SizedBox(
                                width: 140.h,
                                child: Text(
                                  "viber".tr,
                                  style: CustomTextStyles
                                      .titleSmallOnErrorContainerSemiBold
                                      .copyWith(
                                    fontSize: 12.fSize,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16.h),
                              Expanded(
                                child: Text(
                                  "${request.contacts?.viber}",
                                  style: CustomTextStyles
                                      .bodyLargeJaldiGray90001
                                      .copyWith(
                                    fontSize: 12.fSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.v),
                          Row(
                            children: [
                              SizedBox(
                                width: 140.h,
                                child: Text(
                                  "threads".tr,
                                  style: CustomTextStyles
                                      .titleSmallOnErrorContainerSemiBold
                                      .copyWith(
                                    fontSize: 12.fSize,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16.h),
                              Expanded(
                                child: Text(
                                  "${request.contacts?.threads}",
                                  style: CustomTextStyles
                                      .bodyLargeJaldiGray90001
                                      .copyWith(
                                    fontSize: 12.fSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.v),
                          Row(
                            children: [
                              SizedBox(
                                width: 140.h,
                                child: Text(
                                  "line".tr,
                                  style: CustomTextStyles
                                      .titleSmallOnErrorContainerSemiBold
                                      .copyWith(
                                    fontSize: 12.fSize,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16.h),
                              Expanded(
                                child: Text(
                                  "${request.contacts?.line}",
                                  style: CustomTextStyles
                                      .bodyLargeJaldiGray90001
                                      .copyWith(
                                    fontSize: 12.fSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.v),
                    CustomElevatedButton(
                      text: "share_your_opinion".tr,
                      onPressed: () {},
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
