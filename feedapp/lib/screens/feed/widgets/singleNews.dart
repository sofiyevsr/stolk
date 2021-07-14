import 'package:cached_network_image/cached_network_image.dart';
import 'package:feedapp/screens/feed/widgets/newsView.dart';
import 'package:feedapp/utils/@types/response/allNews.dart';
import 'package:flutter/material.dart';

class SingleNewsView extends StatelessWidget {
  final SingleNews feed;
  const SingleNewsView({Key? key, required this.feed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => NewsView(link: feed.feedLink),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 5,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: theme.cardColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        child: feed.imageLink == null
                            ? Container(
                                color: theme.primaryColor,
                              )
                            : CachedNetworkImage(
                                imageUrl: feed.imageLink!,
                                fit: BoxFit.cover,
                                errorWidget: (ctx, err, _) => Container(),
                              ),
                      ),
                    ),
                    Container(
                      color: Colors.black,
                      child: Text(
                        feed.sourceName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Text(
                          feed.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
