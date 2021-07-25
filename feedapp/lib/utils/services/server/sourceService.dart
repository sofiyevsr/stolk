import 'package:feedapp/utils/common.dart';

import 'apiService.dart';

class SourceService extends ApiService {
  SourceService() : super(enableErrorHandler: false);

  Future<void> follow(int sourceID) async {
    authorize();
    await this.request.post("/source/$sourceID/follow", {}, {});
  }

  Future<void> unfollow(int sourceID) async {
    authorize();
    await this.request.post("/source/$sourceID/unfollow", {}, {});
  }
}
