import 'package:feedapp/components/common/centerLoadingWidget.dart';
import 'package:feedapp/logic/blocs/newsBloc/news.dart';
import 'package:feedapp/screens/feed/widgets/singleNews.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleNewsHistoryUnit extends StatefulWidget {
  const SingleNewsHistoryUnit({Key? key}) : super(key: key);

  @override
  _SingleNewsHistoryUnitState createState() => _SingleNewsHistoryUnitState();
}

class _SingleNewsHistoryUnitState extends State<SingleNewsHistoryUnit> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: BlocBuilder<NewsBloc, NewsState>(
        builder: (ctx, state) {
          if (state is NewsStateLoading) return CenterLoadingWidget();
          if (state is NewsStateSuccess) {
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              controller: _scrollController,
              itemCount: state.data.hasReachedEnd
                  ? state.data.news.length
                  : state.data.news.length + 1,
              itemBuilder: (ctx, index) => index >= state.data.news.length
                  ? Container(
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 8,
                        ),
                      ),
                    )
                  : SingleNewsView(
                      key: Key(
                        state.data.news[index].id.toString(),
                      ),
                      feed: state.data.news[index],
                    ),
            );
          }

          if (state is NewsStateNoData) {}
          if (state is NewsStateError) {}
          return Container();
        },
      ),
    );
  }
}
