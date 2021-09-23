import 'package:stolk/utils/@types/response/allSources.dart';
import 'package:stolk/utils/common.dart';

import 'apiService.dart';

class SourceService extends ApiService {
  SourceService() : super(enableErrorHandler: true);

  Future<AllSourcesResponse> getAllSources() async {
    final response = await this.request.get("/source", {}, {});
    return AllSourcesResponse.fromJSON(response.data['body']);
  }

  Future<void> follow(int sourceID) async {
    authorize();
    await this.request.post("/source/$sourceID/follow", {}, {});
  }

  Future<void> unfollow(int sourceID) async {
    authorize();
    await this.request.post("/source/$sourceID/unfollow", {}, {});
  }
}
