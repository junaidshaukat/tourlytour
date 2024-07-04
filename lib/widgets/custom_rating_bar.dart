import 'package:flutter/material.dart';
import '/core/app_export.dart';

class CustomRatingBar extends StatelessWidget {
  const CustomRatingBar({
    super.key,
    this.alignment,
    this.size = 32,
    this.onChanged,
    this.maxRating = 5,
    this.halfFilledIcon,
    this.readOnly = true,
    this.initialRating = 1.0,
    this.isHalfAllowed = false,
    this.filledIcon = Icons.star,
    this.direction = Axis.horizontal,
    this.emptyIcon = Icons.star_border,
    this.filledColor = const Color(0XFFF6AC1D),
    this.emptyColor = const Color(0xFFC3DBF3),
    this.halfFilledColor = const Color(0XFFF6AC1D),
  });

  final bool readOnly;
  final Alignment? alignment;
  final IconData filledIcon;
  final IconData emptyIcon;
  final int maxRating;
  final IconData? halfFilledIcon;
  final bool isHalfAllowed;
  final Axis direction;
  final double? initialRating;
  final Color filledColor;
  final Color emptyColor;
  final Color halfFilledColor;
  final double size;
  final void Function(double)? onChanged;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center, child: ratingBarWidget)
        : ratingBarWidget;
  }

  Widget get ratingBarWidget {
    if (readOnly) {
      return RatingBar.readOnly(
        size: size,
        emptyIcon: emptyIcon,
        maxRating: maxRating,
        direction: direction,
        emptyColor: emptyColor,
        filledIcon: filledIcon,
        filledColor: filledColor,
        isHalfAllowed: isHalfAllowed,
        halfFilledIcon: halfFilledIcon,
        halfFilledColor: halfFilledColor,
        initialRating: initialRating ?? 0.0,
        alignment: alignment ?? Alignment.centerLeft,
      );
    }

    return RatingBar(
      size: size,
      emptyIcon: emptyIcon,
      maxRating: maxRating,
      direction: direction,
      emptyColor: emptyColor,
      filledIcon: filledIcon,
      filledColor: filledColor,
      onRatingChanged: onChanged,
      isHalfAllowed: isHalfAllowed,
      halfFilledIcon: halfFilledIcon,
      halfFilledColor: halfFilledColor,
      initialRating: initialRating ?? 0.0,
      alignment: alignment ?? Alignment.centerLeft,
    );
  }
}
