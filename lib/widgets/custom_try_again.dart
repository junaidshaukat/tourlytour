import 'package:flutter/material.dart';
import '/core/app_export.dart';

class TryAgain extends StatelessWidget {
  final double? width;
  final double? height;
  final String? imagePath;
  final String? message;

  final Future<void> Function() onRefresh;

  const TryAgain({
    super.key,
    this.width,
    this.height,
    this.imagePath,
    required this.onRefresh,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onRefresh,
      radius: 20,
      child: Center(
        child: RefreshIndicator.adaptive(
          onRefresh: onRefresh,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                message ?? 'try_again'.tr,
                style: CustomTextStyles.bodyMediumRed300,
              ),
              SizedBox(height: 8.v),
              CustomImageView(
                imagePath: imagePath,
              )
            ],
          ),
        ),
      ),
    );
  }
}
