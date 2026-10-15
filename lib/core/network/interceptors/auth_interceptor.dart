import 'package:dio/dio.dart';

import '../../services/preference_service.dart';

class AuthInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    /// Read custom auth flag
    bool requiresAuth = options.extra["requiresAuth"] ?? true;

    /// Common Headers
    options.headers["Accept"] = "application/json";
    if (options.data is! FormData && options.contentType != Headers.multipartFormDataContentType) {
      options.headers["Content-Type"] = "application/json";
    } else {
      options.headers.remove("Content-Type");
      options.headers.remove("content-type");
    }

    /// Attach token only if needed
    if (requiresAuth) {
      final token = AppPreferences.getString(AppPreferences.accessToken);
      if (token.isNotEmpty) {
        options.headers["Authorization"] = "Bearer $token";
      }
    }

    super.onRequest(options, handler);
  }
}
