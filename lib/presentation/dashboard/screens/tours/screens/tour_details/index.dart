import 'package:flutter/material.dart';
import '/core/app_export.dart';

class TourDetailsScreen extends StatefulWidget {
  const TourDetailsScreen({super.key});

  @override
  TourDetailsScreenState createState() => TourDetailsScreenState();
}

class TourDetailsScreenState extends State<TourDetailsScreen> {
  bool preloader = true;
  late num? id;
  late ReviewService review;
  late ReviewsPending item;
  late ToursProvider tours;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tours = context.read<ToursProvider>();
      review = context.read<ReviewService>();
      tours.onDetails(id).then((res) {
        setState(() {
          preloader = false;
        });
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    id = ModalRoute.of(context)!.settings.arguments as num?;
  }

  void onPressed(TourDetails tour, String action) {
    // review.fetch(
    //   context,
    //   id: tour.orders.id,
    //   seconds: 0,
    //   action: action,
    //   arguments: tour.reviews,
    // );
  }

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
              text: "tour_details".tr,
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
        body: Consumer<ToursProvider>(
          builder: (context, provider, child) {
            Props props = provider.propsDetails;
            if (props.isProcessing) {
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
                    onRefresh: provider.onRefresh,
                  ),
                ),
              );
            } else {
              var data = props.data;

              if (data == null) {
                return SizedBox(
                  height: 300.v,
                  child: const Center(
                    child: NoRecordsFound(),
                  ),
                );
              }

              TourDetails tour = data as TourDetails;

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
                            tour.orders?.orderNumber ?? '',
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
                                  "${tour.orders?.date?.format('EEE, dd MMM yyyy')}",
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
                                  "${tour.orders?.date?.format('EEE, dd MMM yyyy')}",
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
                                  onTap: () {},
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
                                  text: '${tour.products?.locations ?? 0}',
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
                                  text: '${tour.guests.length}',
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
                                      "${tour.orders?.date?.format('EEE, dd MMM yyyy')}",
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
                              itemCount: tour.itineraries.length,
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                ProductItineraries itineraries =
                                    tour.itineraries[index];

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
                              children: List.generate(tour.itineraries.length,
                                  (index) {
                                ProductItineraries itineraries =
                                    tour.itineraries[index];
                                return Row(
                                  children: [
                                    CustomImageView(
                                      width: 18.h,
                                      height: 18.v,
                                      fit: BoxFit.cover,
                                      imagePath: itineraries.iconUrl,
                                    ),
                                    SizedBox(width: 6.h),
                                    Expanded(
                                      child: Text('${itineraries.title}'),
                                    )
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
                                'whats_included'.tr,
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
                              tour.inclusions.length,
                              (index) {
                                ProductInclusion inclusions =
                                    tour.inclusions[index];
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomImageView(
                                        imagePath: inclusions.isIncluded
                                            .toString()
                                            .icon
                                            .svg),
                                    SizedBox(width: 4.h),
                                    Text(
                                      inclusions.label,
                                      style: CustomTextStyles
                                          .titleSmallOnErrorContainerSemiBold
                                          .copyWith(
                                        fontSize: 12.fSize,
                                      ),
                                    ),
                                    SizedBox(width: 8.h),
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
                                imagePath: 'bullhorn'.icon.svg,
                              ),
                              SizedBox(width: 4.h),
                              Text(
                                'whats_you_need_to_know'.tr,
                                style: CustomTextStyles.bodyMediumBlack900
                                    .copyWith(
                                  fontSize: 12.fSize,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.v),
                          Wrap(
                            runSpacing: 2.v,
                            children: List.generate(
                              tour.additional.length,
                              (index) {
                                ProductAdditionalInformation additional =
                                    tour.additional[index];
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomImageView(
                                      size: 20.adaptSize,
                                      imagePath: additional.mobileIcon.fa,
                                    ),
                                    SizedBox(width: 8.h),
                                    Expanded(
                                      child: Text(
                                        additional.label,
                                        style: CustomTextStyles
                                            .titleSmallOnErrorContainerSemiBold
                                            .copyWith(
                                          fontSize: 12.fSize,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.h),
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
                              tour.guests.length,
                              (index) {
                                OrderGuests guests = tour.guests[index];
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
                                  "${tour.contacts?.whatsapp}",
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
                                  "${tour.contacts?.instagram}",
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
                                  "${tour.contacts?.twitter}",
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
                                  "${tour.contacts?.wechat}",
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
                                  "${tour.contacts?.viber}",
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
                                  "${tour.contacts?.threads}",
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
                                  "${tour.contacts?.line}",
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
                    if (tour.reviews?.id != null)
                      Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.h, vertical: 8.v),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: appTheme.gray500,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                Text(
                                  "review".tr,
                                  style: TextStyle(
                                    fontSize: 14.fSize,
                                    fontFamily: 'Poppins',
                                    color: appTheme.black900,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    onPressed(tour, 'update');
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.amber,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.v),
                            SizedBox(
                              width: double.maxFinite,
                              child: Text(
                                '${tour.reviews?.description}',
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(height: 6.v),
                            SizedBox(
                              height: 100.v,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: tour.reviews!.photos.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return CustomImageView(
                                    width: 100.h,
                                    height: 100.v,
                                    fit: BoxFit.cover,
                                    imagePath: tour.reviews?.photos[index].url,
                                    radius: BorderRadius.circular(12.adaptSize),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(
                                    width: 4.h,
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 12.v),
                            LabelReview(
                              readOnly: true,
                              label: 'rating'.tr,
                              initial: tour.reviews?.rate ?? 1,
                            ),
                            SizedBox(height: 2.v),
                            const HorizontalDivider(),
                            SizedBox(height: 2.v),
                            LabelReview(
                              readOnly: true,
                              label: 'hospitality'.tr,
                              initial: tour.reviews?.hospitality ?? 1,
                            ),
                            SizedBox(height: 2.v),
                            const HorizontalDivider(),
                            SizedBox(height: 2.v),
                            LabelReview(
                              readOnly: true,
                              label: 'impressiveness'.tr,
                              initial: tour.reviews?.impressiveness ?? 1,
                            ),
                            SizedBox(height: 2.v),
                            const HorizontalDivider(),
                            SizedBox(height: 2.v),
                            LabelReview(
                              readOnly: true,
                              label: 'value_for_money'.tr,
                              initial: tour.reviews?.valueForMoney ?? 1,
                            ),
                            SizedBox(height: 2.v),
                            const HorizontalDivider(),
                            SizedBox(height: 2.v),
                            LabelReview(
                              readOnly: true,
                              label: 'seamless_experience'.tr,
                              initial: tour.reviews?.seamlessExperience ?? 1,
                            ),
                            SizedBox(height: 2.v),
                            const HorizontalDivider(),
                            SizedBox(height: 2.v),
                          ],
                        ),
                      ),
                    if (tour.reviews?.id == null &&
                        tour.orders?.status == "COMPLETED")
                      CustomElevatedButton(
                        text: "share_your_opinion".tr,
                        onPressed: () {
                          onPressed(tour, 'create');
                        },
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
