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
  final String label;
  final double initial;
  final void Function(double) onChange;
  const LabelReview({
    super.key,
    required this.label,
    required this.initial,
    required this.onChange,
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
        RatingBar.builder(
          minRating: 1,
          itemCount: 5,
          itemSize: 24,
          initialRating: initial,
          allowHalfRating: false,
          onRatingUpdate: onChange,
          direction: Axis.horizontal,
          itemBuilder: (context, _) {
            return const Icon(
              Icons.star,
              color: Colors.amber,
            );
          },
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
        ),
      ],
    );
  }
}
