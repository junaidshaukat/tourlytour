import 'package:flutter/material.dart';
import '/core/app_export.dart';

class FeaturedPackage extends StatelessWidget {
  final void Function()? onPressed;
  const FeaturedPackage({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: Row(
        children: [
          Text(
            "featured_packges".tr,
            style: CustomTextStyles.titleSmallOnErrorContainer,
          ),
          const Spacer(),
          GestureDetector(
            onTap: onPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "see_more".tr,
                  style: CustomTextStyles.labelMediumLightblue500,
                ),
                SizedBox(width: 2.h),
                SvgPicture.asset("arrow-forword".icon.svg)
              ],
            ),
          )
        ],
      ),
    );
  }
}
