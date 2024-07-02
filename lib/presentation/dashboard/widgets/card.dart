import 'package:flutter/material.dart';
import '/core/app_export.dart';

class HorizontalProductCard extends StatelessWidget {
  final Products product;
  final void Function()? onPressed;

  const HorizontalProductCard({
    super.key,
    required this.product,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2.adaptSize),
      child: Container(
        padding: EdgeInsets.all(3.adaptSize),
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
                width: 200.h,
                height: 120.v,
                fit: BoxFit.cover,
                imagePath: product.thumbnailUrl,
              ),
            ),
            SizedBox(height: 2.v),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.h),
              child: SizedBox(
                width: 190.h,
                height: 42.v,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: 161.h,
                        child: Text(
                          product.name ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyles.titleSmallOnErrorContainer,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 12.v),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomImageView(
                              imagePath: "star".icon.svg,
                              height: 11.adaptSize,
                              width: 11.adaptSize,
                              margin: EdgeInsets.symmetric(vertical: 3.v),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 4.h),
                              child: Text(
                                '${product.rating ?? '0'}',
                                style: CustomTextStyles.labelLargeBluegray500,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.h),
              child: SizedBox(
                width: 190.h,
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
            ),
            SizedBox(height: 3.v),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.h),
              child: SizedBox(
                width: 190.h,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 120.h,
                          child: Text(
                            "standard_price".tr,
                            style: CustomTextStyles.bodySmallBluegray500Regular,
                          ),
                        ),
                        SizedBox(height: 5.v),
                        SizedBox(
                          width: 120.h,
                          child: Text(
                            '\$${product.standardPrice ?? '0'}',
                            style: CustomTextStyles
                                .bodySmallBluegray500Regular_1
                                .copyWith(
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 60.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomImageView(
                                imagePath: "marker".icon.svg,
                                height: 9.v,
                                width: 7.h,
                                margin: EdgeInsets.symmetric(vertical: 1.v),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 1.h),
                                child: Text(
                                  "${"locations".tr}: ${product.locations ?? '0'}",
                                  style: theme.textTheme.bodySmall,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 5.v),
                        SizedBox(
                          width: 60.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomImageView(
                                imagePath: "loading".icon.svg,
                                height: 9.v,
                                width: 6.h,
                                margin: EdgeInsets.symmetric(vertical: 1.v),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 1.h),
                                child: Text(
                                  "${"hours".tr}: ${product.hours ?? '0'}",
                                  style: theme.textTheme.bodySmall,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 4.v),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.h),
              child: SizedBox(
                width: 190.h,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 120.h,
                      child: Text(
                        "\$${product.price}: ${"usd".tr}",
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    SizedBox(
                      width: 60.h,
                      child: Text(
                        "\$${product.saving}: ${"savings".tr}",
                        style: theme.textTheme.labelSmall,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 3.v),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.h),
              child: SizedBox(
                width: 190.h,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 110.h,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomImageView(
                            imagePath: "compare".icon.svg,
                            height: 9.adaptSize,
                            width: 9.adaptSize,
                            margin: EdgeInsets.only(
                              top: 7.v,
                              bottom: 8.v,
                            ),
                          ),
                          SizedBox(width: 4.h),
                          Text(
                            "compare_packages".tr,
                            style: CustomTextStyles.bodySmallBlueA200Regular,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 78.h,
                      child: CustomElevatedButton(
                        height: 24.v,
                        width: 80.h,
                        text: "view_details".tr,
                        margin: EdgeInsets.only(left: 12.h),
                        buttonStyle: CustomButtonStyles.fillPrimaryTL12,
                        buttonTextStyle: CustomTextStyles.labelSmallBlack900,
                        onPressed: onPressed,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VerticalProductCard extends StatelessWidget {
  final Products product;
  final void Function()? onPressed;

  const VerticalProductCard({
    super.key,
    required this.product,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.v, horizontal: 8.h),
      decoration: AppDecoration.outlineBlack900.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.h),
            child: CustomImageView(
              width: 172.h,
              height: 115.v,
              fit: BoxFit.cover,
              imagePath: product.thumbnailUrl,
              radius: BorderRadius.circular(12.h),
            ),
          ),
          SizedBox(width: 8.h),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 175.h,
                child: Text(
                  product.name ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.labelMediumBlack900,
                ),
              ),
              SizedBox(height: 4.v),
              SizedBox(
                width: 175.h,
                child: Text(
                  product.longDescription ?? '',
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.poppinsBlack900,
                ),
              ),
              SizedBox(height: 2.v),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "read_more".tr,
                      style: CustomTextStyles.bodySmallLightblue500Regular,
                    ),
                    CustomImageView(imagePath: "arrow_forword".icon.svg)
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
