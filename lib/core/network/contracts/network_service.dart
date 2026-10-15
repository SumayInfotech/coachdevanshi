import 'package:dio/dio.dart';

import '../enums/request_type.dart';
import '../models/api_response.dart';

abstract class NetworkService {

  Future<ApiResponse<dynamic>> request({
    required String url,
    required RequestType requestType,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool requiresAuth,
    bool isMultipart,
  });
}