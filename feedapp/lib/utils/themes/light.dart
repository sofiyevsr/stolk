part of "./index.dart";

final lightTheme = ThemeData(
  textTheme: TextTheme(
    bodyText1: TextStyle(fontSize: 16),
    bodyText2: TextStyle(fontSize: 14),
  ),
  pageTransitionsTheme: PageTransitionsTheme(
    builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    },
  ),
  chipTheme: ChipThemeData.fromDefaults(
    brightness: Brightness.light,
    labelStyle: TextStyle(),
    secondaryColor: Colors.grey.shade700,
  ),
  dividerTheme: DividerThemeData(
    space: 0,
    thickness: 1,
  ),
  fontFamily: 'Roboto',
  brightness: Brightness.light,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: CustomColorScheme.main,
    foregroundColor: Colors.white,
  ),
  tabBarTheme: TabBarTheme(
    unselectedLabelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
    labelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
    labelColor: Colors.black,
    unselectedLabelColor: Colors.black54,
    indicator: BoxDecoration(
      border: Border(
        bottom: const BorderSide(
          color: Colors.orange,
          width: 5,
        ),
      ),
    ),
    labelPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
    // unselectedLabelColor: Colors.white,
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      minimumSize: MaterialStateProperty.all(
        Size(0, 50),
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      minimumSize: MaterialStateProperty.all(
        Size(0, 50),
      ),
      textStyle: MaterialStateProperty.all<TextStyle>(
        TextStyle(color: Colors.white),
      ),
      backgroundColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return CustomColorScheme.main.withAlpha(205);
        }
        return CustomColorScheme.main;
      }),
    ),
  ),
  scaffoldBackgroundColor: Colors.grey[300],
  colorScheme: ThemeData().colorScheme.copyWith(
        primary: CustomColorScheme.main,
        secondary: CustomColorScheme.accent,
      ),
  inputDecorationTheme: InputDecorationTheme(
    errorMaxLines: 2,
    // labelStyle: TextStyle(fontSize: 18, color: Color(0xfffefae0)),
    // hoverColor: Colors.yellow,
    // focusColor: Colors.yellow,
    errorStyle: TextStyle(color: Colors.red, fontSize: 15),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
          // color: CustomColorScheme.main,
          ),
    ),
    // prefixStyle: TextStyle(color: Colors.white),
  ),
  primaryColorLight: CustomColorScheme.primaryLight,
  primaryColorDark: CustomColorScheme.primaryDark,
  appBarTheme: AppBarTheme(
    elevation: 3,
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 20,
    ),
    centerTitle: true,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.shifting,
    backgroundColor: CustomColorScheme.main,
  ),
);
