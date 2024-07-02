import 'package:flutter/material.dart';
import '/core/app_export.dart';

class PackageSelectionScreen extends StatefulWidget {
  const PackageSelectionScreen({super.key});

  @override
  PackageSelectionScreenState createState() => PackageSelectionScreenState();
}

class PackageSelectionScreenState extends State<PackageSelectionScreen> {
  bool preloader = true;
  late Products product;
  late CurrentUserProvider currentUser;

  BookingRequest request = BookingRequest();

  DateRangePickerController controller = DateRangePickerController();

  DateTime? initialSelectedDate;
  DateTime? date;
  int totalNumberOfGuest = 1;
  String? errMsg;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      currentUser = context.read<CurrentUserProvider>();
      request.setProducts(product, currentUser);
      await context.read<BookingProvider>().getBlackoutDates(product.id);

      setState(() {
        preloader = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    product = ModalRoute.of(context)!.settings.arguments as Products;
  }

  void onIncrement() {
    setState(() {
      if (totalNumberOfGuest < 10) totalNumberOfGuest++;
    });
  }

  void onDecrement() {
    setState(() {
      if (totalNumberOfGuest > 1) totalNumberOfGuest--;
    });
  }

  void onCancel() {
    setState(() {
      controller.selectedDate = date;
      NavigatorService.goBack();
    });
  }

  void onConfirm() {
    setState(() {
      date = controller.selectedDate;
      NavigatorService.goBack();
    });
  }

  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      // final DateTime rangeStartDate = args.value.startDate;
      // final DateTime rangeEndDate = args.value.endDate;
    } else if (args.value is DateTime) {
      setState(() {
        initialSelectedDate = args.value;
      });
    } else if (args.value is List<DateTime>) {
      // final List<DateTime> selectedDates = args.value;
    } else {
      // final List<PickerDateRange> selectedRanges = args.value;
    }
  }

  void onContinue() {
    if (date == null) {
      setState(() {
        errMsg = "please_select_a_date".tr;
      });
      return;
    }

    if (totalNumberOfGuest <= 0) {
      setState(() {
        errMsg =
            "the_total_number_of_guests_cannot_be_less_than_or_equal_to_zero"
                .tr;
      });
      return;
    }

    setState(() {
      errMsg = null;
    });

    request.setStep00(product, currentUser);
    request.setStep01(date: date!, totalNumberOfGuest: totalNumberOfGuest);

    NavigatorService.push(
      context,
      const OtherInformationScreen(),
      arguments: request,
    );
  }

  void pickDates() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Consumer<BookingProvider>(
          builder: (context, provider, child) {
            Props props = provider.propsBlackoutDates;
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
                    onRefresh: provider.onRefresh,
                  ),
                ),
              );
            } else {
              return ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: SfDateRangePicker(
                          enablePastDates: false,
                          controller: controller,
                          minDate: DateTime.now(),
                          view: DateRangePickerView.month,
                          backgroundColor: Colors.transparent,
                          todayHighlightColor: appTheme.green500,
                          selectionColor: appTheme.green500,
                          selectionTextStyle: TextStyle(
                            color: appTheme.whiteA700,
                          ),
                          selectionMode: DateRangePickerSelectionMode.single,
                          initialSelectedDate: initialSelectedDate,
                          // initialSelectedDates: provider.initialSelectedDates,
                          headerStyle: const DateRangePickerHeaderStyle(
                            backgroundColor: Colors.transparent,
                          ),
                          monthViewSettings: DateRangePickerMonthViewSettings(
                            dayFormat: 'EEE',
                            showTrailingAndLeadingDates: true,
                            blackoutDates: provider.blackoutDates,
                          ),
                          onSelectionChanged: onSelectionChanged,
                          monthCellStyle: DateRangePickerMonthCellStyle(
                            blackoutDateTextStyle: TextStyle(
                              color: appTheme.whiteA700,
                            ),
                            blackoutDatesDecoration: BoxDecoration(
                              color: appTheme.redA100,
                              border: Border.all(
                                color: appTheme.redA100,
                                width: 1,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.v),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(100.h, 60.v),
                              maximumSize: Size(100.h, 60.v),
                              backgroundColor: appTheme.yellow800,
                              foregroundColor: appTheme.whiteA700,
                            ),
                            onPressed: onCancel,
                            child: Text("cancel".tr),
                          ),
                          SizedBox(width: 4.h),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(100.h, 60.v),
                              maximumSize: Size(100.h, 60.v),
                              backgroundColor: appTheme.green500,
                              foregroundColor: appTheme.whiteA700,
                            ),
                            onPressed: onConfirm,
                            child: Text("confirm".tr),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.v),
                    ],
                  ),
                ),
              );
            }
          },
        );
      },
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
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: SizeUtils.width,
                child: const BookingSteps(
                  step: 1,
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomImageView(
                    fit: BoxFit.cover,
                    height: 94.adaptSize,
                    width: 100.adaptSize,
                    imagePath: product.thumbnailUrl,
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
                            product.name ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: CustomTextStyles.labelLargeSemiBold,
                          ),
                        ),
                        SizedBox(height: 5.v),
                        Text(
                          "${product.price} ${"usd".tr}",
                          style: theme.textTheme.titleMedium,
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 12.v),
              Container(
                padding: EdgeInsets.all(16.adaptSize),
                decoration: AppDecoration.fillGray.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder10,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "package_options".tr,
                      style: CustomTextStyles.labelLargeSemiBold,
                    ),
                    SizedBox(height: 8.v),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 150.h,
                          child: Text(
                            "check_availability".tr,
                            style: theme.textTheme.labelMedium,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 42.v,
                            width: 77.h,
                            padding: EdgeInsets.symmetric(vertical: 5.v),
                            decoration: AppDecoration.outlineBlueA.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder10,
                            ),
                            child: date == null
                                ? InkWell(
                                    onTap: pickDates,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomImageView(
                                          imagePath: "calander".icon.svg,
                                        ),
                                        SizedBox(width: 6.h),
                                        Text(
                                          "select_dates".tr,
                                          style: CustomTextStyles
                                              .labelMediumBlack900,
                                        ),
                                      ],
                                    ),
                                  )
                                : Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.h),
                                    child: Center(
                                      child:
                                          Text('${date?.format('yyyy/MM/dd')}'),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.v),
                    Text(
                      "how_many_of_you".tr,
                      style: CustomTextStyles.labelLargeSemiBold,
                    ),
                    SizedBox(height: 12.v),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 150.h,
                          child: Text(
                            "number_of_people".tr,
                            style: theme.textTheme.labelMedium,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: 77.h,
                            height: 42.v,
                            padding: EdgeInsets.symmetric(vertical: 5.v),
                            decoration: AppDecoration.outlineBlueA.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: onDecrement,
                                  child: Container(
                                    height: 24.v,
                                    width: 24.h,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "-".tr,
                                        style: CustomTextStyles
                                            .labelMediumBlack900
                                            .copyWith(
                                          fontSize: 18.fSize,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  "$totalNumberOfGuest",
                                  style: CustomTextStyles.labelMediumBlack900
                                      .copyWith(
                                    fontSize: 14.fSize,
                                  ),
                                ),
                                InkWell(
                                  onTap: onIncrement,
                                  child: Container(
                                    height: 24.v,
                                    width: 24.h,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "+".tr,
                                        style: CustomTextStyles
                                            .labelMediumBlack900
                                            .copyWith(
                                          fontSize: 18.fSize,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.v),
                    if (errMsg != null)
                      SizedBox(
                        width: double.maxFinite,
                        child: Text(
                          errMsg ?? "",
                          textAlign: TextAlign.center,
                          style: CustomTextStyles.bodyMediumRed300,
                        ),
                      ),
                    if (errMsg != null) SizedBox(height: 12.v),
                    CustomElevatedButton(
                      height: 48.v,
                      text: "continue".tr,
                      margin: EdgeInsets.only(
                        left: 16.h,
                        right: 16.h,
                      ),
                      buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                      buttonTextStyle: CustomTextStyles.titleLargeBlack900,
                      onPressed: onContinue,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
