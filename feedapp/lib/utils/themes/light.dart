part of "./index.dart";

final lightTheme = ThemeData(
  textTheme: const TextTheme(
    bodyText1: TextStyle(fontSize: 16),
    bodyText2: TextStyle(fontSize: 14),
  ),
  iconTheme: const IconThemeData(
    color: CustomColorScheme.main,
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    },
  ),
  chipTheme: ChipThemeData.fromDefaults(
    brightness: Brightness.light,
    labelStyle: const TextStyle(),
    secondaryColor: Colors.grey.shade700,
  ),
  dividerTheme: const DividerThemeData(
    space: 0,
    thickness: 1,
  ),
  fontFamily: 'Roboto',
  brightness: Brightness.light,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: CustomColorScheme.main,
    foregroundColor: Colors.white,
  ),
  tabBarTheme: const TabBarTheme(
    unselectedLabelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
    labelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
    labelColor: Colors.black,
    unselectedLabelColor: Colors.black54,
    indicator: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.orange,
          width: 5,
        ),
      ),
    ),
    labelPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
    // unselectedLabelColor: Colors.white,
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      minimumSize: MaterialStateProperty.all(
        const Size(0, 50),
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: MaterialStateProperty.all(0),
      shape: MaterialStateProperty.all(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ),
      minimumSize: MaterialStateProperty.all(
        const Size(140, 50),
      ),
      textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return CustomColorScheme.main.withAlpha(205);
        }
        return CustomColorScheme.main;
      }),
    ),
  ),
  scaffoldBackgroundColor: Colors.grey[200],
  colorScheme: ThemeData().colorScheme.copyWith(
        primary: CustomColorScheme.main,
        secondary: CustomColorScheme.accent,
      ),
  inputDecorationTheme: const InputDecorationTheme(
    errorMaxLines: 2,
    errorStyle: TextStyle(color: Colors.red, fontSize: 15),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(),
    ),
  ),
  primaryColor: CustomColorScheme.main,
  primaryColorLight: CustomColorScheme.primaryLight,
  primaryColorDark: CustomColorScheme.primaryDark,
  appBarTheme: const AppBarTheme(
    elevation: 2,
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 20,
    ),
    centerTitle: true,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.shifting,
    backgroundColor: CustomColorScheme.main,
    selectedIconTheme: IconThemeData(
      size: 34,
    ),
    unselectedIconTheme: IconThemeData(
      size: 26,
    ),
  ),
);
