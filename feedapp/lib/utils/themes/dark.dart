part of "./index.dart";

final _base = ThemeData.dark();

final darkTheme = _base.copyWith(
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    },
  ),
  dividerTheme: const DividerThemeData(
    space: 0,
    thickness: 1,
  ),
  textTheme: const TextTheme(
    bodyText1: TextStyle(fontSize: 16),
    bodyText2: TextStyle(fontSize: 14),
  ),
  tabBarTheme: const TabBarTheme(
    unselectedLabelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
    labelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
    indicator: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: CustomColorScheme.main,
          width: 5,
        ),
      ),
    ),
    labelPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.grey.shade700,
    foregroundColor: Colors.white,
  ),
  inputDecorationTheme: const InputDecorationTheme(
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
  iconTheme: const IconThemeData(color: Colors.white),
  indicatorColor: Colors.grey.shade200,
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateColor.resolveWith((state) {
      if (state.contains(MaterialState.disabled)) {
        return Colors.grey.shade200;
      }
      return CustomColorScheme.main;
    }),
    trackColor: MaterialStateColor.resolveWith((state) {
      if (state.contains(MaterialState.selected))
        return CustomColorScheme.primaryLight;
      return Colors.grey.shade300;
    }),
  ),
  radioTheme: RadioThemeData(
    fillColor: MaterialStateColor.resolveWith((state) {
      return CustomColorScheme.main;
    }),
  ),
  appBarTheme: const AppBarTheme(
    elevation: 5,
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 20,
    ),
    centerTitle: true,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.shifting,
    selectedIconTheme: IconThemeData(
      size: 30,
    ),
    unselectedIconTheme: IconThemeData(
      size: 24,
    ),
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white,
  ),
);
