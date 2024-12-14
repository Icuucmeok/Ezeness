part of app_res;

class AppColors {
  AppColors._();
  static void setColor(bool isDarkMode) {
    textColor = isDarkMode ? whiteColor : blackColor;
  }

  // colors
  static const Color primaryColor = Color(0xFF14B5FF);
  static Color textColor = const Color(0xFFF6F8FA);
  static const Color greyColor = Color(0xFF717171);
  static Color grey900 = Colors.grey[900] ?? darkGrey;
  static const Color whiteColor = Colors.white;
  static const accentColor = Color(0xFFEDEEEF);
  static const dividerColor = Color(0xFFAEB0B3);
  static const errorColor = Color(0xffcf0000);
  static const Color blackColor = Colors.black;
  static const Color grey = Color(0xFFE9E9E9);
  static const Color pink = Colors.pinkAccent;
  static const Color greyDark = Color(0xFF9F9F9F);
  static const Color greyCard = Color(0xFFF4F3F3);
  static const Color greyLight = Color(0xffA9A9A9);
  static const Color greyBright = Color(0xffE9E9E9);
  static const Color greyLavender = Color(0xffC5C4D8);
  static const Color outlineButton = Color(0xff707070);
  static const Color whiteTransparent = Color.fromRGBO(255, 255, 255, 0.7);
  static const Color transparent = Colors.transparent;
  static const Color textFieldBorderLight = Color(0xFF828282);
  static const Color textFieldBorderDark = Color(0xFFA4A4A4);

  static const Color iconLight = Color(0xff5A5A5A);
  static const Color iconDark = Color(0xffEDEBF7);

  static const Color textLight = Color(0xFFEDEBF7);
  static const Color darkBlue = Color(0xFF092A4E);
  static const Color textDark = Color(0xFF181818);
  static const Color gold = Color(0xFFC69A41);
  static const Color orange = Color(0xFFE0CA9E);
  static const Color yellow = Color(0xFFFFF500);
  static const Color backgroundGrey = Color(0xFFF3F3F3);

  static const Color darkColor = Color(0xFF383434);

  static Color darkPrimary = Color(0XFFFF7000);
  static Color blackText = Color(0xFF292929);
  static Color secondary = Color(0xFF2680EB);
  static Color darkGrey = Color(0XFF7E7C7C);
  static Color lightBlue = Color(0XFF00B0F0);
  static Color shadowColor = Color(0xFFC6C6C6);
  static Color greyTextColor = Color(0xFF4B4B4B);
  static Color error = Color(0xFFEF0000);
  static Color green = Color(0xFF50831B);
  static Color darkGreen = Color(0xFF4D9105);
  static Color darkWhite = Color(0xFFFAFAFA);
  static Color redColor = Color(0xFF960000);
  static Color blueText = Color(0xFF064080);

  static Color accentShadowColor = Color.fromARGB(31, 73, 70, 70);

  // helper

  static int getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}
