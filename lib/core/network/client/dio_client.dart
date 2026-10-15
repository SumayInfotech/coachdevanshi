import 'package:dio/dio.dart';
import '../../constants/urls.dart';
import '../interceptors/auth_interceptor.dart';
import '../interceptors/error_interceptor.dart';
import '../interceptors/logger_interceptor.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();

  factory DioClient() => _instance;

  late final Dio dio;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: Urls.baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
        responseType: ResponseType.json,
        contentType: Headers.jsonContentType,
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(),
      LoggerInterceptor(),
      ErrorInterceptor(),
    ]);
  }
}
