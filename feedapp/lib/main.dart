import 'package:feedapp/logic/blocs/newsBloc/utils/NewsBloc.dart';
import 'package:feedapp/screens/allNews.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<NewsBloc>(
        create: (ctx) => NewsBloc()
          ..add(
            FetchNewsEvent(),
          ),
        child: AllNewsScreen(),
      ),
    );
  }
}
