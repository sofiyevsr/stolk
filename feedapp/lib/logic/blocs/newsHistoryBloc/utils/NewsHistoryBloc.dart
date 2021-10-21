import 'package:stolk/logic/blocs/newsHistoryBloc/models/newsHistoryModel.dart';
import 'package:stolk/utils/@types/response/newsHistory.dart';
import 'package:stolk/utils/services/server/newsService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:equatable/equatable.dart";

part "NewsHistoryEvents.dart";
part "NewsHistoryState.dart";

final service = NewsService();

class NewsHistoryBloc extends Bloc<NewsHistoryEvent, NewsHistoryState> {
  NewsHistoryBloc() : super(NewsHistoryStateInitial()) {
    on<FetchHistoryNewsEvent>((event, emit) async {
      try {
        emit(NewsHistoryStateLoading());
        final data = await service.getAllHistoryNews(
          filterBy: event.filterBy,
        );
        if (data.news.length != 0)
          emit(NewsHistoryStateSuccess(
            data: NewsHistoryModel(
              news: data.news,
              hasReachedEnd: data.hasReachedEnd,
            ),
          ));
        else
          emit(NewsHistoryStateNoData());
      } catch (e) {
        emit(NewsHistoryStateError());
      }
    });
    on<FetchNextHistoryNewsEvent>((event, emit) async {
      // Has already reached end?
      if (state is NewsHistoryStateWithData &&
          (state as NewsHistoryStateWithData).data.hasReachedEnd == true) {
        return;
      }
      if (state is NewsHistoryNextFetchError && event.force != true) {
        return;
      }
      if (state is NewsHistoryNextFetchLoading) {
        return;
      }

      try {
        emit(
          NewsHistoryNextFetchLoading(
            data: (state as NewsHistoryStateWithData).data,
          ),
        );
        final existing = (state as NewsHistoryStateWithData);
        final lastID = findCurrentFilteryByContentID(
          existing.data.news[existing.data.news.length - 1],
          event.filterBy,
        );
        if (lastID == null) {
          throw Error();
        }
        // set Loading and fetch data then
        final data = await service.getAllHistoryNews(
          id: lastID,
          filterBy: event.filterBy,
        );
        emit(
          NewsHistoryStateSuccess(
            data: existing.data.addNewNews(
              incomingNews: data.news,
              hasReachedEnd: data.hasReachedEnd,
            ),
          ),
        );
      } catch (e) {
        emit(
          NewsHistoryNextFetchError(
            data: (state as NewsHistoryStateWithData).data,
          ),
        );
      }
    });
  }

  int? findCurrentFilteryByContentID(NewsHistory news, String filterBy) {
    switch (filterBy) {
      case "like":
        return news.likeID;
      case "comment":
        return news.commentID;
      case "bookmark":
        return news.bookmarkID;
      case "read":
        return news.readID;
    }
  }
}
