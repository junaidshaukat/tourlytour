import 'package:flutter/material.dart';
import '/core/app_export.dart';

class AppbarSubtitleOne extends StatelessWidget {
  const AppbarSubtitleOne(
      {super.key, required this.text, this.margin, this.onTap});

  final String text;

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
        child: Text(
          text,
          style: CustomTextStyles.bodySmallGray90002.copyWith(
            color: appTheme.gray90002,
          ),
        ),
      ),
    );
  }
}
