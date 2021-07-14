import 'package:equatable/equatable.dart';

class SingleNews extends Equatable {
  final int id;
  final String title;
  final String sourceName;
  final String publishedDate;
  final String createdAt;
  final String? imageLink;
  final String feedLink;
  SingleNews._({
    required this.id,
    required this.title,
    required this.sourceName,
    required this.publishedDate,
    required this.createdAt,
    this.imageLink,
    required this.feedLink,
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
        );

  @override
  List get props => [
        id,
        title,
        sourceName,
        publishedDate,
        createdAt,
        imageLink,
        feedLink,
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
}
