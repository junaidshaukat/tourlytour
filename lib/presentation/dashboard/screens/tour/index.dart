import 'package:flutter/material.dart';
import '/core/app_export.dart';

class ToursScreen extends StatefulWidget {
  const ToursScreen({super.key});

  @override
  ToursScreenState createState() => ToursScreenState();
}

class ToursScreenState extends State<ToursScreen> {
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
              text: "tours".tr,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Consumer<SearchProvider>(
                      builder: (context, provider, child) {
                        return CustomTextFormField(
                          hintText: "search_tour".tr,
                          hintStyle: CustomTextStyles.bodySmallBlue200,
                          textInputAction: TextInputAction.done,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 13.h,
                            vertical: 15.v,
                          ),
                          onChanged: provider.onChanged,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.h),
                    child: Consumer<SearchProvider>(
                      builder: (context, provider, child) {
                        return CustomIconButton(
                          height: 46.adaptSize,
                          width: 46.adaptSize,
                          padding: EdgeInsets.all(12.h),
                          decoration: IconButtonStyleHelper.fillBlueGray,
                          onTap: provider.onTap,
                          child: CustomImageView(
                            imagePath: "search".icon.svg,
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
              SizedBox(height: 5.v),
              Consumer<SearchProvider>(builder: (context, provider, child) {
                Props props = provider.props;
                if (props.isNone || props.isProcessing) {
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
                  // List data = props.data as List;
                  // if (data.isEmpty) {
                  //   return SizedBox(
                  //     height: 300.v,
                  //     child: const Center(
                  //       child: NoRecordsFound(),
                  //     ),
                  //   );
                  // }

                  return Wrap(
                    spacing: 4.adaptSize,
                    runSpacing: 8.adaptSize,
                    children: List.generate(
                      10,
                      (index) {
                        // Products product = data[index];
                        return Container(
                          width: SizeUtils.width,
                          padding: EdgeInsets.all(4.adaptSize),
                          decoration: AppDecoration.outlineBlack900.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder10,
                          ),
                          child: InkWell(
                            onTap: () {
                              context.read<ProductVideosProvider>().clear();
                              context.read<ProductPhotosProvider>().clear();
                              context.read<ProductReviewsProvider>().clear();
                              context
                                  .read<ProductItinerariesProvider>()
                                  .clear();

                              // NavigatorService.push(
                              //   context,
                              //   const ProductDetailsScreen(),
                              //   arguments: product,
                              // );
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
                                    imagePath: 'product'.image.png,
                                  ),
                                ),
                                SizedBox(width: 8.h),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 290.h,
                                      child: Text(
                                        'product.name',
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
                                        "{product.locations ?? " "}",
                                        maxLines: 6,
                                        overflow: TextOverflow.ellipsis,
                                        style: CustomTextStyles.poppinsBlack900,
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
              }),
            ],
          ),
        ),
      ),
    );
  }
}
