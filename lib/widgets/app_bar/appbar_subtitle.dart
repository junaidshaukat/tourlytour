import 'package:flutter/material.dart';
import '/core/app_export.dart';

class AppbarSubtitle extends StatelessWidget {
  const AppbarSubtitle({
    super.key,
    required this.text,
    this.margin,
    this.onTap,
  });

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
          style: CustomTextStyles.titleSmallOnErrorContainer.copyWith(
            color: theme.colorScheme.onErrorContainer.withOpacity(1),
          ),
        ),
      ),
    );
  }
}
