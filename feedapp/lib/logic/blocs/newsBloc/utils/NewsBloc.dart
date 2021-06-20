import 'package:feedapp/logic/blocs/newsBloc/models/newsModel.dart';
import 'package:feedapp/utils/services/server/newsService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:equatable/equatable.dart";

part "NewsEvents.dart";
part "NewsState.dart";

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsStateInitial());

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    final service = NewsService();
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
          );
        else
          yield NewsStateNoData();
      } catch (e) {
        print(e);
        yield NewsStateError();
      }
    } else if (event is FetchNextNewsEvent) {
      if (state is NewsStateSuccess &&
          (state as NewsStateSuccess).data.hasReachedEnd == false) {
        try {
          final existing = (state as NewsStateSuccess).data;
          final data = await service
              .getAllNews(existing.news[existing.news.length - 1].id);
          yield NewsStateSuccess(
            data: existing.addNewNews(
              incomingNews: data.news,
              hasReachedEnd: data.hasReachedEnd,
            ),
          );
        } catch (e) {
          // yield NewsStateError();
        }
      }
    }
  }
}
