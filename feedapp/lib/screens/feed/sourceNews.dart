import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stolk/logic/blocs/newsBloc/news.dart';

import 'widgets/sourceNews.dart';

class SourceNewsScreen extends StatelessWidget {
  final int sourceID;
  final String sourceName;
  final String logoSuffix;
  const SourceNewsScreen({
    Key? key,
    required this.sourceID,
    required this.sourceName,
    required this.logoSuffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<NewsBloc>(
          create: (_) => NewsBloc(),
          child: SourceNews(
            sourceID: sourceID,
            sourceName: sourceName,
            logoSuffix: logoSuffix,
          ),
        ),
      ),
    );
  }
}
