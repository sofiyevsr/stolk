import 'package:equatable/equatable.dart';

class SingleCategory extends Equatable {
  final int id;
  final String name;
  SingleCategory._({required this.id, required this.name});
  SingleCategory.fromJSON(Map<String, dynamic> json)
      : this._(
          id: json["id"],
          name: json["name"],
        );
  @override
  List get props => [
        id,
        name,
      ];
}

class SingleNews extends Equatable {
  final int id;
  final String title;
  final String sourceName;
  final String publishedDate;
  final String createdAt;
  final String feedLink;
  final int likeCount;
  final int commentCount;
  final int? likeID;
  final int? bookmarkID;
  final String? imageLink;
  SingleNews._({
    required this.id,
    required this.title,
    required this.sourceName,
    required this.publishedDate,
    required this.createdAt,
    required this.feedLink,
    required this.likeCount,
    required this.commentCount,
    required this.likeID,
    required this.bookmarkID,
    required this.imageLink,
  });
  SingleNews.fromJson(Map<String, dynamic> json)
      : this._(
          id: json['id'],
          title: json['title'],
          sourceName: json['source_name'],
          publishedDate: json['pub_date'],
          createdAt: json['created_at'],
          imageLink: json['image_link'],
          feedLink: json['feed_link'],
          likeID: json["like_id"],
          likeCount: json["like_count"],
          commentCount: json["comment_count"],
          bookmarkID: json["like_id"],
        );

  @override
  List get props => [
        id,
        title,
        sourceName,
        publishedDate,
        createdAt,
        feedLink,
        likeCount,
        commentCount,
        likeID,
        bookmarkID,
        imageLink,
      ];
}

class AllNewsResponse {
  final List<SingleNews> news = [];
  final bool hasReachedEnd;
  AllNewsResponse.fromJSON(Map<String, dynamic> json)
      : this.hasReachedEnd = json['has_reached_end'] {
    if (json['news'] == null) {
      return;
    }

    for (int i = 0; i < json['news'].length; i++) {
      news.add(SingleNews.fromJson(json['news'][i]));
    }
  }
  List<dynamic> get props => [news, hasReachedEnd];
}

class AllCategoriesResponse {
  final List<SingleCategory> categories = [];
  AllCategoriesResponse.fromJSON(Map<String, dynamic> json) {
    if (json["categories"] != null) {
      for (int i = 0; i < json['categories'].length; i++) {
        categories.add(SingleCategory.fromJSON(json['categories'][i]));
      }
    }
  }
}
