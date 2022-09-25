import 'package:flutter/widgets.dart';

class Dimensions {
  double width = 0;
  double height = 0;

  // constructor
  Dimensions(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
  }

  getVW(double percentage, double? min, double? max) {
    double calculated = width * (percentage / 100);
    if (min != null && calculated < min) {
      return min;
    }
    if (max != null && calculated > max) {
      return max;
    }
    return calculated;
  }

  getVH(double percentage, double? min, double? max) {
    double calculated = height * (percentage / 100);
    if (min != null && calculated < min) {
      return min;
    }
    if (max != null && calculated > max) {
      return max;
    }
    return calculated;
  }
}
