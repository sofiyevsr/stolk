import 'package:stolk/utils/@types/response/comments.dart';

class CommentsModel {
  final List<SingleComment> comments;
  final bool hasReachedEnd;
  const CommentsModel({required this.comments, required this.hasReachedEnd});
  CommentsModel addNewComments({
    required bool hasReachedEnd,
    required List<SingleComment> incomingComments,
  }) =>
      CommentsModel(
        comments: [...this.comments, ...incomingComments],
        hasReachedEnd: hasReachedEnd,
      );

  CommentsModel addComment({
    required SingleComment comment,
  }) =>
      CommentsModel(
        comments: [comment, ...this.comments],
        hasReachedEnd: this.hasReachedEnd,
      );
}
