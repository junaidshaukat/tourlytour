import 'package:flutter/material.dart';
import '/core/app_export.dart';

class FeaturedPackgesScreen extends StatefulWidget {
  const FeaturedPackgesScreen({super.key});

  @override
  FeaturedPackgesScreenState createState() => FeaturedPackgesScreenState();
}

class FeaturedPackgesScreenState extends State<FeaturedPackgesScreen> {
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

  void onPressed(Products product) {
    context.read<ProductVideosProvider>().clear();
    context.read<ProductPhotosProvider>().clear();
    context.read<ProductReviewsProvider>().clear();
    context.read<ProductItinerariesProvider>().clear();

    NavigatorService.push(
      context,
      const ProductDetailsScreen(),
      arguments: product,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Preloader(
      preloader: preloader,
      child: Scaffold(
        backgroundColor: appTheme.blue50,
        appBar: CustomAppBar(
          centerTitle: false,
          title: Padding(
            padding: EdgeInsets.only(left: 16.h),
            child: AppbarTitle(
              text: "featured_packges".tr,
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
        body: Consumer<ProductsProvider>(
          builder: (context, provider, child) {
            Props props = provider.props;
            if (props.isNone || props.isLoading) {
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
              List data = props.data as List;
              if (data.isEmpty) {
                return SizedBox(
                  height: 135.v,
                  child: const Center(
                    child: NoRecordsFound(),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: (data.length / 2).ceil(),
                itemBuilder: (context, index) {
                  final firstIndex = index * 2;
                  final secondIndex = index * 2 + 1;
                  if (secondIndex >= data.length) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ProductCard(
                          width: 190,
                          product: data[firstIndex],
                          onPressed: () {
                            onPressed(data[firstIndex]);
                          },
                        ),
                      ],
                    );
                  } else {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ProductCard(
                            product: data[firstIndex],
                            onPressed: () {
                              onPressed(data[firstIndex]);
                            },
                          ),
                        ),
                        Expanded(
                          child: ProductCard(
                            product: data[secondIndex],
                            onPressed: () {
                              onPressed(data[secondIndex]);
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final num width;
  final Products product;
  final void Function()? onPressed;

  const ProductCard({
    super.key,
    required this.product,
    this.width = 180,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.h, vertical: 6.v),
      child: Container(
        width: width.h,
        constraints: BoxConstraints(
          minWidth: width.h,
          maxWidth: width.h,
        ),
        padding: EdgeInsets.all(4.adaptSize),
        decoration: AppDecoration.outlineBlack900.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.h),
              child: CustomImageView(
                width: width.h,
                height: 122.v,
                fit: BoxFit.cover,
                imagePath: product.thumbnailUrl,
              ),
            ),
            SizedBox(height: 3.v),
            SizedBox(
              width: width.h,
              height: 40.v,
              child: Text(
                product.name ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: CustomTextStyles.titleSmallOnErrorContainer,
              ),
            ),
            SizedBox(
              width: width.h,
              height: 30.v,
              child: SeeMore(
                product.shortDescription ?? '',
                trimMode: TrimMode.line,
                trimLines: 2,
                trimCollapsedText: 'see_more'.tr,
                trimExpandedText: 'see_less'.tr,
                style: CustomTextStyles.poppinsBlack900,
                moreStyle: CustomTextStyles.poppinsLightblue500,
              ),
            ),
            SizedBox(height: 3.v),
            SizedBox(
              width: width.h,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "rating".tr,
                    style: CustomTextStyles.bodySmallBluegray500Regular,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 64.h,
                    child: Row(
                      children: [
                        CustomImageView(
                          imagePath: "star".icon.svg,
                        ),
                        SizedBox(width: 2.h),
                        Text(
                          '${product.rating ?? '0'}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.v),
            SizedBox(
              width: width.h,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "standard_price".tr,
                    style: CustomTextStyles.bodySmallBluegray500Regular,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 64.h,
                    child: Row(
                      children: [
                        CustomImageView(
                          imagePath: "marker".icon.svg,
                        ),
                        SizedBox(width: 2.h),
                        Text(
                          "${"locations".tr}: ${product.locations ?? '0'}",
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.v),
            SizedBox(
              width: width.h,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$${product.standardPrice ?? '0'}',
                    style:
                        CustomTextStyles.bodySmallBluegray500Regular_1.copyWith(
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 64.h,
                    child: Row(
                      children: [
                        CustomImageView(
                          imagePath: "loading".icon.svg,
                        ),
                        SizedBox(width: 2.h),
                        Text(
                          "${"hours".tr}: ${product.hours ?? '0'}",
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.v),
            SizedBox(
              width: width.h,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "\$${product.price}: ${"usd".tr}",
                    style: theme.textTheme.titleMedium,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 64.h,
                    child: Text(
                      "\$${product.saving}: ${"savings".tr}",
                      style: theme.textTheme.labelSmall,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: width.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 4.v),
                  CustomElevatedButton(
                    height: 24.v,
                    width: 88.h,
                    text: "view_details".tr,
                    margin: EdgeInsets.only(left: 12.h),
                    buttonStyle: CustomButtonStyles.fillPrimaryTL12,
                    buttonTextStyle: CustomTextStyles.labelSmallBlack900,
                    onPressed: onPressed,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomImageView(
                        width: 9.adaptSize,
                        height: 9.adaptSize,
                        imagePath: "compare".icon.svg,
                        margin: EdgeInsets.only(
                          top: 7.v,
                          bottom: 8.v,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 5.h,
                          top: 7.v,
                          bottom: 4.v,
                        ),
                        child: Text(
                          "compare_packages".tr,
                          style: CustomTextStyles.bodySmallBlueA200Regular,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
