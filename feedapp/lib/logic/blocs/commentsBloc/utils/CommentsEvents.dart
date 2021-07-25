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
  FetchNextCommentsEvent({required this.id});

  List<Object?> get props => [id];
}

class AddCommentEvent extends CommentsEvent {
  final String body;
  final int newsID;
  AddCommentEvent({
    required this.body,
    required this.newsID,
  });

  List<Object?> get props => [body, newsID];
}
