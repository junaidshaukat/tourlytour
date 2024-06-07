import 'package:flutter/material.dart';
import '/core/app_export.dart';

class FeaturedPackage extends StatelessWidget {
  final void Function()? onPressed;
  const FeaturedPackage({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 10.h,
        right: 13.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "featured_packges".tr,
            style: CustomTextStyles.titleSmallOnErrorContainer,
          ),
          GestureDetector(
            onTap: onPressed,
            child: Padding(
              padding: EdgeInsets.only(bottom: 5.v),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "see_more".tr,
                    style: CustomTextStyles.labelMediumLightblue500,
                  ),
                  CustomImageView(
                    imagePath: "arrow-forword".icon.svg,
                    margin: EdgeInsets.only(
                      left: 2.h,
                      top: 7.v,
                      bottom: 6.v,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
