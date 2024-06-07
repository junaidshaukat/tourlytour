import 'package:flutter/material.dart';
import '/core/app_export.dart';

class AppbarTitleImage extends StatelessWidget {
  const AppbarTitleImage({super.key, this.imagePath, this.margin, this.onTap});

  final String? imagePath;

  final EdgeInsetsGeometry? margin;

  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap?.call();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: CustomImageView(
          imagePath: imagePath!,
          height: 15.v,
          width: 7.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
