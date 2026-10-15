import 'dart:io';

import 'package:dio/dio.dart';

import '../../../main.dart';
import '../../../ui/screens/splash/splash_screen.dart';
import '../../constants/utils.dart';
import '../../services/loader_service.dart';
import '../../services/preference_service.dart';
import '../models/api_exception.dart';

class ErrorInterceptor extends Interceptor {

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String message = somethingWentWrong;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        message = connectionTimeout;
        break;

      case DioExceptionType.badResponse:
        switch (err.response?.statusCode) {
          case 400:
            message = badRequest;
            break;

          case 401:
            LoaderService.hide();
            AppPreferences.clearPreferences();
            navigation.pushAndRemoveUntilSlideAnimation(navigatorKey.currentContext!, const SplashScreen());
            message = unauthorized;
            break;

          case 404:
            message = notFound;
            break;

          case 405:
            message = methodNotAllowed;
            break;

          case 500:
            message = internalServerError;
            break;

          default:
            message = err.response?.data["message"] ?? somethingWentWrong;
        }

        break;

      default:
        if (err.error is SocketException) {
          message = noInternetFound;
        }
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: ApiException(
          message: message,
          statusCode: err.response?.statusCode,
        ),
      ),
    );
  }
}
