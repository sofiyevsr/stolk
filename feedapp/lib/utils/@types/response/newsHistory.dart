class NewsHistory {
  final int id;
  final String title, createdAt, feedLink;
  final String? comment;
  final int? likeID, bookmarkID, commentID, readID;
  NewsHistory._({
    required this.id,
    required this.title,
    required this.feedLink,
    required this.likeID,
    required this.commentID,
    required this.readID,
    required this.bookmarkID,
    required this.createdAt,
    required this.comment,
  });

  NewsHistory.fromJSON(Map<String, dynamic> json)
      : this._(
          // We have to parse it manually because news id is bigint on db and json can't send it as bigint
          id: int.parse(json['id']),
          title: json['title'],
          feedLink: json['feed_link'],
          likeID: json["like_id"],
          commentID: json["comment_id"],
          readID: json["read_history_id"],
          bookmarkID: json["bookmark_id"],
          comment: json["comment"],
          createdAt: json['created_at'],
        );
}

class NewsHistoryResponse {
  final List<NewsHistory> news = [];
  final bool hasReachedEnd;
  NewsHistoryResponse.fromJSON(Map<String, dynamic> json)
      : this.hasReachedEnd = json['has_reached_end'] {
    if (json['news'] == null) {
      return;
    }
    for (int i = 0; i < json['news'].length; i++) {
      news.add(NewsHistory.fromJSON(json['news'][i]));
    }
  }
}
