part of "CommentsBloc.dart";

class CommentsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchCommentsEvent extends CommentsEvent {
  final int id;
  FetchCommentsEvent({required this.id});

  List<Object?> get props => [id];
}

class FetchNextCommentsEvent extends CommentsEvent {
  final int id;
  final bool? force;
  FetchNextCommentsEvent({required this.id, this.force});

  List<Object?> get props => [id];
}

class AddCommentEvent extends CommentsEvent {
  final SingleComment comment;
  AddCommentEvent({
    required this.comment,
  });

  List<Object?> get props => [
        comment,
      ];
}
