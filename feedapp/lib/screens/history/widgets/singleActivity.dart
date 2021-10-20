import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stolk/screens/feed/widgets/newsView.dart';
import 'package:stolk/utils/@types/response/newsHistory.dart';
import 'package:stolk/utils/common.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/services/app/navigationService.dart';

class SingleHistoryActivity extends StatelessWidget {
  final NewsHistory news;
  const SingleHistoryActivity({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(
        8,
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(
              10,
            ),
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                    text: news.title,
                    style: TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        NavigationService.push(
                          NewsView(link: news.feedLink),
                          RouteNames.SINGLE_NEWS,
                        );
                      },
                  ),
                  if (news.comment != null)
                    TextSpan(
                      text: ": " + news.comment!,
                    ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(right: 10),
            child: Text(
              convertDiffTime(
                news.createdAt,
                context,
              ),
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }
}
