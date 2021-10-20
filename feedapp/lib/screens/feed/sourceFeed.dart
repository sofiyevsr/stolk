import 'package:stolk/components/common/sourceLogo.dart';
import 'package:stolk/logic/blocs/newsBloc/news.dart';
import 'package:stolk/utils/services/app/navigationService.dart';
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
    final media = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: media.size.width,
              elevation: 2,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  widget.sourceName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                background: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.black26,
                    BlendMode.darken,
                  ),
                  child: SourceLogo(
                    logoSuffix: widget.logoSuffix,
                    isCircle: false,
                  ),
                ),
              ),
            ),
            BlocProvider(
              create: (ctx) => NewsBloc(),
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
