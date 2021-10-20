import 'package:stolk/utils/@types/response/newsHistory.dart';

class NewsHistoryModel {
  final List<NewsHistory> news;
  final bool hasReachedEnd;
  const NewsHistoryModel({
    required this.news,
    required this.hasReachedEnd,
  });
  NewsHistoryModel addNewNews({
    required bool hasReachedEnd,
    required List<NewsHistory> incomingNews,
  }) =>
      NewsHistoryModel(
        news: [...this.news, ...incomingNews],
        hasReachedEnd: hasReachedEnd,
      );
}
