part of app_res;

class Styles {
  Styles._();

  static String _fontFamily = "Poppins";

  static void setFontFamily(String languageCode) {
    if (languageCode == "en") {
      _fontFamily = "Poppins";
    }
    if (languageCode == "ar") {
      _fontFamily = "Tajawal";
    }
    if (languageCode == "fa") {
      _fontFamily = "Vazir";
    }
  }

  static ThemeData get lightTheme => ThemeData(
        dialogTheme: DialogTheme(
          backgroundColor: AppColors.whiteColor,
        ),
        brightness: Brightness.light,
        canvasColor: AppColors.grey,
        scaffoldBackgroundColor: Colors.grey.shade50,
        primaryColorLight: Colors.grey.shade200,
        primaryColorDark: Colors.grey.shade900,
        primaryColor: Colors.white,
        primarySwatch: Colors.grey,
        fontFamily: _fontFamily,
        radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.all(AppColors.blackColor),
        ),
        switchTheme: SwitchThemeData(
          trackOutlineColor: WidgetStateProperty.all(AppColors.whiteColor),
          thumbColor: WidgetStateProperty.all(AppColors.whiteColor),
          trackColor: WidgetStateProperty.all(AppColors.primaryColor),
        ),
        dividerTheme: DividerThemeData(
          color: Colors.black12,
          thickness: 1,
        ),

        ///ICON THEME
        iconTheme: const IconThemeData(size: 24.0, color: Colors.black87),

