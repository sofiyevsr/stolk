import 'package:cached_network_image/cached_network_image.dart';
import 'package:feedapp/logic/blocs/newsBloc/utils/NewsBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'newsView.dart';

class AllNewsScreen extends StatelessWidget {
  const AllNewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar()
      ,body: SafeArea(
        child: BlocBuilder<NewsBloc, NewsState>(
          builder: (ctx, state) {
            if (state is NewsStateSuccess) {
              return SingleChildScrollView(
                child: Column(
                  children: state.data.news
                      .map(
                        (e) => InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => NewsView(link: e.feedLink),
                              ),
                            );
                          },
                          child: Container(
                            height: 170,
                            margin: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 5,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: .4,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Text(
                                    e.title,
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: CachedNetworkImage(
                                      imageUrl: e.imageLink,
                                      errorWidget: (ctx, err, _) => Container(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              );
            }
            return Text("not success yet");
          },
        ),
      ),
    );
  }
}
