import 'package:feedapp/logic/blocs/newsBloc/models/newsModel.dart';
import 'package:feedapp/utils/@types/response/allNews.dart';
import 'package:feedapp/utils/services/server/newsService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:equatable/equatable.dart";

part "NewsEvents.dart";
part "NewsState.dart";

final service = NewsService();

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsStateInitial());

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    if (event is FetchNewsEvent) {
      try {
        yield NewsStateLoading();
        final data = await service.getAllNews();
        if (data.news.length != 0)
          yield NewsStateSuccess(
            data: News(
              news: data.news,
              hasReachedEnd: data.hasReachedEnd,
            ),
            isLoadingNext: false,
          );
        else
          yield NewsStateNoData();
      } catch (e) {
        yield NewsStateError();
      }
    } else if (event is RefreshNewsEvent) {
      try {
        final data = event.data;
        if (data.news.length != 0)
          yield NewsStateSuccess(
            data: News(
              news: data.news,
              hasReachedEnd: data.hasReachedEnd,
            ),
            isLoadingNext: false,
          );
        else
          yield NewsStateNoData();
      } catch (e) {
        yield NewsStateError();
      }
    } else if (event is FetchNextNewsEvent) {
      if (state is NewsStateSuccess &&
          (state as NewsStateSuccess).isLoadingNext == false &&
          (state as NewsStateSuccess).data.hasReachedEnd == false) {
        try {
          yield (state as NewsStateSuccess).copyWith(true);
          final existing = (state as NewsStateSuccess).data;
          final lastPub = existing.news[existing.news.length - 1].publishedDate;

          // set Loading and fetch data then
          final data = await service.getAllNews(lastPub);
          yield NewsStateSuccess(
              data: existing.addNewNews(
                incomingNews: data.news,
                hasReachedEnd: data.hasReachedEnd,
              ),
              isLoadingNext: false);
        } catch (e) {
          // yield NewsStateError();
        }
      }
    }
  }
}
