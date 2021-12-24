part of "./index.dart";

final _base = ThemeData.dark();

final darkTheme = _base.copyWith(
  backgroundColor: Colors.black,
  pageTransitionsTheme: PageTransitionsTheme(
    builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    },
  ),
  dividerTheme: DividerThemeData(
    space: 0,
    thickness: 1,
  ),
  textTheme: TextTheme(
    bodyText1: TextStyle(fontSize: 16),
    bodyText2: TextStyle(fontSize: 14),
  ),
  tabBarTheme: TabBarTheme(
    unselectedLabelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
    labelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
    indicator: BoxDecoration(
      border: Border(
        bottom: const BorderSide(
          color: Colors.orange,
          width: 5,
        ),
      ),
    ),
    labelPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: CustomColorScheme.main,
    foregroundColor: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.black54,
  inputDecorationTheme: InputDecorationTheme(
    errorMaxLines: 2,
    // labelStyle: TextStyle(fontSize: 18, color: Colors.white),
    errorStyle: TextStyle(color: Colors.red, fontSize: 15),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.blue,
      ),
    ),
    // prefixStyle: TextStyle(color: Colors.white),
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
  iconTheme: IconThemeData(color: Colors.white),
  primaryColorDark: CustomColorScheme.primaryDark,
  primaryColorLight: CustomColorScheme.primaryLight,
  indicatorColor: CustomColorScheme.primaryLight,
  appBarTheme: AppBarTheme(
    elevation: 5,
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 20,
    ),
    centerTitle: true,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.shifting,
  ),
);
