import 'package:feedapp/utils/@types/response/allNews.dart';

class News {
  final List<SingleNews> news;
  final bool hasReachedEnd;
  const News({required this.news, required this.hasReachedEnd});
  News addNewNews(
          {required bool hasReachedEnd,
          required List<SingleNews> incomingNews}) =>
      News(
        news: [...this.news, ...incomingNews],
        hasReachedEnd: hasReachedEnd,
      );
}
