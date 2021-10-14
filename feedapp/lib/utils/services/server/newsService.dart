import 'package:stolk/utils/@types/response/allNews.dart';
import 'package:stolk/utils/@types/response/comments.dart';
import 'package:stolk/utils/common.dart';
import 'package:stolk/utils/services/server/apiService.dart';

class NewsService extends ApiService {
  NewsService() : super(enableErrorHandler: true);

  Future<AllNewsResponse> getAllNews({
    String? pubDate,
    int? category,
    int? sourceID,
    int? sortBy,
    dynamic cursor,
  }) async {
    final response = await this.request.get("/news/all", {
      if (pubDate != null) 'pub_date': pubDate,
      if (sourceID != null) 'source_id': sourceID,
      if (sortBy != null) 'sort_by': sortBy,
      if (cursor != null) 'cursor': cursor,
      if (category != null && category != 0) 'category': category,
    }, {});
    return AllNewsResponse.fromJSON(response.data['body']);
  }

  Future<AllNewsResponse> getAllHistoryNews({
    required String filterBy,
    int? id,
  }) async {
    final response = await this.request.get("/news/my-history", {
      if (id != null) 'id': id,
      'filter_by': filterBy,
    }, {});
    print(response.data['body']);
    return AllNewsResponse.fromJSON(response.data['body']);
  }

  Future<AllCategoriesResponse> getAllCategories() async {
    final response = await this.request.get("/news/categories", {}, {});
    return AllCategoriesResponse.fromJSON(response.data['body']);
  }

  Future<AllCommentsResponse> getAllComments(int id, int? lastID) async {
    final response = await this.request.get("/news/$id/comments", {
      if (lastID != null) 'last_id': lastID,
    }, {});
    return AllCommentsResponse.fromJSON(response.data['body']);
  }

  Future<SingleComment> comment(int newsID, String body) async {
    authorize();
    final response = await this.request.post("/news/$newsID/comment", {
      'comment': body,
    }, {});
    return SingleComment.fromJSON(response.data["body"]["comment"], true);
  }

  Future<void> like(int newsID) async {
    authorize();
    await this.request.post("/news/$newsID/like", {}, {});
  }

  Future<void> markRead(int newsID) async {
    await this.request.post("/news/$newsID/read", {}, {});
  }

  Future<void> unlike(int newsID) async {
    authorize();
    await this.request.post("/news/$newsID/unlike", {}, {});
  }

  Future<void> bookmark(int newsID) async {
    authorize();
    await this.request.post("/news/$newsID/bookmark", {}, {});
  }

  Future<void> unbookmark(int newsID) async {
    authorize();
    await this.request.post("/news/$newsID/unbookmark", {}, {});
  }
}
