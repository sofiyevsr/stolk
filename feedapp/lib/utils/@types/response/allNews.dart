import 'package:stolk/utils/common.dart';

class SingleCategory {
  final int id;
  final String name, imageSuffix;
  SingleCategory._({
    required this.id,
    required this.name,
    required this.imageSuffix,
  });
  SingleCategory.fromJSON(Map<String, dynamic> json)
      : this._(
            id: json["id"],
            name: json["name"],
            imageSuffix: json["image_suffix"]);
}

class SingleNews {
  final int id, sourceID, likeCount, commentCount, readCount;
  final String title,
      sourceName,
      sourceLogoSuffix,
      publishedDate,
      createdAt,
      feedLink;
  final int? likeID, bookmarkID, followID, commentID, readID;
  final String? imageLink;
  SingleNews._({
    required this.id,
    required this.sourceID,
    required this.title,
    required this.sourceName,
    required this.sourceLogoSuffix,
    required this.publishedDate,
    required this.createdAt,
    required this.feedLink,
    required this.likeCount,
    required this.commentCount,
    required this.readCount,
    required this.likeID,
    required this.followID,
    required this.commentID,
    required this.readID,
    required this.bookmarkID,
    required this.imageLink,
  });

  SingleNews.fromJson(Map<String, dynamic> json)
      : this._(
          // We have to parse it manually because news id is bigint on db and json can't send it as bigint
          id: int.parse(json['id']),
          sourceID: json['source_id'],
          title: json['title'],
          sourceName: json['source_name'],
          sourceLogoSuffix: json['source_logo_suffix'],
          publishedDate: json['pub_date'],
          createdAt: json['created_at'],
          imageLink: json['image_link'],
          feedLink: json['feed_link'],
          likeID: json["like_id"],
          followID: json["follow_id"],
          commentID: json["comment_id"],
          readID: json["read_history_id"],
          likeCount: json["like_count"],
          readCount: json["read_count"],
          commentCount: json["comment_count"],
          bookmarkID: json["bookmark_id"],
        );
  SingleNews copyWith({
    int? id,
    int? sourceID,
    String? title,
    String? sourceName,
    String? sourceLogoSuffix,
    String? publishedDate,
    String? createdAt,
    String? feedLink,
    int? likeCount,
    int? commentCount,
    int? readCount,
    String? imageLink,

    // these are nullable class because only they can be set to null later
    Nullable<int>? likeID,
    Nullable<int>? bookmarkID,
    Nullable<int>? followID,
    Nullable<int>? readID,
    Nullable<int>? commentID,
  }) =>
      SingleNews._(
        id: id ?? this.id,
        sourceID: sourceID ?? this.sourceID,
        title: title ?? this.title,
        sourceName: sourceName ?? this.sourceName,
        sourceLogoSuffix: sourceLogoSuffix ?? this.sourceLogoSuffix,
        publishedDate: publishedDate ?? this.publishedDate,
        createdAt: createdAt ?? this.createdAt,
        feedLink: feedLink ?? this.feedLink,
        likeCount: likeCount ?? this.likeCount,
        commentCount: commentCount ?? this.likeCount,
        readCount: readCount ?? this.readCount,
        imageLink: imageLink ?? this.imageLink,
        likeID: likeID == null ? this.likeID : likeID.value,
        followID: followID == null ? this.followID : followID.value,
        bookmarkID: bookmarkID == null ? this.bookmarkID : bookmarkID.value,
        readID: readID == null ? this.readID : readID.value,
        commentID: commentID == null ? this.commentID : commentID.value,
      );
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
