import 'package:feedapp/utils/customDio.dart';

abstract class ApiService {
  late CustomDio request;
  ApiService({bool enableErrorHandler = false}) {
    request = CustomDio(enableErrorHandler: enableErrorHandler);
  }

  void enableErrorHandler() {
    request = CustomDio(enableErrorHandler: true);
  }

  void disableErrorHandler() {
    request = CustomDio(enableErrorHandler: false);
  }
}
