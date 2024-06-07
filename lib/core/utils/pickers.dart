import 'dart:io';
import 'package:flutter/material.dart';

import '/core/app_export.dart';

class Pickers {
  static Future<File?> media({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    bool requestFullMetadata = true,
  }) {
    ImagePicker picker = ImagePicker();
    return picker
        .pickMedia(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      requestFullMetadata: requestFullMetadata,
    )
        .then((file) {
      if (file != null) {
        return File(file.path);
      } else {
        return null;
      }
    });
  }

  static Future<File?> image({
    bool gallery = true,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) {
    ImagePicker picker = ImagePicker();
    ImageSource source = gallery ? ImageSource.gallery : ImageSource.camera;
    return picker
        .pickImage(
      source: source,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      preferredCameraDevice: preferredCameraDevice,
      requestFullMetadata: requestFullMetadata,
    )
        .then((file) {
      if (file != null) {
        return File(file.path);
      } else {
        return null;
      }
    });
  }

  static Future<File?> video({
    bool gallery = true,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    Duration? maxDuration,
  }) {
    ImagePicker picker = ImagePicker();
    ImageSource source = gallery ? ImageSource.gallery : ImageSource.camera;
    return picker
        .pickVideo(
      source: source,
      preferredCameraDevice: preferredCameraDevice,
      maxDuration: maxDuration,
    )
        .then((file) {
      if (file != null) {
        return File(file.path);
      } else {
        return null;
      }
    });
  }

  static Future<List<File>> multiImage({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    int? limit,
    bool requestFullMetadata = true,
  }) {
    ImagePicker picker = ImagePicker();
    return picker
        .pickMultiImage(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      limit: limit,
      requestFullMetadata: requestFullMetadata,
    )
        .then((files) {
      if (files.isNotEmpty) {
        return files.map((file) => File(file.path)).toList();
      } else {
        return [];
      }
    });
  }

  static Future<List<File>> multipleMedia({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    int? limit,
    bool requestFullMetadata = true,
  }) {
    ImagePicker picker = ImagePicker();
    return picker
        .pickMultipleMedia(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      limit: limit,
      requestFullMetadata: requestFullMetadata,
    )
        .then((files) {
      if (files.isNotEmpty) {
        return files.map((file) => File(file.path)).toList();
      } else {
        return [];
      }
    });
  }

  static Future<DateTime?> date(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? currentDate,
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
    bool Function(DateTime)? selectableDayPredicate,
    String? helpText,
    String? cancelText,
    String? confirmText,
    Locale? locale,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    TextDirection? textDirection,
    Widget Function(BuildContext, Widget?)? builder,
    DatePickerMode initialDatePickerMode = DatePickerMode.day,
    String? errorFormatText,
    String? errorInvalidText,
    String? fieldHintText,
    String? fieldLabelText,
    TextInputType? keyboardType,
    Offset? anchorPoint,
    void Function(DatePickerEntryMode)? onDatePickerModeChange,
  }) {
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2050),
      currentDate: currentDate,
      initialEntryMode: initialEntryMode,
      selectableDayPredicate: selectableDayPredicate,
      helpText: helpText,
      cancelText: cancelText,
      confirmText: confirmText,
      locale: locale,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0XFF007C16),
              onPrimary: Color(0XFFFFFFFF),
              onSurface: Color(0XFF007C16),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0XFF007C16),
                foregroundColor: const Color(0XFFFFFFFF),
                textStyle: TextStyle(
                  fontSize: 16.fSize,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
      initialDatePickerMode: initialDatePickerMode,
      errorFormatText: errorFormatText,
      errorInvalidText: errorInvalidText,
      fieldHintText: fieldHintText,
      fieldLabelText: fieldLabelText,
      keyboardType: keyboardType,
      anchorPoint: anchorPoint,
      onDatePickerModeChange: onDatePickerModeChange,
    ).then((value) {
      return value;
    });
  }

  static Future<TimeOfDay?> time(
    BuildContext context, {
    TimeOfDay? initialTime,
    Widget Function(BuildContext, Widget?)? builder,
    bool useRootNavigator = true,
    TimePickerEntryMode initialEntryMode = TimePickerEntryMode.dial,
    String? cancelText,
    String? confirmText,
    String? helpText,
    String? errorInvalidText,
    String? hourLabelText,
    String? minuteLabelText,
    RouteSettings? routeSettings,
    void Function(TimePickerEntryMode)? onEntryModeChanged,
    Offset? anchorPoint,
    Orientation? orientation,
  }) {
    return showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      initialEntryMode: initialEntryMode,
      helpText: helpText,
      cancelText: cancelText,
      confirmText: confirmText,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      errorInvalidText: errorInvalidText,
      anchorPoint: anchorPoint,
      minuteLabelText: minuteLabelText,
      hourLabelText: hourLabelText,
      orientation: orientation,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0XFF007C16),
              onPrimary: Color(0XFFFFFFFF),
              onSurface: Color(0XFF007C16),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0XFF007C16),
                foregroundColor: const Color(0XFFFFFFFF),
                textStyle: TextStyle(
                  fontSize: 16.fSize,
                ),
              ),
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          ),
        );
      },
    ).then((value) {
      return value;
    });
  }
}
