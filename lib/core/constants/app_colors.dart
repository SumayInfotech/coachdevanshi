import 'package:flutter/material.dart';

class AppColors extends ChangeNotifier {
  AppColors._();

  static final AppColors instance = AppColors._();

  void init() {
    setThemeColors();
    notifyListeners();
  }

  /// --------------------------------------------------
  /// Colors
  /// --------------------------------------------------

  late Color white;
  late Color black;
  late Color transparent;
  late Color grey;
  late Color red;

  late Color primary;
  late Color neutral;

  late Color bgColor;
  late Color textFieldBgColor;
  late Color unSelected;

  void setThemeColors() {
    white = Colors.white;
    black = Colors.black;
    transparent = Colors.transparent;
    grey = Colors.grey;
    red = Colors.red;

    primary = const Color(0xFF8B484D);
    neutral = const Color(0xFF32302F);

    bgColor = const Color(0xFFFEF8F6);
    textFieldBgColor = const Color(0xFFF8F2F0);
    unSelected = const Color(0xFF534343);
  }
}
