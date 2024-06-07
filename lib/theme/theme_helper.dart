import 'package:flutter/material.dart';
import '/core/app_export.dart';

LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

/// Helper class for managing themes and colors.
class ThemeHelper {
  // The current app theme
  final _appTheme = PrefUtils().getThemeData();

// A map of custom color themes supported by the app
  final Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors()
  };

// A map of color schemes supported by the app
  final Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme
  };

  /// Returns the lightCode colors for the current theme.
  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      visualDensity: VisualDensity.standard,
      textTheme: TextThemes.textTheme(colorScheme),
      scaffoldBackgroundColor: colorScheme.onPrimaryContainer,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: BorderSide(
            color: appTheme.blueA200,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimaryContainer;
          }
          return Colors.transparent;
        }),
        visualDensity: const VisualDensity(
          vertical: -4,
          horizontal: -4,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimaryContainer;
          }
          return Colors.transparent;
        }),
        side: BorderSide(
          color: appTheme.gray90001,
          width: 1,
        ),
        visualDensity: const VisualDensity(
          vertical: -4,
          horizontal: -4,
        ),
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        space: 1,
        color: appTheme.black900.withOpacity(0.42),
      ),
    );
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

/// Class containing the supported text theme styles.
class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
        bodyLarge: TextStyle(
          color: appTheme.black900,
          fontSize: 16.fSize,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: appTheme.blueGray500,
          fontSize: 14.fSize,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: appTheme.gray50001,
          fontSize: 8.fSize,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w300,
        ),
        headlineSmall: TextStyle(
          color: appTheme.gray90001,
          fontSize: 24.fSize,
          fontFamily: 'Jaldi',
          fontWeight: FontWeight.w400,
        ),
        labelLarge: TextStyle(
          color: colorScheme.onErrorContainer.withOpacity(1),
          fontSize: 12.fSize,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          color: colorScheme.onErrorContainer.withOpacity(1),
          fontSize: 10.fSize,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: appTheme.deepOrange40001,
          fontSize: 8.fSize,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
        titleLarge: TextStyle(
          color: colorScheme.primaryContainer.withOpacity(0.46),
          fontSize: 20.fSize,
          fontFamily: 'Jaldi',
          fontWeight: FontWeight.w400,
        ),
        titleMedium: TextStyle(
          color: appTheme.blueGray900,
          fontSize: 16.fSize,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: appTheme.black900,
          fontSize: 14.fSize,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
      );
}

/// Class containing the supported color schemes.
class ColorSchemes {
  static const lightCodeColorScheme = ColorScheme.light(
    primary: Color(0XFFFFC600),
    primaryContainer: Color(0XFF482F91),
    secondaryContainer: Color(0XFF04009A),
    errorContainer: Color(0XFFC067E0),
    onErrorContainer: Color(0X87121212),
    onPrimary: Color(0XFF142359),
    onPrimaryContainer: Color(0XFFFFFFFF),
    onSecondaryContainer: Color(0XFF0D6EFD),
  );
}

/// Class containing custom colors for a lightCode theme.
class LightCodeColors {
  Color get primary => const Color(0XFFFFC600);

  // Amber
  Color get amber100 => const Color(0XFFFFEFB7);
// Black
  Color get black900 => const Color(0XFF000000);
// Blue
  Color get blue200 => const Color(0XFF98B7FF);
  Color get blue50 => const Color(0XFFEDF7FF);
  Color get blue500 => const Color(0XFF198CF5);
  Color get blue5001 => const Color(0XFFE9EFFF);
  Color get blue5002 => const Color(0XFFECF7FF);
  Color get blue600 => const Color(0XFF3498D8);
  Color get blue60001 => const Color(0XFF3498DB);
  Color get blueA200 => const Color(0XFF6090FF);
// BlueAf
  Color get blueA2007f => const Color(0X7F4277FF);
// BlueGray
  Color get blueGray100 => const Color(0XFFD9D9D9);
  Color get blueGray400 => const Color(0XFF7697B3);
  Color get blueGray40001 => const Color(0XFF888888);
  Color get blueGray500 => const Color(0XFF6F7789);
  Color get blueGray900 => const Color(0XFF353535);
// DeepOrange
  Color get deepOrange400 => const Color(0XFFEE684A);
  Color get deepOrange40001 => const Color(0XFFF08740);
// Gray
  Color get gray100 => const Color(0XFFF0F6FD);
  Color get gray500 => const Color(0XFFA8A8A8);
  Color get gray50001 => const Color(0XFFA5A5A5);
  Color get gray600 => const Color(0XFF7E7F80);
  Color get gray60001 => const Color(0XFF6D6D6D);
  Color get gray60002 => const Color(0XFF777C80);
  Color get gray800 => const Color(0XFF424242);
  Color get gray900 => const Color(0XFF1E1E1E);
  Color get gray90001 => const Color(0XFF252525);
  Color get gray90002 => const Color(0XFF242424);
// Green
  Color get green500 => const Color(0XFF39D448);
  Color get greenA100 => const Color(0XFFB3FFAD);
// Indigo
  Color get indigoA100 => const Color(0XFF8D9CF4);
// LightBlue
  Color get lightBlue500 => const Color(0XFF00A3FF);
  Color get lightBlue900 => const Color(0XFF005BAC);
// Lime
  Color get lime900 => const Color(0XFF9F6D00);
// Orange
  Color get orangeA700 => const Color(0XFFFF6600);
// Pink
  Color get pink500 => const Color(0XFFFF2C5F);
// Red
  Color get red300 => const Color(0XFFF36D72);
  Color get redA100 => const Color(0XFFFF7979);
  Color get redA700 => const Color(0XFFFF0000);
// RedA
  Color get redA200A2 => const Color(0XA2FF4E55);
// White
  Color get whiteA700 => const Color(0XFFFBFDFF);
  Color get whiteA70001 => const Color(0XFFFCFEFF);
// Yellow
  Color get yellow800 => const Color(0XFFF6AC1D);
  Color get yellow80001 => const Color(0XFFEEAA14);
  Color get yellow80002 => const Color(0XFFF6AB27);
}
