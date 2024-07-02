import 'package:flutter/material.dart';
import '/core/app_export.dart';

extension on TextStyle {
  TextStyle get inter {
    return copyWith(
      fontFamily: 'Inter',
    );
  }

  TextStyle get poppins {
    return copyWith(
      fontFamily: 'Poppins',
    );
  }

  TextStyle get jaldi {
    return copyWith(
      fontFamily: 'Jaldi',
    );
  }
}

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.
class CustomTextStyles {
  // Body text style
  static TextStyle get bodyLargeGray90002 =>
      theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.gray90002,
      );
  static TextStyle get bodyLargeJaldiGray90001 =>
      theme.textTheme.bodyLarge!.jaldi.copyWith(
        color: appTheme.gray90001.withOpacity(0.53),
      );
  static TextStyle get bodyMediumBlack900 =>
      theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w300,
      );
  static TextStyle get bodyMediumBlack900_1 =>
      theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.black900,
      );
  static TextStyle get bodyMediumBlack900_2 =>
      theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.black900.withOpacity(0.46),
      );
  static TextStyle get bodyMediumJaldiBlack900 =>
      theme.textTheme.bodyMedium!.jaldi.copyWith(
        color: appTheme.black900,
      );
  static TextStyle get bodyMediumJaldiBlack900_1 =>
      theme.textTheme.bodyMedium!.jaldi.copyWith(
        color: appTheme.black900.withOpacity(0.6),
      );
  static TextStyle get bodyMediumJaldiBlue500 =>
      theme.textTheme.bodyMedium!.jaldi.copyWith(
        color: appTheme.blue500,
      );
  static TextStyle get bodyMediumJaldiPrimaryContainer =>
      theme.textTheme.bodyMedium!.jaldi.copyWith(
        color: theme.colorScheme.primaryContainer,
      );
  static TextStyle get bodyMediumOnPrimaryContainer =>
      theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
        fontWeight: FontWeight.w300,
      );
  static TextStyle get bodyMediumRed300 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.red300,
      );
  static TextStyle get bodySmallBlack900 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.black900,
        fontSize: 12.fSize,
      );
  static TextStyle get bodySmallBlack900Regular =>
      theme.textTheme.bodySmall!.copyWith(
        color: appTheme.black900,
        fontSize: 10.fSize,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get bodySmallBlue200 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blue200,
        fontSize: 10.fSize,
      );
  static TextStyle get bodySmallBlueA200 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blueA200.withOpacity(0.6),
        fontSize: 12.fSize,
      );
  static TextStyle get bodySmallBlueA200Regular =>
      theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blueA200,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get bodySmallBluegray500 =>
      theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blueGray500,
        fontSize: 12.fSize,
      );
  static TextStyle get bodySmallBluegray50010 =>
      theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blueGray500,
        fontSize: 10.fSize,
      );
  static TextStyle get bodySmallBluegray500Regular =>
      theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blueGray500,
        fontSize: 10.fSize,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get bodySmallBluegray500Regular_1 =>
      theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blueGray500.withOpacity(0.53),
        fontWeight: FontWeight.w400,
      );
  static TextStyle get bodySmallGray600 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray600,
        fontSize: 10.fSize,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get bodySmallGray60001 =>
      theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray60001,
        fontSize: 10.fSize,
      );
  static TextStyle get bodySmallGray90002 =>
      theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray90002,
        fontSize: 12.fSize,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get bodySmallInterBlack900 =>
      theme.textTheme.bodySmall!.inter.copyWith(
        color: appTheme.black900.withOpacity(0.53),
        fontWeight: FontWeight.w400,
      );
  static TextStyle get bodySmallInterBlack900Regular =>
      theme.textTheme.bodySmall!.inter.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get bodySmallLightblue500 =>
      theme.textTheme.bodySmall!.copyWith(
        color: appTheme.lightBlue500,
      );
  static TextStyle get bodySmallLightblue50012 =>
      theme.textTheme.bodySmall!.copyWith(
        color: appTheme.lightBlue500,
        fontSize: 12.fSize,
      );
  static TextStyle get bodySmallLightblue500Regular =>
      theme.textTheme.bodySmall!.copyWith(
        color: appTheme.lightBlue500,
        fontSize: 10.fSize,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get bodySmallOnErrorContainer =>
      theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.onErrorContainer.withOpacity(0.64),
        fontWeight: FontWeight.w400,
      );
  static TextStyle get bodySmallOnErrorContainerRegular =>
      theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.onErrorContainer.withOpacity(1),
        fontSize: 10.fSize,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get bodySmallOnErrorContainerRegular_1 =>
      theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.onErrorContainer,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get bodySmallOnPrimaryContainer =>
      theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
        fontSize: 10.fSize,
        fontWeight: FontWeight.w400,
      );
