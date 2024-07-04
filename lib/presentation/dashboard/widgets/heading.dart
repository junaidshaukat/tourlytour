import 'package:flutter/material.dart';
import '/core/app_export.dart';

class Heading extends StatelessWidget {
  final void Function()? onPressed;

  const Heading({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 238.h,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "drive_your_bangkok2".tr,
                    style:
                        CustomTextStyles.headlineSmallPoppinsOnErrorContainer,
                  ),
                  TextSpan(
                    text: "adventure".tr,
                    style: CustomTextStyles.titleMediumBluegray500,
                  )
                ],
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            width: 230.h,
            child: Text(
              "whispers_of_ancient2".tr,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyles.bodySmallBluegray500Regular,
            ),
          ),
          SizedBox(height: 10.v),
          Padding(
            padding: EdgeInsets.only(right: 10.h),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: AppDecoration.outlineBlueAF.copyWith(
                      borderRadius: BorderRadiusStyle.circleBorder23,
                    ),
                    child: GestureDetector(
                      onTap: onPressed,
                      child: Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(
                          horizontal: 19.h,
                          vertical: 7.v,
                        ),
                        decoration: AppDecoration.outlineBlueAF.copyWith(
                          borderRadius: BorderRadiusStyle.circleBorder23,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            CustomImageView(
                              imagePath: "location".icon.svg,
                              margin: EdgeInsets.symmetric(vertical: 4.v),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 12.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "where".tr,
                                    style: CustomTextStyles
                                        .bodySmallLightblue50012,
                                  ),
                                  Text(
                                    "search_destination".tr,
                                    style:
                                        CustomTextStyles.bodySmallLightblue500,
                                  )
                                ],
                              ),
                            ),
                            const Spacer(),
                            Opacity(
                              opacity: 0.2,
                              child: SizedBox(
                                height: 28.v,
                                child: VerticalDivider(
                                  width: 2.h,
                                  thickness: 2.v,
                                  color:
                                      appTheme.lightBlue500.withOpacity(0.42),
                                ),
                              ),
                            ),
                            CustomImageView(
                              imagePath: "calander".icon.svg,
                              margin: EdgeInsets.only(
                                left: 18.h,
                                top: 5.v,
                                bottom: 5.v,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 12.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "when".tr,
                                    style: CustomTextStyles
                                        .bodySmallLightblue50012,
                                  ),
                                  Text(
                                    "select_dates".tr,
                                    style:
                                        CustomTextStyles.bodySmallLightblue500,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.h),
                  child: InkWell(
                    onTap: onPressed,
                    child: CustomIconButton(
                      height: 46.adaptSize,
                      width: 46.adaptSize,
                      padding: EdgeInsets.all(12.h),
                      decoration: IconButtonStyleHelper.fillBlueGray,
                      child: CustomImageView(
                        imagePath: "search".icon.svg,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
