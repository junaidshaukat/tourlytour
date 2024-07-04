import 'package:flutter/material.dart';
import '/core/app_export.dart';

class HorizontalDivider extends StatelessWidget {
  const HorizontalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Divider(
        height: 0.8,
        color: appTheme.gray100,
      ),
    );
  }
}

class LabelReview extends StatelessWidget {
  final num initial;
  final String label;
  final bool readOnly;
  final void Function(double)? onChanged;

  const LabelReview({
    super.key,
    this.onChanged,
    required this.label,
    required this.initial,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.fSize,
            fontFamily: 'Poppins',
            color: appTheme.black900,
            fontWeight: FontWeight.w500,
          ),
        ),
        CustomRatingBar(
          readOnly: readOnly,
          onChanged: onChanged,
          initialRating: initial.toDouble(),
        ),
      ],
    );
  }
}
