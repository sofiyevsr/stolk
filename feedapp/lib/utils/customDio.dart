import "package:dio/dio.dart";
import 'package:easy_localization/easy_localization.dart';
import 'package:feedapp/logic/blocs/authBloc/auth.dart';
import 'package:feedapp/utils/services/app/toastService.dart';
import "constants.dart";

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      print(err.response);
      if (err.response?.statusCode == 401) {
        AuthBloc.instance.add(ApiForceLogout());
        ToastService.showAlert(tr("server_errors.session_expired"));
      } else if (tr(err.response?.data["message"]) ==
          err.response?.data["message"])
        ToastService.showAlert(tr("errors.default"));
      else {
        ToastService.showAlert(
            tr('server_errors.${err.response?.data["message"]}'));
      }
    } else
      ToastService.showAlert(tr("errors.network_error"));

    return super.onError(err, handler);
  }
}

class CustomInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (AuthBloc.instance.state is AuthorizedState) {
      final token = (AuthBloc.instance.state as AuthorizedState).token;
      options.headers['authorization'] = 'Bearer $token';
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return super.onResponse(response, handler);
  }
}

class CustomDio {
  late Dio _dio;
  CustomDio({bool enableErrorHandler = false}) {
    final BaseOptions _options = BaseOptions(
        connectTimeout: 6000,
        baseUrl: apiUrl,
        contentType: Headers.jsonContentType);

    _dio = Dio(_options);
    if (enableErrorHandler == true) _dio.interceptors.add(ErrorInterceptor());
    _dio.interceptors.add(CustomInterceptor());
  }

  Future<Response<T>> get<T>(
      String path, Map<String, dynamic>? data, Map<String, dynamic>? headers,
      [Map<String, dynamic>? queries]) {
    return _dio.get<T>(path,
        queryParameters: data, options: Options(headers: headers));
  }

  Future<Response<T>> post<T>(
      String path, Map<String, dynamic>? data, Map<String, dynamic>? headers,
      [Map<String, dynamic>? queries]) {
    return _dio.post<T>(path,
        data: data,
        queryParameters: queries,
        options: Options(headers: headers));
  }

  Future<Response<T>> patch<T>(
      String path, Map<String, dynamic>? data, Map<String, dynamic>? headers) {
    return _dio.patch<T>(path, data: data, options: Options(headers: headers));
  }

  Future<Response<T>> put<T>(
      String path, Map<String, dynamic>? data, Map<String, dynamic>? headers) {
    return _dio.put<T>(path, data: data, options: Options(headers: headers));
  }

  Future<Response<T>> delete<T>(
      String path, Map<String, dynamic>? data, Map<String, dynamic>? headers) {
    return _dio.delete<T>(path, data: data, options: Options(headers: headers));
  }
}
