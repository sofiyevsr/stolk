import 'package:feedapp/utils/@types/response/allNews.dart';
import 'package:feedapp/utils/common.dart';
import 'package:feedapp/utils/services/server/apiService.dart';

class NewsService extends ApiService {
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

  Future<void> like(int newsID) async {
    final isAuth = authorize();
    if (isAuth == true) await this.request.get("/news/$newsID/like", {}, {});
  }
}