// Headline text style
  static TextStyle get headlineSmallPoppinsOnErrorContainer =>
      theme.textTheme.headlineSmall!.poppins.copyWith(
        color: theme.colorScheme.onErrorContainer.withOpacity(1),
        fontWeight: FontWeight.w600,
      );
  static TextStyle get headlineSmallPoppinsOnErrorContainerExtraBold =>
      theme.textTheme.headlineSmall!.poppins.copyWith(
        color: theme.colorScheme.onErrorContainer.withOpacity(1),
        fontWeight: FontWeight.w800,
      );
// Label text style
  static TextStyle get labelLargeBluegray500 =>
      theme.textTheme.labelLarge!.copyWith(
        color: appTheme.blueGray500,
      );
  static TextStyle get labelLargeInterBlack900 =>
      theme.textTheme.labelLarge!.inter.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get labelLargeOnErrorContainer =>
      theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.onErrorContainer,
      );
  static TextStyle get labelLargeSemiBold =>
      theme.textTheme.labelLarge!.copyWith(
        fontWeight: FontWeight.w600,
      );
  static TextStyle get labelMediumBlack900 =>
      theme.textTheme.labelMedium!.copyWith(
        color: appTheme.black900,
      );
  static TextStyle get labelMediumBluegray500 =>
      theme.textTheme.labelMedium!.copyWith(
        color: appTheme.blueGray500,
      );
  static TextStyle get labelMediumDeeporange400 =>
      theme.textTheme.labelMedium!.copyWith(
        color: appTheme.deepOrange400,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get labelMediumGray900 =>
      theme.textTheme.labelMedium!.copyWith(
        color: appTheme.gray900,
      );
  static TextStyle get labelMediumLightblue500 =>
      theme.textTheme.labelMedium!.copyWith(
        color: appTheme.lightBlue500,
      );
  static TextStyle get labelMediumRedA200a2 =>
      theme.textTheme.labelMedium!.copyWith(
        color: appTheme.redA200A2,
      );
  static TextStyle get labelMediumSemiBold =>
      theme.textTheme.labelMedium!.copyWith(
        fontWeight: FontWeight.w600,
      );
  static TextStyle get labelMediumWhiteA70001 =>
      theme.textTheme.labelMedium!.copyWith(
        color: appTheme.whiteA70001,
      );
  static TextStyle get labelMediumBlue500 =>
      theme.textTheme.labelMedium!.copyWith(
        color: appTheme.blue500,
        fontSize: 14.fSize,
      );
  static TextStyle get labelSmallBlack900 =>
      theme.textTheme.labelSmall!.copyWith(
        color: appTheme.black900,
      );
  static TextStyle get labelSmallInterOnPrimaryContainer =>
      theme.textTheme.labelSmall!.inter.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
        fontWeight: FontWeight.w600,
      );
// Poppins text style
  static TextStyle get poppinsBlack900 => TextStyle(
        color: appTheme.black900,
        fontSize: 7.fSize,
        fontWeight: FontWeight.w400,
      ).poppins;
  static TextStyle get poppinsLightblue500 => TextStyle(
        color: appTheme.lightBlue500,
        fontSize: 7.fSize,
        fontWeight: FontWeight.w500,
      ).poppins;
  static TextStyle get poppinsWhiteA70001 => TextStyle(
        color: appTheme.whiteA70001,
        fontSize: 6.fSize,
        fontWeight: FontWeight.w600,
      ).poppins;
// Title text style
  static TextStyle get titleLargeBlack900 =>
      theme.textTheme.titleLarge!.copyWith(
        color: appTheme.black900,
      );
  static TextStyle get titleLargeGray90001 =>
      theme.textTheme.titleLarge!.copyWith(
        color: appTheme.gray90001.withOpacity(0.53),
      );
  static TextStyle get titleLargeWhite900 =>
      theme.textTheme.titleLarge!.copyWith(
        color: appTheme.whiteA700,
      );
  static TextStyle get titleLargePoppinsGray90002 =>
      theme.textTheme.titleLarge!.poppins.copyWith(
        color: appTheme.gray90002,
      );
  static TextStyle get titleLargePoppinsOnErrorContainer =>
      theme.textTheme.titleLarge!.poppins.copyWith(
        color: theme.colorScheme.onErrorContainer.withOpacity(1),
        fontWeight: FontWeight.w500,
      );
  static TextStyle get titleMediumBluegray500 =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.blueGray500,
      );
  static TextStyle get titleMediumDeeporange400 =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.deepOrange400,
      );
  static TextStyle get titleMediumOnErrorContainer =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onErrorContainer.withOpacity(1),
        fontSize: 18.fSize,
      );
  static TextStyle get titleSmallBluegray500 =>
      theme.textTheme.titleSmall!.copyWith(
        color: appTheme.blueGray500,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleSmallGray90002 =>
      theme.textTheme.titleSmall!.copyWith(
        color: appTheme.gray90002,
      );
  static TextStyle get titleSmallOnErrorContainer =>
      theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.onErrorContainer.withOpacity(1),
      );
  static TextStyle get titleSmallOnErrorContainerSemiBold =>
      theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.onErrorContainer.withOpacity(1),
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleSmallOnPrimaryContainer =>
      theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleSmallSemiBold =>
      theme.textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w600,
      );
}
