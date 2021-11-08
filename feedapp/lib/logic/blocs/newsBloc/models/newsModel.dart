import 'package:stolk/utils/@types/response/allNews.dart';

class NewsModel {
  final List<SingleNews> news;
  final bool hasReachedEnd;
  final int? category;
  final int? sortBy;
  final int? period;
  const NewsModel({
    required this.news,
    required this.hasReachedEnd,
    required this.category,
    required this.sortBy,
    required this.period,
  });
  NewsModel addNewNews({
    required bool hasReachedEnd,
    required List<SingleNews> incomingNews,
  }) =>
      NewsModel(
        news: [...this.news, ...incomingNews],
        hasReachedEnd: hasReachedEnd,
        sortBy: this.sortBy,
        category: this.category,
        period: this.period,
      );
  NewsModel modifySingle({
    required SingleNews item,
    required int index,
  }) {
    final clonedItems = [...this.news];
    clonedItems[index] = item;
    return NewsModel(
      news: clonedItems,
      hasReachedEnd: hasReachedEnd,
      sortBy: this.sortBy,
      category: this.category,
      period: this.period,
    );
  }
}
