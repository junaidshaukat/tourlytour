import 'package:flutter/material.dart';
import '/core/app_export.dart';

class NoRecordsFound extends StatelessWidget {
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;

  const NoRecordsFound({
    super.key,
    this.mainAxisSize = MainAxisSize.min,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        CustomImageView(
          imagePath: "empty".icon.svg,
        ),
        SizedBox(height: 16.v),
        Text("no_records_found".tr),
      ],
    );
  }
}
