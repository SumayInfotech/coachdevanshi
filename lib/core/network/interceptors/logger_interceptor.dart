import 'package:dio/dio.dart';

import '../../../main.dart';

class LoggerInterceptor extends Interceptor {

  String _formatBody(dynamic data) {
    if (data is FormData) {
      final fieldsMap = {for (var entry in data.fields) entry.key: entry.value};
      final filesMap = {for (var entry in data.files) entry.key: entry.value.filename ?? ""};
      return "FormData(fields: $fieldsMap, files: $filesMap)";
    }
    return "$data";
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    appLog(name: "API REQUEST", '''
━━━━━━━━━━━━━━━━━━━━
METHOD : ${options.method}
URL    : ${options.uri}
HEADERS: ${options.headers}
QUERY  : ${options.queryParameters}
BODY   : ${_formatBody(options.data)}
━━━━━━━━━━━━━━━━━━━━
''');

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    appLog(name: "API RESPONSE", '''
━━━━━━━━━━━━━━━━━━━━
STATUS : ${response.statusCode}
URL    : ${response.requestOptions.uri}
DATA   : ${response.data}
━━━━━━━━━━━━━━━━━━━━
''');

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    appLog(name: "API ERROR", '''
━━━━━━━━━━━━━━━━━━━━
STATUS : ${err.response?.statusCode}
MESSAGE: ${err.message}
ERROR  : ${err.response?.data}
━━━━━━━━━━━━━━━━━━━━
''');

    super.onError(err, handler);
  }
}
