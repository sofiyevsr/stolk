import 'package:feedapp/logic/blocs/newsBloc/models/newsModel.dart';
import 'package:feedapp/utils/@types/response/allNews.dart';
import 'package:feedapp/utils/common.dart';
import 'package:feedapp/utils/services/server/newsService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:equatable/equatable.dart";

part "NewsEvents.dart";
part "NewsState.dart";

part "../models/newsActionType.dart";

final service = NewsService();

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsStateInitial());

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    if (event is FetchNewsEvent) {
      try {
        yield NewsStateLoading();
        final data = await service.getAllNews(
          pubDate: null,
          category: event.category,
          sourceID: event.sourceID,
          filterBy: event.filterBy,
        );
        if (data.news.length != 0)
          yield NewsStateSuccess(
            data: NewsModel(
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
    }

    // Refresh
    // 1. Event sender must fetch data
    // 2. Event sender is responsible for sending current category
    else if (event is RefreshNewsEvent) {
      try {
        if (event.data.news.length != 0)
          yield NewsStateSuccess(
            data: NewsModel(
              news: event.data.news,
              hasReachedEnd: event.data.hasReachedEnd,
            ),
            isLoadingNext: false,
          );
        else
          yield NewsStateNoData();
      } catch (e) {
        yield NewsStateError();
      }
    }
    // Fetch next batch
    // 1. Keep in mind current category
    else if (event is FetchNextNewsEvent) {
      if (state is NewsStateSuccess &&
          (state as NewsStateSuccess).isLoadingNext == false &&
          (state as NewsStateSuccess).data.hasReachedEnd == false) {
        try {
          yield (state as NewsStateSuccess).setLoading();
          final existing = (state as NewsStateSuccess);
          final lastPub =
              existing.data.news[existing.data.news.length - 1].publishedDate;

          // set Loading and fetch data then
          final data = await service.getAllNews(
            pubDate: lastPub,
            sourceID: event.sourceID,
            category: event.category,
            filterBy: event.filterBy,
          );
          yield NewsStateSuccess(
            data: existing.data.addNewNews(
              incomingNews: data.news,
              hasReachedEnd: data.hasReachedEnd,
            ),
            isLoadingNext: false,
          );
        } catch (e) {
          yield (state as NewsStateSuccess).disableLoading();
        }
      }
    }
    // ------------------------------- ACTIONS --------------------------------------
    else if (event is NewsActionEvent) {
      if (state is NewsStateSuccess) {
        final existing = (state as NewsStateSuccess);
        final item = existing.data.news[event.index];
        SingleNews modifItem;
        switch (event.type) {
          case NewsActionType.LIKE:
            modifItem = item.copyWith(
                likeID: Nullable(value: 0), likeCount: item.likeCount + 1);
            break;
          case NewsActionType.UNLIKE:
            modifItem = item.copyWith(
                likeID: Nullable(value: null), likeCount: item.likeCount - 1);
            break;
          case NewsActionType.BOOKMARK:
            modifItem = item.copyWith(bookmarkID: Nullable(value: 0));
            break;
          case NewsActionType.UNBOOKMARK:
            modifItem = item.copyWith(bookmarkID: Nullable(value: null));
            break;
          case NewsActionType.FOLLOW:
            modifItem = item.copyWith(followID: Nullable(value: 0));
            break;
          case NewsActionType.UNFOLLOW:
            modifItem = item.copyWith(followID: Nullable(value: null));
            break;
        }
        yield NewsStateSuccess(
          data: existing.data.modifySingle(
            item: modifItem,
            index: event.index,
          ),
          isLoadingNext: existing.isLoadingNext,
        );
      }
    }
  }
}
