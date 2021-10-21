import 'package:stolk/components/common/centerLoadingWidget.dart';
import 'package:stolk/components/common/noConnection.dart';
import 'package:stolk/logic/blocs/sourcesBloc/sources.dart';
import 'package:stolk/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/singleSourceView.dart';

class SourcesPage extends StatefulWidget {
  const SourcesPage({Key? key}) : super(key: key);

  @override
  _SourcesPageState createState() => _SourcesPageState();
}

class _SourcesPageState extends State<SourcesPage> {
  int _currentLangID = 0;

  @override
  void initState() {
    super.initState();
    fetchSources();
  }

  void fetchSources() {
    context.read<SourcesBloc>()
      ..add(
        FetchSourcesEvent(),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DefaultTabController(
          length: LANGS.length,
          child: TabBar(
            isScrollable: true,
            unselectedLabelColor: Colors.black54,
            labelColor: Colors.black,
            onTap: (i) {
              setState(() {
                _currentLangID = i;
              });
            },
            tabs: LANGS.entries
                .map<Widget>(
                  (e) => Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CircleAvatar(
                      backgroundImage: AssetImage(
                        'assets/flags/${e.value}.png',
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        Expanded(
          child:
              BlocBuilder<SourcesBloc, SourcesState>(builder: (context, state) {
            if (state is SourcesStateSuccess) {
              final sources = state.data.sources
                  .where(
                    (element) => element.langID == _currentLangID,
                  )
                  .toList();
              return GridView.builder(
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: sources.length,
                itemBuilder: (ctx, i) => SingleSourceView(
                  item: sources[i],
                ),
              );
            }
            if (state is SourcesStateLoading) {
              return CenterLoadingWidget();
            }
            if (state is SourcesStateError)
              return NoConnectionWidget(
                onRetry: fetchSources,
              );
            return Container();
          }),
        ),
      ],
    );
  }
}
