import 'package:flutter/material.dart';
import '/core/app_export.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  String key = '';
  bool preloader = true;
  DateTime initialDate = DateTime.now();
  late ProductsProvider products;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      products = context.read<ProductsProvider>();

      setState(() {
        preloader = false;
      });
    });
  }

  void onDateChange(DateTime date) {
    setState(() {
      initialDate = date;
    });
  }

  void onChanged(String text) {
    setState(() {
      key = text;
    });
  }

  Future<void> onTap() async {
    if (!products.propsSearch.isProcessing) {
      await products.onSearch(key, initialDate.format('yyyy-MM-dd'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Preloader(
      preloader: preloader,
      child: Scaffold(
        key: scaffoldKey,
        appBar: CustomAppBar(
          centerTitle: false,
          title: Padding(
            padding: EdgeInsets.only(left: 16.h),
            child: AppbarTitle(
              text: "search_destination".tr,
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
          padding: EdgeInsets.symmetric(horizontal: 10.h),
          child: Column(
            children: [
              Container(
                width: 373.h,
                padding: EdgeInsets.symmetric(
                  vertical: 12.v,
                ),
                decoration: BoxDecoration(
                  color: appTheme.blue50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: EasyDateTimeLine(
                  locale: 'en_US',
                  initialDate: initialDate,
                  headerProps: const EasyHeaderProps(
                    monthPickerType: MonthPickerType.switcher,
                    dateFormatter: DateFormatter.fullDateDMY(),
                  ),
                  dayProps: EasyDayProps(
                    todayStyle: DayStyle(
                      decoration: BoxDecoration(
                        color: appTheme.blue50,
                        border: Border.all(
                          color: appTheme.blue50,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    activeDayStyle: DayStyle(
                      decoration: BoxDecoration(
                        color: appTheme.blue500,
                        border: Border.all(
                          color: appTheme.blue200,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    dayStructure: DayStructure.dayStrDayNum,
                  ),
                  onDateChange: onDateChange,
                ),
              ),
              SizedBox(height: 16.v),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      hintText: "search_destination".tr,
                      hintStyle: CustomTextStyles.bodySmallBlue200,
                      textInputAction: TextInputAction.done,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 13.h,
                        vertical: 15.v,
                      ),
                      onChanged: onChanged,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.h),
                    child: CustomIconButton(
                      onTap: onTap,
                      height: 46.adaptSize,
                      width: 46.adaptSize,
                      padding: EdgeInsets.all(12.h),
                      decoration: IconButtonStyleHelper.fillBlueGray,
                      child: CustomImageView(imagePath: "search".icon.svg),
                    ),
                  )
                ],
              ),
              SizedBox(height: 5.v),
              Consumer<ProductsProvider>(
                builder: (context, provider, child) {
                  Props props = provider.propsSearch;
                  if (props.isProcessing) {
                    return SizedBox(
                      height: 300.v,
                      child: const Center(
                        child: Loading(),
                      ),
                    );
                  } else if (props.isError) {
                    return SizedBox(
                      height: 300.v,
                      child: Center(
                        child: TryAgain(
                          imagePath: "refresh".icon.svg,
                          onRefresh: provider.onRefresh,
                        ),
                      ),
                    );
                  } else {
                    List data = props.data as List;
                    if (data.isEmpty) {
                      return SizedBox(
                        height: 300.v,
                        child: const Center(
                          child: NoRecordsFound(),
                        ),
                      );
                    }

                    return Wrap(
                      spacing: 4.adaptSize,
                      runSpacing: 8.adaptSize,
                      children: List.generate(
                        data.length,
                        (index) {
                          Products product = data[index];
                          return Container(
                            width: SizeUtils.width,
                            padding: EdgeInsets.all(4.adaptSize),
                            decoration: AppDecoration.outlineBlack900.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder10,
                            ),
                            child: InkWell(
                              onTap: () {
                                NavigatorService.push(
                                  context,
                                  const ProductDetailsScreen(),
                                  arguments: product,
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(8.adaptSize),
                                    child: CustomImageView(
                                      width: 60.h,
                                      height: 60.v,
                                      fit: BoxFit.cover,
                                      imagePath: product.thumbnailUrl,
                                    ),
                                  ),
                                  SizedBox(width: 8.h),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 290.h,
                                        child: Text(
                                          product.name ?? "",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: CustomTextStyles
                                              .labelMediumBlack900,
                                        ),
                                      ),
                                      SizedBox(height: 4.v),
                                      SizedBox(
                                        width: 290.h,
                                        child: Text(
                                          "${product.locations ?? ""}",
                                          maxLines: 6,
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              CustomTextStyles.poppinsBlack900,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
