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

  late TabController tabviewController;
  late ProductVideosProvider videos;
  late ProductPhotosProvider photos;
  late ProductReviewsProvider reviews;
  late StripeProvider stripe;
  late ProductItinerariesProvider itineraries;
  late Products product;

  late ProductsDetailsProvider productsDetails;
  late AuthenticationProvider auth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      productsDetails = context.read<ProductsDetailsProvider>();
      auth = context.read<AuthenticationProvider>();

      videos = context.read<ProductVideosProvider>();
      photos = context.read<ProductPhotosProvider>();
      reviews = context.read<ProductReviewsProvider>();
      itineraries = context.read<ProductItinerariesProvider>();
      stripe = context.read<StripeProvider>();
      await videos.onReady(product.id);
      await photos.onReady(product.id);
      await reviews.onReady(product.id);
      await itineraries.onReady(product.id);
      await productsDetails.onReady(product.id);

      setState(() {
        preloader = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tabviewController = TabController(length: 4, vsync: this);
    product = ModalRoute.of(context)!.settings.arguments as Products;
  }

  @override
  Widget build(BuildContext context) {
    return Preloader(
      safeArea: false,
      preloader: preloader,
      child: Scaffold(
        key: scaffoldKey,
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
                imagePath: product.thumbnailUrl,
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
                      bool find = provider.findFavourite(product.id);
                      return IconButton(
                        onPressed: find == false
                            ? () async {
                                await provider.onFavourite(product.id);
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
            ),
            SlidingUpPanel(
              maxHeight: 750.v,
              minHeight: 500.v,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.adaptSize),
                topRight: Radius.circular(30.adaptSize),
              ),
              panel: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.v),
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
                      product.name ?? '',
                      style: CustomTextStyles.titleMediumOnErrorContainer,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${product.price}: ${"usd".tr}",
                          style: theme.textTheme.titleMedium,
                        ),
                        CustomElevatedButton(
                          height: 30.v,
                          width: 100.h,
                          text: product.tags ?? "",
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
                          '${product.rating}',
                          style: CustomTextStyles.titleSmallBluegray500,
                        ),
                        CustomRatingBar(
                          size: 24.adaptSize,
                          initialRating: product.rating?.toDouble(),
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
                            "${"locations".tr}: ${product.locations ?? '0'}",
                            style: CustomTextStyles.bodySmallBluegray50010,
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
                            "${"hours".tr}: ${product.hours ?? '0'}",
                            style: CustomTextStyles.bodySmallBluegray50010,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 16.v),
                    SizedBox(
                      height: 34.v,
                      width: 383.h,
                      child: TabBar(
                        isScrollable: false,
                        indicatorPadding: EdgeInsets.zero,
                        indicatorWeight: double.minPositive,
                        dividerColor: Colors.transparent,
                        automaticIndicatorColorAdjustment: false,
                        controller: tabviewController,
                        labelPadding: EdgeInsets.zero,
                        labelColor: appTheme.red300,
                        labelStyle: TextStyle(
                          fontSize: 14.fSize,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                        unselectedLabelColor: appTheme.blueGray500,
                        unselectedLabelStyle: TextStyle(
                          fontSize: 14.fSize,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                        indicatorColor: appTheme.red300,
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
                    SizedBox(
                      height: 500.v,
                      child: TabBarView(
                        controller: tabviewController,
                        children: [
                          AboutScreen(product: product),
                          ReviewTab(product: product),
                          PhotosTab(product: product),
                          VideoTab(product: product),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 10.v,
              left: 96.h,
              right: 96.h,
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
                      arguments: product,
                    );
                  } else {
                    context.read<AuthenticationService>().onSignin();
                  }
                },
                alignment: Alignment.topLeft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
