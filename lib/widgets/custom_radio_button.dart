import 'package:flutter/material.dart';
import '/core/app_export.dart';

class CustomRadioButton extends StatelessWidget {
  const CustomRadioButton(
      {super.key,
      required this.onChange,
      this.decoration,
      this.alignment,
      this.isRightCheck,
      this.iconSize,
      this.value,
      this.groupValue,
      this.text,
      this.width,
      this.padding,
      this.textStyle,
      this.textAlignment,
      this.gradient,
      this.backgroundColor});

  final BoxDecoration? decoration;

  final Alignment? alignment;

  final bool? isRightCheck;

  final double? iconSize;

  final String? value;

  final String? groupValue;

  final Function(String) onChange;

  final String? text;

  final double? width;

  final EdgeInsetsGeometry? padding;

  final TextStyle? textStyle;

  final TextAlign? textAlignment;

  final Gradient? gradient;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: buildRadioButtonWidget)
        : buildRadioButtonWidget;
  }

  bool get isGradient => gradient != null;
  BoxDecoration get gradientDecoration => BoxDecoration(gradient: gradient);
  Widget get buildRadioButtonWidget => GestureDetector(
        onTap: () {
          onChange(value!);
        },
        child: Container(
          decoration: decoration,
          width: width,
          padding: padding,
          child: (isRightCheck ?? false)
              ? rightSideRadioButton
              : leftSideRadioButton,
        ),
      );
  Widget get leftSideRadioButton => Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: radioButtonWidget,
          ),
          textWidget
        ],
      );
  Widget get rightSideRadioButton => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          textWidget,
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: radioButtonWidget,
          )
        ],
      );
  Widget get textWidget => Text(
        text ?? "",
        textAlign: textAlignment ?? TextAlign.start,
        style: textStyle ?? theme.textTheme.labelMedium,
      );
  Widget get radioButtonWidget => SizedBox(
        height: iconSize ?? 12.h,
        width: iconSize ?? 12.h,
        child: Radio<String>(
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          value: value ?? "",
          groupValue: groupValue,
          onChanged: (value) {
            onChange(value!);
          },
        ),
      );
  BoxDecoration get radioButtonDecoration =>
      BoxDecoration(color: backgroundColor);
}
