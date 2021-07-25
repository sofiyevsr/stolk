import 'dart:collection';

import 'package:feedapp/utils/constants.dart';
import 'package:flutter/material.dart';

class SourcesPage extends StatefulWidget {
  const SourcesPage({Key? key}) : super(key: key);

  @override
  _SourcesPageState createState() => _SourcesPageState();
}

class _SourcesPageState extends State<SourcesPage> {
  HashSet<int> _langs = HashSet.from([0, 1, 2]);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: LANGS.entries
                .map<Widget>(
                  (e) => FilterChip(
                    avatar: CircleAvatar(
                      radius: 15.0,
                      backgroundImage: AssetImage(
                        'assets/flags/${e.value}.png',
                      ),
                    ),
                    label: Text(e.value),
                    selected: _langs.contains(e.key),
                    onSelected: (s) {
                      if (s == false && _langs.remove(e.key)) {
                        final modifLangSet = HashSet<int>.from(_langs);
                        setState(() {
                          _langs = modifLangSet;
                        });
                      }
                      if (s == true && _langs.add(e.key)) {
                        final modifLangSet = HashSet<int>.from(_langs);
                        setState(() {
                          _langs = modifLangSet;
                        });
                      }
                    },
                  ),
                )
                .toList(),
          ),
        ),
        Expanded(
          child: GridView.builder(
            physics: BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: 50,
            itemBuilder: (ctx, i) {
              return Card(
                child: Column(
                  children: [
                    Expanded(
                      child: SizedBox.expand(
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          child: CircleAvatar(
                            child: Text("test"),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.follow_the_signs),
                      label: Text("test"),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
