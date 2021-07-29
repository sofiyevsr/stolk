import 'package:feedapp/logic/blocs/commentsBloc/models/commentsModel.dart';
import 'package:feedapp/utils/services/server/newsService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:equatable/equatable.dart";

part "CommentsEvents.dart";
part "CommentsState.dart";

final service = NewsService();

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  CommentsBloc() : super(CommentsStateInitial());

  @override
  Stream<CommentsState> mapEventToState(CommentsEvent event) async* {
    if (event is FetchCommentsEvent) {
      try {
        yield CommentsStateLoading();
        final data = await service.getAllComments(event.id, null);
        yield CommentsStateSuccess(
          data: CommentsModel(
            comments: data.comments,
            hasReachedEnd: data.hasReachedEnd,
          ),
          isLoadingNext: false,
        );
      } catch (e) {
        yield CommentsStateError();
      }
    } else if (event is FetchNextCommentsEvent) {
      if (state is CommentsStateSuccess &&
          (state as CommentsStateSuccess).isLoadingNext == false &&
          (state as CommentsStateSuccess).data.hasReachedEnd == false) {
        try {
          yield (state as CommentsStateSuccess).setLoading();
          final existing = (state as CommentsStateSuccess);
          final lastID =
              existing.data.comments[existing.data.comments.length - 1].id;

          // set Loading and fetch data then
          final data = await service.getAllComments(event.id, lastID);
          yield CommentsStateSuccess(
            data: existing.data.addNewComments(
              incomingComments: data.comments,
              hasReachedEnd: data.hasReachedEnd,
            ),
            isLoadingNext: false,
          );
        } catch (e) {
          yield (state as CommentsStateSuccess).disableLoading();
        }
      }
    } else if (event is AddCommentEvent) {
      if (state is CommentsStateSuccess) {
        try {
          final existing = (state as CommentsStateSuccess);

          // set Loading and fetch data then
          final data = await service.comment(event.newsID, event.body);
          yield CommentsStateSuccess(
            data: existing.data.addComment(
              comment: data,
            ),
            isLoadingNext: false,
          );
        } catch (e) {
          // yield (state as CommentsStateSuccess).disableLoading();
        }
      }
    }
  }
}
