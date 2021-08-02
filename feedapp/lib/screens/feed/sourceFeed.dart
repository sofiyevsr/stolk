import 'package:feedapp/components/common/sourceLogo.dart';
import 'package:feedapp/logic/blocs/newsBloc/news.dart';
import 'package:feedapp/utils/services/app/navigationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/sourceNewsSliver.dart';

class SourceFeed extends StatefulWidget {
  final int sourceID;
  final String sourceName;
  final String logoSuffix;
  const SourceFeed(
      {Key? key,
      required this.sourceID,
      required this.sourceName,
      required this.logoSuffix})
      : super(key: key);

  @override
  _SourceFeedState createState() => _SourceFeedState();
}

class _SourceFeedState extends State<SourceFeed> {
  late ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 200,
              elevation: 3,
              leading: ElevatedButton(
                onPressed: () {
                  NavigationService.pop();
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  elevation: MaterialStateProperty.all(0),
                ),
                child: Icon(Icons.arrow_back),
              ),
              title: Text(widget.sourceName),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: SourceLogo(
                  logoSuffix: widget.logoSuffix,
                  isCircle: false,
                ),
              ),
            ),
            BlocProvider(
              create: (ctx) => NewsBloc()
                ..add(
                  FetchNewsEvent(
                    category: null,
                    sourceID: widget.sourceID,
                    filterBy: null,
                  ),
                ),
              child: SourceNewsSliver(
                scrollController: _scrollController,
                sourceID: widget.sourceID,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
