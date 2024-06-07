import 'package:flutter/material.dart';
import '/core/app_export.dart';

class AppbarTitle extends StatelessWidget {
  const AppbarTitle({
    super.key,
    required this.text,
    this.margin,
    this.onTap,
    this.color,
  });

  final String text;

  final EdgeInsetsGeometry? margin;

  final Function? onTap;

  final Color? color;

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
          style: CustomTextStyles.titleLargePoppinsOnErrorContainer.copyWith(
            color: color ?? theme.colorScheme.onErrorContainer.withOpacity(1),
          ),
        ),
      ),
    );
  }
}
