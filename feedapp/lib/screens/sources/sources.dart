import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:feedapp/logic/blocs/sourcesBloc/sources.dart';
import 'package:feedapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/singleSourceView.dart';

class SourcesPage extends StatefulWidget {
  const SourcesPage({Key? key}) : super(key: key);

  @override
  _SourcesPageState createState() => _SourcesPageState();
}

class _SourcesPageState extends State<SourcesPage> {
  HashSet<int> _langs = HashSet.from(LANGS.keys);

  void onSelected(bool s, int key) {
    if (s == false && _langs.remove(key)) {
      final modifLangSet = HashSet<int>.from(_langs);
      setState(() {
        _langs = modifLangSet;
      });
    }
    if (s == true && _langs.add(key)) {
      final modifLangSet = HashSet<int>.from(_langs);
      setState(() {
        _langs = modifLangSet;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: LANGS.entries
                  .map<Widget>(
                    (e) => Container(
                      margin: const EdgeInsets.all(8),
                      child: FilterChip(
                        avatar: CircleAvatar(
                          backgroundImage: AssetImage(
                            'assets/flags/${e.value}.png',
                          ),
                        ),
                        label: Text(
                          "languages.${e.value}".tr(),
                          style: TextStyle(fontSize: 18),
                        ),
                        selected: _langs.contains(e.key),
                        onSelected: (s) => onSelected(s, e.key),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: BlocBuilder<SourcesBloc, SourcesState>(
                builder: (context, state) {
              if (state is SourcesStateSuccess) {
                final sources = state.data.sources
                    .where(
                      (element) => _langs.contains(element.langID),
                    )
                    .toList();
                return GridView.builder(
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: sources.length,
                  itemBuilder: (ctx, i) => SingleSourceView(
                    key: Key(
                      sources[i].id.toString(),
                    ),
                    item: sources[i],
                  ),
                );
              }
              return Container();
            }),
          ),
        ],
      ),
    );
  }
}
