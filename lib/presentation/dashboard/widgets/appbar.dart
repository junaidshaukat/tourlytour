import 'package:flutter/material.dart';
import '/core/app_export.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  final void Function()? onPressed;
  final void Function()? onTap;

  const Appbar({super.key, this.onPressed, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 12.v,
      ),
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(
          horizontal: 6.h,
          vertical: 6.v,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimaryContainer,
          borderRadius: BorderRadius.circular(
            10.h,
          ),
          boxShadow: [
            BoxShadow(
              color: appTheme.black900.withOpacity(0.25),
              spreadRadius: 1.h,
              blurRadius: 1.h,
              offset: const Offset(
                1,
                1,
              ),
            )
          ],
        ),
        child: Row(
          children: [
            CustomImageView(
              size: 30.adaptSize,
              imagePath: "menu".icon.svg,
              onTap: onPressed,
            ),
            const Spacer(),
            Row(
              children: [
                CustomImageView(
                  size: 30.adaptSize,
                  imagePath: "logo".icon.svg,
                ),
                Text(
                  "tourly_tours".tr,
                  style: CustomTextStyles.bodySmallGray90002.copyWith(
                    color: appTheme.gray90002,
                  ),
                )
              ],
            ),
            const Spacer(),
            Consumer<CurrentUserProvider>(
                builder: (BuildContext context, provider, Widget? child) {
              return CircleAvatar(
                radius: 18,
                backgroundColor: appTheme.gray500,
                child: CustomImageView(
                  onTap: onTap,
                  fit: BoxFit.cover,
                  width: 34.adaptSize,
                  height: 34.adaptSize,
                  imagePath: provider.avatar,
                  placeHolder: 'profile'.image.png,
                  radius: BorderRadius.circular(100),
                ),
              );
            })
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(
        SizeUtils.width,
        100.v,
      );
}
