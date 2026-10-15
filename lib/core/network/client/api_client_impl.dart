import 'package:dio/dio.dart';
import '../contracts/network_service.dart';
import '../enums/request_type.dart';
import '../helpers/form_data_helper.dart';
import '../models/api_exception.dart';
import '../models/api_response.dart';
import 'dio_client.dart';

class ApiClientImpl implements NetworkService {
  final Dio _dio = DioClient().dio;

  @override
  Future<ApiResponse<dynamic>> request({
    required String url,
    required RequestType requestType,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool requiresAuth = true,
    bool isMultipart = false,
  }) async {
    try {
      Response response;

      final options = Options(
        extra: {"requiresAuth": requiresAuth},
        contentType: isMultipart ? Headers.multipartFormDataContentType : Headers.jsonContentType,
      );

      dynamic requestData = body;

      /// Multipart conversion
      if (isMultipart && body != null) {
        requestData = await FormDataHelper.generate(body);
      }

      switch (requestType) {
        case RequestType.get:
          response = await _dio.get(
            url,
            queryParameters: queryParameters,
            cancelToken: cancelToken,
            options: options,
          );

          break;

        case RequestType.post:
          response = await _dio.post(
            url,
            data: requestData,
            queryParameters: queryParameters,
            cancelToken: cancelToken,
            options: options,
          );
          break;

        case RequestType.put:
          response = await _dio.put(
            url,
            data: requestData,
            queryParameters: queryParameters,
            options: options,
          );
          break;

        case RequestType.patch:
          response = await _dio.patch(
            url,
            data: requestData,
            queryParameters: queryParameters,
            options: options,
          );
          break;

        case RequestType.delete:
          response = await _dio.delete(
            url,
            data: requestData,
            queryParameters: queryParameters,
            options: options,
          );
          break;
      }

      return ApiResponse.success(
        data: response.data,
        message: response.statusMessage ?? "Success",
      );
    } on DioException catch (e) {
      if (e.error is ApiException) {
        final error = e.error as ApiException;
        return ApiResponse.failure(message: error.message);
      } else {
        return ApiResponse.failure(
          message: e.message ?? e.response?.statusMessage ?? "Something went wrong",
        );
      }
    } catch (e) {
      return ApiResponse.failure(message: e.toString());
    }
  }
}
