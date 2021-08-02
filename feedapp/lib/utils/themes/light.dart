part of "./index.dart";

final lightTheme = ThemeData(
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
  textTheme: TextTheme(
    headline1: TextStyle(fontWeight: FontWeight.bold),
  ),
  brightness: Brightness.light,
  primaryColor: CustomColorScheme.main,
  tabBarTheme: TabBarTheme(
    unselectedLabelStyle: TextStyle(fontSize: 16),
    labelStyle: TextStyle(fontSize: 17),
    indicator: BoxDecoration(
      color: CustomColorScheme.main,
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
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      // foregroundColor: MaterialStateProperty.resolveWith((states) {
      //   if (states.contains(MaterialState.disabled)) {
      //     return Colors.white70;
      //   }
      //   return Colors.white;
      // }),
      backgroundColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return CustomColorScheme.main.withAlpha(205);
        }
        return CustomColorScheme.main;
      }),
    ),
  ),
  scaffoldBackgroundColor: Colors.grey[300],
  accentColor: CustomColorScheme.accent,
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
    textTheme: const TextTheme(
      headline5: TextStyle(fontWeight: FontWeight.w700),
    ),
    centerTitle: true,
  ),
);
