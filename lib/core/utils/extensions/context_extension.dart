import 'package:flutter/material.dart';

extension Context on BuildContext {
  get height => MediaQuery.sizeOf(this).height;
  get width => MediaQuery.sizeOf(this).width;
  get isTablet => width > 600;
  static const double _designHeight = 932;
  static const double _designWidth = 430;

  double responsiveWidth(double widgetWidth) {
    return width * (widgetWidth / _designWidth);
  }

  double responsiveHeight(double widgetHeight) {
    return height * (widgetHeight / _designHeight);
  }
}
