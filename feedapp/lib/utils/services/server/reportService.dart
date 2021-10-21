import 'package:stolk/utils/services/server/apiService.dart';

import '../../common.dart';

class ReportService extends ApiService {
  ReportService() : super();

  Future<void> commentReport(String message, int commentID) async {
    authorize();
    await this.request.post(
          "/report/comment/$commentID",
          {"message": message},
          {},
          handleError: false,
        );
  }

  Future<void> newsReport(String message, int newsID) async {
    authorize();
    await this.request.post(
          "/report/news/$newsID",
          {"message": message},
          {},
          handleError: false,
        );
  }
}