        ///APP BAR THEME
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppColors.whiteColor, // White background
            statusBarIconBrightness: Brightness.dark, // Black icons
            statusBarBrightness: Brightness.light, // For iOS, light background
          ),

          iconTheme: const IconThemeData(size: 24.0, color: Colors.black87),
          titleSpacing: 10.0,
          centerTitle: false,
          backgroundColor: Colors.transparent,
          // foregroundColor: Colors.grey.shade700,
          elevation: 0.0,
          titleTextStyle: TextStyle(
            fontSize: 14.0.sp,
            color: Colors.grey.shade700,
          ),
        ),
        tabBarTheme: TabBarTheme(
          dividerColor: AppColors.transparent,
          // indicatorColor: Colors.red,
          indicatorSize: TabBarIndicatorSize.tab,
          labelPadding: EdgeInsets.zero,
          //unselectedLabelColor: Colors.white,
          unselectedLabelStyle: TextStyle(fontSize: 13.0.sp),
          labelColor: Colors.black,
          labelStyle: TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.bold),
          indicator: BoxDecoration(
            color: Colors.grey.withOpacity(0.0),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
            ),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedIconTheme: IconThemeData(
            color: Colors.black87,
            shadows: [
              Shadow(
                  color: Colors.black12, offset: Offset(1, 1), blurRadius: 1.1),
            ],
          ),
          unselectedIconTheme: IconThemeData(
            color: Colors.black54,
            shadows: [
              Shadow(
                  color: Colors.black12, offset: Offset(1, 1), blurRadius: 1.1),
            ],
          ),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedLabelStyle:
              TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
          unselectedLabelStyle: TextStyle(color: Colors.grey),
        ),

        textTheme: TextTheme(
          displayLarge:
              textLight.copyWith(color: AppColors.blackColor, fontSize: 13.sp),
          displayMedium: Styles.textBold
              .copyWith(color: AppColors.blackColor, fontSize: 13.sp),
          bodyMedium: Styles.textLight
              .copyWith(color: AppColors.blackColor, fontSize: 13.sp),
          bodySmall: Styles.textLight.copyWith(color: AppColors.blackColor),
          bodyLarge: Styles.textLight.copyWith(color: AppColors.blackColor),
          titleSmall: Styles.textLight
              .copyWith(color: AppColors.blackColor, fontSize: 13.sp),
          titleLarge: Styles.textBold
              .copyWith(color: AppColors.blackColor, fontSize: 13.sp),
        ),

        // textTheme: TextTheme(
        //   displayLarge: getBoldStyle(color: Colors.white)
        //       .copyWith(color: AppColors.blackColor, fontSize: 13.sp),
        //   displayMedium: getSemiBoldStyle(color: Colors.white)
        //       .copyWith(color: AppColors.blackColor, fontSize: 13.sp),
        //   bodyMedium:
        //       getLightStyle(color: AppColors.blackColor, fontSize: 13.sp),
        //   bodySmall: getBlackStyle(color: AppColors.blackColor),
        //   bodyLarge: getLightStyle(color: AppColors.blackColor),
        //   titleSmall:
        //       getLightStyle(color: AppColors.blackColor, fontSize: 13.sp),
        //   titleMedium:
        //       getMediumStyle(color: AppColors.blackColor, fontSize: 13.sp),
        //   titleLarge: getRegularStyle(color: Colors.white)
        //       .copyWith(color: AppColors.blackColor, fontSize: 13.sp),
        // ),
        colorScheme: ColorScheme.light(
            onPrimary: const Color(0xFF00A1ED),
            primary: AppColors.primaryColor,
            secondary: AppColors.textColor,
            surface: AppColors.accentColor),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            elevation: 15.0,
            padding: EdgeInsets.symmetric(vertical: 10.0.h),
            visualDensity: VisualDensity.standard,
            textStyle: Styles.textLight
                .copyWith(color: AppColors.whiteColor, fontSize: 15.sp),
            maximumSize: const Size(double.infinity, 100.0),
            minimumSize: const Size(double.infinity, 60.0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            visualDensity: VisualDensity.standard,
            foregroundColor: AppColors.primaryColor,
            textStyle: Styles.textLight
                .copyWith(color: AppColors.whiteColor, fontSize: 14),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.standard,
            foregroundColor: AppColors.primaryColor,
            textStyle: Styles.textLight
                .copyWith(color: AppColors.whiteColor, fontSize: 14),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.primaryColor, //<-- SEE HERE
        ),

        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.transparent,
          isDense: true,
          filled: true,
          contentPadding:
              EdgeInsets.symmetric(vertical: 20.0.h, horizontal: 15.0.w),
          labelStyle:
              Styles.textLight.copyWith(color: Colors.black, fontSize: 14),
          errorStyle: Styles.textLight
              .copyWith(color: AppColors.errorColor, fontSize: 14),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0),
            borderSide: const BorderSide(
              color: AppColors.primaryColor,
              width: 4.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0),
            borderSide: const BorderSide(
              color: AppColors.dividerColor,
              width: 1.0,
              // style: BorderStyle.none,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.errorColor,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(3.0),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 0.0,
              style: BorderStyle.none,
            ),
            borderRadius: BorderRadius.circular(3.0),
          ),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        dialogTheme: DialogTheme(
          backgroundColor: AppColors.darkColor,
        ),
        brightness: Brightness.dark,
        canvasColor: AppColors.darkColor,
        scaffoldBackgroundColor: AppColors.blackColor,
        primaryColorLight: Colors.grey.shade500,
        primaryColorDark: Colors.grey.shade100,
        primaryColor: Colors.black87,
        primarySwatch: Colors.grey,
        fontFamily: _fontFamily,
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.all(AppColors.whiteColor),
          trackColor: WidgetStateProperty.all(AppColors.primaryColor),
        ),
        dividerTheme: DividerThemeData(
          color: Colors.white10,
          thickness: 1,
        ),

        ///ICON THEME
        iconTheme: const IconThemeData(size: 24.0, color: Colors.white70),

        ///APP BAR THEME
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppColors.blackColor, // Black background
            statusBarIconBrightness: Brightness.light, // White icons
            statusBarBrightness: Brightness.dark, // For iOS, dark background
          ),
          iconTheme: IconThemeData(size: 24.0, color: Colors.white70),
          titleSpacing: 10.0,
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(fontSize: 13.0.sp),
        ),
        tabBarTheme: TabBarTheme(
          dividerColor: AppColors.transparent,
          // indicatorColor: Colors.red,
          indicatorSize: TabBarIndicatorSize.tab,
          labelPadding: EdgeInsets.zero,
          // unselectedLabelColor: Colors.white,
          unselectedLabelStyle: TextStyle(fontSize: 13.0.sp),
          labelColor: Colors.white,
          labelStyle: TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.bold),
          indicator: BoxDecoration(
            color: Colors.grey.withOpacity(0.0),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
            ),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 0,
          backgroundColor: Colors.grey.shade900,
          selectedIconTheme: IconThemeData(
            color: Colors.white,
            shadows: [
              Shadow(
                  color: Colors.black87, offset: Offset(1, 1), blurRadius: 1.1),
            ],
          ),
          unselectedIconTheme: IconThemeData(
            color: Colors.grey,
            shadows: [
              Shadow(
                  color: Colors.black87, offset: Offset(1, 1), blurRadius: 1.1),
            ],
          ),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedLabelStyle:
              TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
          unselectedLabelStyle: TextStyle(color: Colors.grey),
        ),
        textTheme: TextTheme(
          displayLarge:
              textLight.copyWith(color: AppColors.whiteColor, fontSize: 13.sp),
          displayMedium: Styles.textBold
              .copyWith(color: AppColors.whiteColor, fontSize: 13.sp),
          bodyMedium: Styles.textLight
              .copyWith(color: AppColors.whiteColor, fontSize: 13.sp),
          bodySmall: Styles.textLight.copyWith(color: AppColors.whiteColor),
          bodyLarge: Styles.textLight.copyWith(color: AppColors.whiteColor),
          titleSmall: Styles.textLight
              .copyWith(color: AppColors.whiteColor, fontSize: 13.sp),
          titleLarge: Styles.textBold
              .copyWith(color: AppColors.whiteColor, fontSize: 13.sp),
        ),

        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.transparent,
          isDense: true,
          filled: true,
          contentPadding:
              EdgeInsets.symmetric(vertical: 20.0.h, horizontal: 15.0.w),
          labelStyle:
              Styles.textLight.copyWith(color: Colors.black, fontSize: 13),
          errorStyle: Styles.textLight
              .copyWith(color: AppColors.errorColor, fontSize: 13),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0),
            borderSide: const BorderSide(
              color: AppColors.primaryColor,
              width: 4.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0),
            borderSide: const BorderSide(
              color: AppColors.dividerColor,
              width: 1.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.errorColor,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(3.0),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 0.0,
              style: BorderStyle.none,
            ),
            borderRadius: BorderRadius.circular(3.0),
          ),
        ),
        colorScheme: ColorScheme.dark(
            onPrimary: AppColors.blackColor,
            primary: AppColors.greyDark,
            secondary: AppColors.textColor,
            surface: AppColors.accentColor),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 15.0,
            padding: EdgeInsets.symmetric(vertical: 10.0.h),
            visualDensity: VisualDensity.standard,
            foregroundColor: AppColors.greyDark,
            textStyle: Styles.textLight
                .copyWith(color: AppColors.blackColor, fontSize: 16.sp),
            maximumSize: const Size(double.infinity, 100.0),
            minimumSize: const Size(double.infinity, 60.0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            maximumSize: const Size(double.infinity, 100.0),
            minimumSize: const Size(150.0, 60.0),
            visualDensity: VisualDensity.standard,
            foregroundColor: AppColors.primaryColor,
            textStyle: Styles.textLight
                .copyWith(color: AppColors.whiteColor, fontSize: 14),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.standard,
            foregroundColor: AppColors.primaryColor,
            textStyle: Styles.textBold
                .copyWith(color: AppColors.whiteColor, fontSize: 13),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          ),
        ),
      );
  static TextStyle get alertDialogTitle => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18.sp,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get label1Bold => TextStyle(
      fontFamily: _fontFamily,
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
      color: AppColors.primaryColor);

  static TextStyle get label1SemiBold => TextStyle(
      fontFamily: _fontFamily,
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryColor);

  static TextStyle get label2 => TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16.sp,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w400);

  static TextStyle get label2SemiBold => TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryColor);

  static TextStyle get label2w500 => TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.primaryColor);

  static TextStyle get label2Bold => TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16.sp,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.bold);

  static TextStyle get label2Light => TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16.sp,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w200);

  static TextStyle get label3 => TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14.sp,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w400);

  static TextStyle get label3Bold => TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14.sp,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.bold);

  static TextStyle get label3SemiBold => TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14.sp,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w600);

  static TextStyle get label3w500 => TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14.sp,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w500);

  static TextStyle get label3Light => TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14.sp,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w200);

  static TextStyle get label4 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.primaryColor,
      );

  static TextStyle get label4Bold => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryColor,
      );

  static TextStyle get label4SemiBold => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryColor,
      );

  static TextStyle get label6 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 10.sp,
        color: AppColors.primaryColor,
      );

  static TextStyle get errorStyle => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        color: Colors.red,
      );

  static TextStyle get textLight => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get textBold => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 13.sp,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bigText => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 25.sp.sp,
        fontWeight: FontWeight.bold,
      );
}



  ////////////////////////////////// TEXT STYLES ////////////////////////////////////////////////////////
