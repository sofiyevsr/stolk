import 'package:stolk/utils/customDio.dart';

abstract class ApiService {
  late CustomDio request;
  ApiService() {
    request = CustomDio();
  }
}
