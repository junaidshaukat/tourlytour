import 'package:flutter/cupertino.dart';
import '/core/app_export.dart';

class CustomProgressButton extends StatelessWidget {
  const CustomProgressButton({
    super.key,
    this.lable = '',
    this.textColor,
    this.fontSize,
    this.indicatorColor = const Color(0XFF000000),
    this.indicator = true,
    this.textStyle,
  });
  final bool indicator;
  final String lable;
  final Color? textColor, indicatorColor;
  final double? fontSize;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (indicator)
          CupertinoActivityIndicator(
            color: indicatorColor,
          ),
        if (indicator) SizedBox(width: 4.adaptSize),
        Text(
          lable,
          style: textStyle ??
              TextStyle(
                fontSize: fontSize,
                color: indicatorColor,
              ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          width: 12.adaptSize,
          child: AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [
              TyperAnimatedText(
                '...',
                textStyle: textStyle ??
                    TextStyle(
                      fontSize: fontSize,
                      color: textColor,
                    ),
                textAlign: TextAlign.center,
                speed: const Duration(milliseconds: 500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
