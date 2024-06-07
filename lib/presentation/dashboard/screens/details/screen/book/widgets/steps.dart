import 'package:flutter/material.dart';
import '/core/app_export.dart';

class BookingSteps extends StatelessWidget {
  final int step;
  final Color? activeColor;
  final Color? activeBorderColor;
  final Color? unActiveColor;
  final Color? unActiveBorderColor;
  final Color? activeLineColor;
  final Color? unActiveLineColor;
  final Color? activeTextColor;
  final Color? unActiveTextColor;

  const BookingSteps({
    super.key,
    this.step = 0,
    this.activeColor = Colors.transparent,
    this.activeBorderColor = const Color(0xFF39D448),
    this.unActiveColor = const Color(0xFFB4FFAD),
    this.unActiveBorderColor = const Color(0xFFB4FFAD),
    this.activeLineColor = const Color(0xFF39D448),
    this.unActiveLineColor = const Color(0xFFB4FFAD),
    this.activeTextColor = const Color(0xFF39D448),
    this.unActiveTextColor = const Color(0xFFB4FFAD),
  });

  Widget circle({Color? color, Color? border}) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(
          width: 3.adaptSize,
          color: border!,
        ),
      ),
    );
  }

  Widget line({
    double? height,
    double? thickness = 1.5,
    double? indent,
    double? endIndent,
    Color? color = const Color(0xFFB4FFAD),
  }) {
    return Divider(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: SizeUtils.width * 0.65,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              circle(
                color: step >= 1 ? activeColor : unActiveColor,
                border: step >= 1 ? activeBorderColor : unActiveBorderColor,
              ),
              Expanded(
                child: line(
                  color: step >= 2 ? activeLineColor : unActiveLineColor,
                ),
              ),
              circle(
                color: step >= 2 ? activeColor : unActiveColor,
                border: step >= 2 ? activeBorderColor : unActiveBorderColor,
              ),
              Expanded(
                child: line(
                  color: step >= 3 ? activeLineColor : unActiveLineColor,
                ),
              ),
              circle(
                color: step >= 3 ? activeColor : unActiveColor,
                border: step >= 3 ? activeBorderColor : unActiveBorderColor,
              ),
            ],
          ),
        ),
        SizedBox(height: 8.v),
        SizedBox(
          width: SizeUtils.width * 0.8,
          child: Row(
            children: [
              Text(
                "package_selection".tr,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10.fSize,
                  color: step >= 1 ? activeTextColor : unActiveTextColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(flex: 4),
              Text(
                "other_information".tr,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10.fSize,
                  color: step >= 2 ? activeTextColor : unActiveTextColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(flex: 8),
              Text(
                "payment".tr,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10.fSize,
                  color: step >= 3 ? activeTextColor : unActiveTextColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        )
      ],
    );
  }
}
