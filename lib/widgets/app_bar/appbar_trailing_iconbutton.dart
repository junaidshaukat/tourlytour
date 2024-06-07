import 'package:flutter/material.dart';
import '/core/app_export.dart';

class AppbarTrailingIconbutton extends StatelessWidget {
  const AppbarTrailingIconbutton({
    super.key,
    this.imagePath,
    this.margin,
    this.onTap,
  });

  final String? imagePath;

  final EdgeInsetsGeometry? margin;

  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: CustomIconButton(
          height: 40.adaptSize,
          width: 40.adaptSize,
          child: CustomImageView(
            imagePath: imagePath,
          ),
        ),
      ),
    );
  }
}
