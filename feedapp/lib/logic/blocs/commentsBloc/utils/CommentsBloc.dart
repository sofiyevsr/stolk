import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stolk/logic/blocs/commentsBloc/models/commentsModel.dart';
import 'package:stolk/utils/@types/response/comments.dart';
import 'package:stolk/utils/services/server/newsService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:equatable/equatable.dart";

part "CommentsEvents.dart";
part "CommentsState.dart";

final service = NewsService();

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  CommentsBloc() : super(CommentsStateInitial()) {
    on<FetchCommentsEvent>((event, emit) async {
      try {
        emit(CommentsStateLoading());
        final data = await service.getAllComments(event.id, null);
        emit(CommentsStateSuccess(
          data: CommentsModel(
            comments: data.comments,
            hasReachedEnd: data.hasReachedEnd,
          ),
        ));
      } catch (e) {
        emit(CommentsStateError());
      }
    });
    on<FetchNextCommentsEvent>(
      (event, emit) async {
        if (state is CommentsStateWithData &&
            (state as CommentsStateWithData).data.hasReachedEnd == true) {
          return;
        }
        if (state is CommentsNextFetchError && event.force != true) {
          return;
        }
        if (state is CommentsNextFetchLoading) {
          return;
        }

        try {
          emit(
            CommentsNextFetchLoading(
              data: (state as CommentsStateWithData).data,
            ),
          );
          final existing = (state as CommentsStateWithData);
          final lastID =
              existing.data.comments[existing.data.comments.length - 1].id;

          // set Loading and fetch data then
          final data = await service.getAllComments(event.id, lastID);
          emit(CommentsStateSuccess(
            data: existing.data.addNewComments(
              incomingComments: data.comments,
              hasReachedEnd: data.hasReachedEnd,
            ),
          ));
        } catch (e) {
          emit(
            CommentsNextFetchError(
              data: (state as CommentsStateWithData).data,
            ),
          );
        }
      },
      transformer: sequential(),
    );
    on<AddCommentEvent>(
      (event, emit) async {
        if (state is CommentsStateSuccess) {
          try {
            final existing = (state as CommentsStateSuccess);
            // set Loading and fetch data then
            emit(CommentsStateSuccess(
              data: existing.data.addComment(
                comment: event.comment,
              ),
            ));
          } catch (e) {
            // yield (state as CommentsStateSuccess).disableLoading();
          }
        }
      },
      transformer: sequential(),
    );
  }
}
