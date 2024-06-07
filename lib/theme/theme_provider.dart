import 'package:flutter/material.dart';
import '/core/app_export.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider(BuildContext c);

  themeChange(String themeType) async {
    PrefUtils().setThemeData(themeType);
    notifyListeners();
  }
}