//   static TextStyle _getTextStyle(double fontSize, FontWeight fontWeight,
//       {Color? color, double? letterSpacing, double? height}) {
//     return TextStyle(
//         // overflow: TextOverflow.ellipsis,
//         fontSize: fontSize,
//         letterSpacing: letterSpacing,
//         height: height,
//         // fontFamily: fontFamily,
//         color: color,
//         fontWeight: fontWeight);
//   }

// // regular style

//   static TextStyle getRegularStyle(
//       {double fontSize = 14, Color color = Colors.black}) {
//     return _getTextStyle(fontSize, FontWeight.w400, color: color);
//   }
// // light text style

//   static TextStyle getLightStyle(
//       {double fontSize = 12, Color color = Colors.black}) {
//     return _getTextStyle(fontSize, FontWeight.w300, color: color);
//   }
// // bold text style

//   static TextStyle getBoldStyle(
//       {double fontSize = 18,
//       Color color = Colors.black,
//       double? letterSpacing = 1.5,
//       double? height = 1.5}) {
//     return _getTextStyle(fontSize, FontWeight.bold,
//         color: color, letterSpacing: letterSpacing, height: height);
//   }

//   static TextStyle getBlackStyle(
//       {double fontSize = 36, Color color = Colors.black}) {
//     return _getTextStyle(fontSize, FontWeight.bold, color: color);
//   }

// // semi bold text style

//   static TextStyle getSemiBoldStyle(
//       {double fontSize = 16, Color color = Colors.black}) {
//     return _getTextStyle(fontSize, FontWeight.w600, color: color);
//   }

// // medium text style

//   static TextStyle getMediumStyle(
//       {double fontSize = 16, Color color = Colors.black}) {
//     return _getTextStyle(fontSize, FontWeight.w500, color: color);
//   }

