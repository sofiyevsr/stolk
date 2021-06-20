import 'package:feedapp/utils/@types/response/allNews.dart';
import 'package:feedapp/utils/services/server/apiService.dart';

class NewsService extends ApiService {
  Future<AllNewsResponse> getAllNews([int? id]) async {
    final response = await this.request.get("/news/all", {
      if (id != null) 'id': id,
    }, {});
    return AllNewsResponse.fromJSON(response.data['body']);
  }
}
