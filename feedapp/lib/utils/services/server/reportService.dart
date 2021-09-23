import 'package:stolk/utils/services/server/apiService.dart';

class ReportService extends ApiService {
  ReportService() : super(enableErrorHandler: false);

  Future<void> commentReport(String message, int commentID) async {
    await this.request.post(
      "/report/comment/$commentID",
      {"message": message},
      {},
    );
  }

  Future<void> newsReport(String message, int newsID) async {
    await this.request.post(
      "/report/news/$newsID",
      {"message": message},
      {},
    );
  }
}
