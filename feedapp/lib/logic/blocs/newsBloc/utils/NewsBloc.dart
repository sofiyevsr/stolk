import 'package:stolk/logic/blocs/newsBloc/models/newsModel.dart';
import 'package:stolk/utils/@types/response/allNews.dart';
import 'package:stolk/utils/common.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/services/server/newsService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:equatable/equatable.dart";

part "NewsEvents.dart";
part "NewsState.dart";

part "../models/newsActionType.dart";

final service = NewsService();

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsStateInitial()) {
    on<FetchNewsEvent>((event, emit) async {
      try {
        emit(NewsStateLoading());
        final data = await service.getAllNews(
          category: event.category,
          sourceID: event.sourceID,
          sortBy: event.sortBy,
          period: event.period,
        );
        if (data.news.isNotEmpty)
          emit(NewsStateSuccess(
            data: NewsModel(
              news: data.news,
              hasReachedEnd: data.hasReachedEnd,
              sortBy: event.sortBy,
              category: event.category,
              period: event.period,
            ),
          ));
        else
          emit(NewsStateNoData());
      } catch (e) {
        emit(NewsStateError());
      }
    });
    // Refresh
    // 1. Event sender must fetch data, because refresh function should wait till async function to be done
    // 2. Event sender is responsible for sending current category
    on<RefreshNewsEvent>((event, emit) async {
      try {
        if (event.data.news.isNotEmpty)
          emit(NewsStateSuccess(
            data: NewsModel(
              news: event.data.news,
              hasReachedEnd: event.data.hasReachedEnd,
              sortBy: event.sortBy,
              category: event.category,
              period: event.period,
            ),
          ));
        else
          emit(NewsStateNoData());
      } catch (e) {
        emit(NewsStateError());
      }
    });
    // Fetch next batch
    on<FetchNextNewsEvent>((event, emit) async {
      if (state is! NewsStateWithData) return;
      if ((state as NewsStateWithData).data.hasReachedEnd == true) {
        return;
      }
      if (state is NewsNextFetchError && event.force != true) {
        return;
      }
      if (state is NewsNextFetchLoading) {
        return;
      }

      try {
        emit(NewsNextFetchLoading(data: (state as NewsStateWithData).data));
        final existing = (state as NewsStateWithData);
        final lastNews = existing.data.news[existing.data.news.length - 1];
        final lastPub = lastNews.publishedDate;

        var cursor;
        if (existing.data.sortBy == NewsSortBy.MOST_READ) {
          cursor = lastNews.readCount;
        } else if (existing.data.sortBy == NewsSortBy.MOST_LIKED) {
          cursor = lastNews.likeCount;
        } else if (existing.data.sortBy == NewsSortBy.POPULAR) {
          cursor = lastNews.weight;
        }

        // set Loading and fetch data then
        final data = await service.getAllNews(
          pubDate: lastPub,
          sourceID: event.sourceID,
          category: existing.data.category,
          sortBy: existing.data.sortBy,
          period: existing.data.period,
          cursor: cursor,
        );
        emit(NewsStateSuccess(
          data: existing.data.addNewNews(
            incomingNews: data.news,
            hasReachedEnd: data.hasReachedEnd,
          ),
        ));
      } catch (e) {
        emit(NewsNextFetchError(data: (state as NewsStateWithData).data));
      }
    });
    // ------------------------------- Bookmarks ------------------------------------
    on<FetchBookmarks>((event, emit) async {
      try {
        emit(NewsStateLoading());
        final data = await service.getBookmarks();
        if (data.news.isNotEmpty)
          emit(NewsStateSuccess(
            data: NewsModel(
              news: data.news,
              hasReachedEnd: data.hasReachedEnd,
              category: null,
              sortBy: null,
              period: null,
            ),
          ));
        else
          emit(NewsStateNoData());
      } catch (e) {
        emit(NewsStateError());
      }
    });
    on<FetchNextBookmarks>((event, emit) async {
      if (state is! NewsStateWithData) return;
      if ((state as NewsStateWithData).data.hasReachedEnd == true) {
        return;
      }
      if (state is NewsNextFetchError && event.force != true) {
        return;
      }
      if (state is NewsNextFetchLoading) {
        return;
      }

      try {
        emit(NewsNextFetchLoading(data: (state as NewsStateWithData).data));
        final existing = (state as NewsStateWithData);
        final lastNews = existing.data.news[existing.data.news.length - 1];
        final lastID = lastNews.fixedBookmarkID;

        // set Loading and fetch data then
        final data = await service.getBookmarks(
          lastID: lastID,
        );
        emit(NewsStateSuccess(
          data: existing.data.addNewNews(
            incomingNews: data.news,
            hasReachedEnd: data.hasReachedEnd,
          ),
        ));
      } catch (e) {
        emit(NewsNextFetchError(data: (state as NewsStateWithData).data));
      }
    });
    // ------------------------------- ACTIONS --------------------------------------
    on<NewsActionEvent>((event, emit) async {
      if (state is NewsStateWithData) {
        final existing = (state as NewsStateWithData);
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
          case NewsActionType.READ:
            modifItem = item.copyWith(
              readID: Nullable(value: 0),
              readCount: item.readCount + 1,
            );
            break;
        }
        emit(NewsStateSuccess(
          data: existing.data.modifySingle(
            item: modifItem,
            index: event.index,
          ),
        ));
      }
    });
  }
}
