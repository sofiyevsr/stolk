import 'package:feedapp/logic/blocs/commentsBloc/models/commentsModel.dart';
import 'package:feedapp/utils/@types/response/comments.dart';
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
        );
      } catch (e) {
        yield CommentsStateError();
      }
    } else if (event is FetchNextCommentsEvent) {
      if (state is CommentsStateWithData &&
          (state as CommentsStateWithData).data.hasReachedEnd == false) {
        if (state is CommentsNextFetchError && event.force != true) {
          return;
        }
        if (state is CommentsNextFetchLoading) {
          return;
        }

        try {
          yield CommentsNextFetchLoading(
              data: (state as CommentsStateWithData).data);
          final existing = (state as CommentsStateWithData);
          final lastID =
              existing.data.comments[existing.data.comments.length - 1].id;

          // set Loading and fetch data then
          final data = await service.getAllComments(event.id, lastID);
          yield CommentsStateSuccess(
            data: existing.data.addNewComments(
              incomingComments: data.comments,
              hasReachedEnd: data.hasReachedEnd,
            ),
          );
        } catch (e) {
          yield CommentsNextFetchError(
              data: (state as CommentsStateWithData).data);
        }
      }
    } else if (event is AddCommentEvent) {
      if (state is CommentsStateSuccess) {
        try {
          final existing = (state as CommentsStateSuccess);

          // set Loading and fetch data then
          yield CommentsStateSuccess(
            data: existing.data.addComment(
              comment: event.comment,
            ),
          );
        } catch (e) {
          // yield (state as CommentsStateSuccess).disableLoading();
        }
      }
    }
  }
}
