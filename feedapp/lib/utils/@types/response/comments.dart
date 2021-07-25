import 'package:equatable/equatable.dart';

class SingleComment extends Equatable {
  final int id;
  final String comment;
  final int userID;
  final bool? isManual;
  SingleComment({
    required this.id,
    required this.comment,
    required this.userID,
    this.isManual = false,
  });
  SingleComment.fromJSON(Map<String, dynamic> json, [bool? isManual])
      : this(
          id: json["id"],
          userID: json["user_id"],
          comment: json["comment"],
          isManual: isManual,
        );
  @override
  List get props => [id, comment, userID];
}

class AllCommentsResponse {
  final List<SingleComment> comments = [];
  final bool hasReachedEnd;
  AllCommentsResponse.fromJSON(Map<String, dynamic> json)
      : this.hasReachedEnd = json['has_reached_end'] {
    if (json['comments'] == null) {
      return;
    }

    for (int i = 0; i < json['comments'].length; i++) {
      comments.add(SingleComment.fromJSON(json['comments'][i]));
    }
  }
  List<dynamic> get props => [comments, hasReachedEnd];
}
