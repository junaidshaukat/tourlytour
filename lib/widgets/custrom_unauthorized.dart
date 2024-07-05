import 'package:flutter/material.dart';
import '/core/app_export.dart';

class Unauthorized extends StatelessWidget {
  final double? width;
  final double? height;
  final String? message;
  final String? imagePath;
  final double? buttonWidth;
  final double? buttonHeight;
  final void Function()? onPressed;

  const Unauthorized({
    super.key,
    this.width,
    this.height,
    this.message,
    this.imagePath,
    this.onPressed,
    this.buttonWidth,
    this.buttonHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomImageView(
          width: width,
          height: height,
          fit: BoxFit.cover,
          imagePath: imagePath ?? "assets/images/404.png",
        ),
        SizedBox(height: 8.v),
        Text(
          message ?? 'try_again'.tr,
          style: CustomTextStyles.bodyMediumRed300,
        ),
        SizedBox(height: 8.v),
        CustomElevatedButton(
          text: 'signin'.tr,
          width: buttonWidth,
          height: buttonHeight,
          onPressed: onPressed,
        ),
      ],
    );
  }
}
