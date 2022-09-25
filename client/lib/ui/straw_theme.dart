import 'package:flutter/material.dart';
import 'package:strawberry/ui/tools/dimensions.dart';

class StrawTheme {
  // Add primary color accessible to StrawTheme.primary
  static const Color c0 = Color.fromARGB(255, 193, 193, 193);
  static const Color c1 = Color.fromARGB(255, 211, 12, 72);
  static const Color c3 = Color.fromARGB(255, 255, 71, 71);
  static const Color c2 = Color.fromARGB(255, 82, 156, 240);
  static const Color c4 = Color.fromARGB(255, 62, 62, 62);
  static const Color c5 = Color.fromARGB(255, 37, 37, 37);

  static const Color cText1 = Color.fromARGB(255, 255, 255, 255);

  // Success color
  static const Color cSuccess = Color.fromARGB(255, 0, 255, 0);
  // Error color
  static const Color cError = Color.fromARGB(255, 255, 0, 0);

  static Color getShade(Color color, {bool darker = false, double value = .1}) {
    assert(value >= 0 && value <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness(
        (darker ? (hsl.lightness - value) : (hsl.lightness + value))
            .clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static MaterialColor getMaterialColorFromColor(Color color) {
    Map<int, Color> colorShades = {
      50: getShade(color, value: 0.5),
      100: getShade(color, value: 0.4),
      200: getShade(color, value: 0.3),
      300: getShade(color, value: 0.2),
      400: getShade(color, value: 0.1),
      500: color,
      600: getShade(color, value: 0.1, darker: true),
      700: getShade(color, value: 0.15, darker: true),
      800: getShade(color, value: 0.2, darker: true),
      900: getShade(color, value: 0.25, darker: true),
    };
    return MaterialColor(color.value, colorShades);
  }

  static TextStyle h4(context) {
    Dimensions dimensions = Dimensions(context);
    return TextStyle(
        color: StrawTheme.cText1,
        overflow: TextOverflow.ellipsis,
        fontSize: dimensions.getVW(04, 10, 30));
  }
}
