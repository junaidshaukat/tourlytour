import 'package:flutter/material.dart';
import '/core/app_export.dart';

export 'screen/export.dart';
export 'widgets/export.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  ProductDetailsScreenState createState() => ProductDetailsScreenState();
}

class ProductDetailsScreenState extends State<ProductDetailsScreen>
    with TickerProviderStateMixin {
  bool preloader = true;

  late num? id;
  late ProductsProvider products;
  late AuthenticationProvider auth;
  late TabController tabviewController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      auth = context.read<AuthenticationProvider>();
      products = context.read<ProductsProvider>();

      products.onDetail(id).then((res) {
        setState(() {
          preloader = false;
        });
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tabviewController = TabController(length: 4, vsync: this);
    id = ModalRoute.of(context)!.settings.arguments as num?;
  }

  @override
  Widget build(BuildContext context) {
    return Preloader(
      safeArea: false,
      preloader: preloader,
      child: Scaffold(
        key: scaffoldKey,
        body: Consumer<ProductsProvider>(
          builder: (context, provider, child) {
            Props props = provider.propsProductDetail;

            if (props.isProcessing) {
              return const SizedBox();
            } else if (props.isError) {
              return const SizedBox();
            } else {
              final data = props.data;
              if (data == null || data == {}) {
                return const SizedBox();
              } else {
                ProductDetails product = data as ProductDetails;

                return SlidingUpPanel(
                  minHeight: fdh * 0.5,
                  maxHeight: fdh * 0.75,
                  borderRadius: BorderRadius.all(Radius.circular(24.h)),
                  body: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: CustomImageView(
                          height: 400.v,
                          fit: BoxFit.cover,
                          width: double.maxFinite,
                          alignment: Alignment.center,
                          imagePath: product.product.thumbnailUrl,
                        ),
                      ),
                      Positioned(
                        top: 38.v,
                        left: 12.h,
                        right: 12.h,
                        child: Row(
                          children: [
                            Consumer<FavouritesProvider>(
                              builder: (context, provider, child) {
                                bool find = provider.findFavourite(id);
                                return IconButton(
                                  onPressed: find == false
                                      ? () async {
                                          await provider.onFavourite(id);
                                        }
                                      : null,
                                  icon: CustomImageView(
                                    size: 38.adaptSize,
                                    imagePath: "heart".icon.svg,
                                    color: find == false
                                        ? appTheme.whiteA700
                                        : appTheme.red300,
                                  ),
                                );
                              },
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                NavigatorService.goBack();
                              },
                              icon: CustomImageView(
                                size: 38.adaptSize,
                                imagePath: "arrow_back".icon.svg,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  footer: Container(
                    height: 100,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: appTheme.amber100,
                    ),
                  ),
                  panelBuilder: (controller) {
                    return Container(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.h,
                        vertical: 16.v,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(24.h)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "best_recomendation".tr,
                            style: CustomTextStyles.labelMediumDeeporange400,
                          ),
                          Text(
                            product.product.name ?? '',
                            style: CustomTextStyles.titleMediumOnErrorContainer,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "\$${product.product.price}: ${"usd".tr}",
                                style: theme.textTheme.titleMedium,
                              ),
                              CustomElevatedButton(
                                height: 30.v,
                                width: 100.h,
                                text: product.product.tags ?? "",
                                leftIcon: Container(
                                  margin: EdgeInsets.only(right: 7.h),
                                  child: CustomImageView(
                                    imagePath: "trophy".icon.svg,
                                  ),
                                ),
                                buttonStyle: CustomButtonStyles.fillYellow,
                                buttonTextStyle:
                                    CustomTextStyles.labelMediumWhiteA70001,
                                alignment: Alignment.bottomRight,
                                onPressed: () async {},
                              )
                            ],
                          ),
                          SizedBox(height: 7.v),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${product.product.rating}',
                                style: CustomTextStyles.titleSmallBluegray500,
                              ),
                              CustomRatingBar(
                                size: 24.adaptSize,
                                initialRating:
                                    product.product.rating?.toDouble(),
                              )
                            ],
                          ),
                          SizedBox(height: 13.v),
                          Row(
                            children: [
                              CustomImageView(
                                imagePath: "marker".icon.svg,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.h),
                                child: Text(
                                  "${"locations".tr}: ${product.product.locations ?? '0'}",
                                  style:
                                      CustomTextStyles.bodySmallBluegray50010,
                                ),
                              ),
                              CustomImageView(
                                imagePath: "loading".icon.svg,
                                margin: EdgeInsets.only(
                                  left: 15.h,
                                  bottom: 2.v,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 6.h),
                                child: Text(
                                  "${"hours".tr}: ${product.product.hours ?? '0'}",
                                  style:
                                      CustomTextStyles.bodySmallBluegray50010,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 16.v),
                          SizedBox(
                            height: 34.v,
                            width: double.maxFinite,
                            child: TabBar(
                              isScrollable: false,
                              labelColor: appTheme.red300,
                              controller: tabviewController,
                              labelPadding: EdgeInsets.zero,
                              indicatorColor: appTheme.red300,
                              dividerColor: Colors.transparent,
                              indicatorPadding: EdgeInsets.zero,
                              indicatorWeight: double.minPositive,
                              automaticIndicatorColorAdjustment: false,
                              unselectedLabelColor: appTheme.blueGray500,
                              physics: const NeverScrollableScrollPhysics(),
                              labelStyle: TextStyle(
                                fontSize: 14.fSize,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                              unselectedLabelStyle: TextStyle(
                                fontSize: 14.fSize,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                              tabs: [
                                Tab(
                                  child: Text(
                                    "about".tr,
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    "review".tr,
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    "photo".tr,
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    "video".tr,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 4.v),
                          Divider(
                            height: 2,
                            color: appTheme.gray500,
                          ),
                          SizedBox(height: 2.v),
                          Expanded(
                            child: TabBarView(
                              controller: tabviewController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                AboutScreen(
                                  itineraries: product.itineraries,
                                  description: product.product.longDescription,
                                ),
                                ReviewTab(
                                  reviews: product.reviews,
                                  statistics: product.statistics,
                                ),
                                PhotosTab(photos: product.photos),
                                VideoTab(
                                  videos: product.videos,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 16.v),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: CustomElevatedButton(
              width: 200.h,
              text: "book_now".tr,
              margin: EdgeInsets.only(
                left: 8.h,
                top: 2.v,
              ),
              onPressed: () {
                if (auth.isAuthorized) {
                  NavigatorService.push(
                    context,
                    const PackageSelectionScreen(),
                    arguments: id,
                  );
                } else {
                  context.read<AuthenticationService>().openBottomSheet();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
