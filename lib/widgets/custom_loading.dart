import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final double? size;
  final double? value;
  final Color? backgroundColor;
  final Color? color;
  final Animation<Color?>? valueColor;
  final double strokeWidth;
  final double strokeAlign;
  final String? semanticsLabel;
  final String? semanticsValue;
  final StrokeCap? strokeCap;

  const Loading({
    super.key,
    this.size = 24,
    this.value,
    this.backgroundColor,
    this.color,
    this.valueColor,
    this.strokeWidth = 2.0,
    this.strokeAlign = 1.0,
    this.semanticsLabel,
    this.semanticsValue,
    this.strokeCap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          value: value,
          color: color,
          strokeCap: strokeCap,
          valueColor: valueColor,
          strokeAlign: strokeAlign,
          strokeWidth: strokeWidth,
          semanticsLabel: semanticsLabel,
          semanticsValue: semanticsValue,
          backgroundColor: backgroundColor,
        ),
      ),
    );
  }
}
