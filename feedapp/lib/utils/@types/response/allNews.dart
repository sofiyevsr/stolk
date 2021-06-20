import 'package:equatable/equatable.dart';

class SingleNews extends Equatable {
  final int id;
  final String title;
  final String? description;
  final String sourceName;
  final String publishedDate;
  final String imageLink;
  final String feedLink;
  SingleNews._({
    required this.id,
    required this.title,
    this.description,
    required this.sourceName,
    required this.publishedDate,
    required this.imageLink,
    required this.feedLink,
  });
  SingleNews.fromJson(Map<String, dynamic> json)
      : this._(
          id: json['id'],
          title: json['title'],
          description: json['description'],
          sourceName: json['source_name'],
          publishedDate: json['pub_date'],
          imageLink: json['image_link'],
          feedLink: json['link'],
        );

  @override
  List get props => [
        id,
        title,
        description,
        sourceName,
        publishedDate,
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
