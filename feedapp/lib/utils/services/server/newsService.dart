import 'package:feedapp/utils/@types/response/allNews.dart';
import 'package:feedapp/utils/services/server/apiService.dart';

class NewsService extends ApiService {
  Future<AllNewsResponse> getAllNews([String? pubDate]) async {
    final response = await this.request.get("/news/all", {
      if (pubDate != null) 'pub_date': pubDate,
    }, {});
    return AllNewsResponse.fromJSON(response.data['body']);
  }
}
