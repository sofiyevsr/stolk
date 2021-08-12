import 'package:stolk/utils/@types/response/allNews.dart';

class NewsModel {
  final List<SingleNews> news;
  final bool hasReachedEnd;
  const NewsModel({required this.news, required this.hasReachedEnd});
  NewsModel addNewNews(
          {required bool hasReachedEnd,
          required List<SingleNews> incomingNews}) =>
      NewsModel(
        news: [...this.news, ...incomingNews],
        hasReachedEnd: hasReachedEnd,
      );
  NewsModel modifySingle({required SingleNews item, required int index}) {
    final clonedItems = [...this.news];
    clonedItems[index] = item;
    return NewsModel(news: clonedItems, hasReachedEnd: hasReachedEnd);
  }
}
