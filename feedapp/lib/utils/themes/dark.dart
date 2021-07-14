part of "./index.dart";

final darkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.black38,
  dividerTheme: DividerThemeData(
    space: 0,
    thickness: 1,
  ),
  textTheme: TextTheme(
    bodyText1: TextStyle(fontSize: 18),
    bodyText2: TextStyle(fontSize: 16),
  ),
  tabBarTheme: TabBarTheme(
    unselectedLabelStyle: TextStyle(fontSize: 16),
    labelStyle: TextStyle(fontSize: 18),
    indicator: BoxDecoration(
      border: Border(
        bottom: const BorderSide(
          color: Colors.orange,
          width: 5,
        ),
      ),
    ),
  ),
  scaffoldBackgroundColor: Colors.black54,
  inputDecorationTheme: InputDecorationTheme(
    errorMaxLines: 2,
    labelStyle: TextStyle(fontSize: 20, color: Colors.white),
    errorStyle: TextStyle(color: Colors.red, fontSize: 15),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
      ),
    ),
    prefixStyle: TextStyle(color: Colors.white),
  ),
  iconTheme: IconThemeData(color: Colors.white),
  primaryColorDark: Colors.blue,
  appBarTheme: AppBarTheme(
    elevation: 5,
    textTheme: const TextTheme(
      headline5: TextStyle(fontWeight: FontWeight.w700),
    ),
    centerTitle: true,
  ),
  accentColor: Color(0xffa6a6a6),
);
