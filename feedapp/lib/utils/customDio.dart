import "package:dio/dio.dart";
import 'package:easy_localization/easy_localization.dart';
import 'package:stolk/logic/blocs/authBloc/auth.dart';
import 'package:stolk/utils/services/app/toastService.dart';
import "constants.dart";

class CustomInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      if (err.response?.statusCode == 401) {
        AuthBloc.instance.add(ApiForceLogout());
        ToastService.instance.showAlert(tr("server_errors.invalid_token"));
      }
    }
    return super.onError(err, handler);
  }

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
  CustomDio() {
    final BaseOptions _options = BaseOptions(
      connectTimeout: 10000,
      baseUrl: apiUrl,
      contentType: Headers.jsonContentType,
    );
    _dio = Dio(_options);
    _dio.interceptors.add(CustomInterceptor());
  }
  void _onError(
    DioError err,
  ) {
    final message = "server_errors.${err.response?.data['message']}";
    if (err.response != null) {
      if (tr(message) == message)
        ToastService.instance.showAlert(tr("errors.default"));
      else {
        ToastService.instance.showAlert(tr(message));
      }
    } else
      ToastService.instance.showAlert(tr("errors.network_error"));
  }

  Future<Response<T>> get<T>(
    String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers, {
    bool handleError = true,
    Map<String, dynamic>? queries,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: data,
        options: Options(headers: headers),
      );
      return response;
    } catch (e) {
      if (e is DioError && handleError == true) {
        _onError(e);
      }
      rethrow;
    }
  }

  Future<Response<T>> post<T>(
    String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers, {
    bool handleError = true,
    Map<String, dynamic>? queries,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queries,
        options: Options(headers: headers),
      );
      return response;
    } catch (e) {
      if (e is DioError && handleError == true) {
        _onError(e);
      }
      rethrow;
    }
  }

  Future<Response<T>> patch<T>(
    String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers, {
    bool handleError = true,
  }) async {
    try {
      final response = await _dio.patch<T>(
        path,
        data: data,
        options: Options(headers: headers),
      );
      return response;
    } catch (e) {
      if (e is DioError && handleError == true) {
        _onError(e);
      }
      rethrow;
    }
  }

  Future<Response<T>> put<T>(
    String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers, {
    bool handleError = true,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        options: Options(headers: headers),
      );
      return response;
    } catch (e) {
      if (e is DioError && handleError == true) {
        _onError(e);
      }
      rethrow;
    }
  }

  Future<Response<T>> delete<T>(
    String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers, {
    bool handleError = true,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        options: Options(headers: headers),
      );
      return response;
    } catch (e) {
      if (e is DioError && handleError == true) {
        _onError(e);
      }
      rethrow;
    }
  }
}
