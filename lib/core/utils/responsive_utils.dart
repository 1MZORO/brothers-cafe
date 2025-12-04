import 'package:flutter/material.dart';

class ResponsiveUtils {
  static double width(BuildContext context) => MediaQuery.of(context).size.width;
  static double height(BuildContext context) => MediaQuery.of(context).size.height;
  
  // Responsive width based on design width (375)
  static double w(BuildContext context, double size) {
    return (size / 375) * width(context);
  }
  
  // Responsive height based on design height (812)  
  static double h(BuildContext context, double size) {
    return (size / 812) * height(context);
  }
  
  // Responsive font size
  static double sp(BuildContext context, double size) {
    return (size / 375) * width(context);
  }
  
  // Responsive radius
  static double r(BuildContext context, double size) {
    return (size / 375) * width(context);
  }
  
  // Quick access methods
  static EdgeInsets paddingAll(BuildContext context, double size) {
    return EdgeInsets.all(w(context, size));
  }
  
  static EdgeInsets paddingSymmetric(BuildContext context, {double horizontal = 0, double vertical = 0}) {
    return EdgeInsets.symmetric(
      horizontal: w(context, horizontal),
      vertical: h(context, vertical),
    );
  }
  
  static EdgeInsets paddingOnly(BuildContext context, {
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      left: w(context, left),
      top: h(context, top),
      right: w(context, right),
      bottom: h(context, bottom),
    );
  }
  
  static SizedBox sizedBoxH(BuildContext context, double height) {
    return SizedBox(height: h(context, height));
  }
  
  static SizedBox sizedBoxW(BuildContext context, double width) {
    return SizedBox(width: w(context, width));
  }
  
  static BorderRadius borderRadius(BuildContext context, double radius) {
    return BorderRadius.circular(r(context, radius));
  }
}

// Extension for easier usage
extension ResponsiveExtension on num {
  double w(BuildContext context) => ResponsiveUtils.w(context, toDouble());
  double h(BuildContext context) => ResponsiveUtils.h(context, toDouble());
  double sp(BuildContext context) => ResponsiveUtils.sp(context, toDouble());
  double r(BuildContext context) => ResponsiveUtils.r(context, toDouble());
}
