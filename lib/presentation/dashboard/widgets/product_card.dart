import 'package:flutter/material.dart';
import '/core/app_export.dart';

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
                          size: 14.adaptSize,
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
                          size: 14.adaptSize,
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
                          size: 14.adaptSize,
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
                        size: 10.adaptSize,
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
