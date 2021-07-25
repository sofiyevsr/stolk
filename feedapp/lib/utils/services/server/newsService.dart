import 'package:feedapp/utils/@types/response/allNews.dart';
import 'package:feedapp/utils/@types/response/comments.dart';
import 'package:feedapp/utils/common.dart';
import 'package:feedapp/utils/services/server/apiService.dart';

class NewsService extends ApiService {
  NewsService() : super(enableErrorHandler: false);

  Future<AllNewsResponse> getAllNews([String? pubDate, int? category]) async {
    final response = await this.request.get("/news/all", {
      if (pubDate != null) 'pub_date': pubDate,
      if (category != null && category != 0) 'category': category,
    }, {});
    return AllNewsResponse.fromJSON(response.data['body']);
  }

  Future<AllCategoriesResponse> getAllCategories() async {
    final response = await this.request.get("/news/categories", {}, {});
    return AllCategoriesResponse.fromJSON(response.data['body']);
  }

  Future<AllCommentsResponse> getAllComments(int id, [int? lastID]) async {
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
