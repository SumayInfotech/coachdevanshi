import '../../main.dart';
import '../models/chat/chat_messages_model.dart';
import '../models/common_model.dart';
import '../network/base/base_repository.dart';
import '../network/enums/request_type.dart';
import '../network/models/api_response.dart';

class ChatRepo extends BaseRepository {
  Future<ApiResponse<dynamic>> getMessages({
    required String url,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await networkService.request(
      url: url,
      requestType: RequestType.get,
      queryParameters: queryParameters,
    );

    if (response.data == null) {
      return ApiResponse.failure(message: response.message);
    }

    try {
      ChatMessagesModel model = ChatMessagesModel.fromJson(response.data);

      if (model.success == true) {
        return ApiResponse.success(data: model, message: model.message ?? "");
      } else {
        return ApiResponse.failure(message: model.message ?? "");
      }
    } catch (e) {
      appLog(name: "ChatRepo getMessages Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

  Future<ApiResponse<dynamic>> sendMessage({
    required String url,
    required Map<String, dynamic> body,
    bool isMultipart = false,
  }) async {
    final response = await networkService.request(
      url: url,
      requestType: RequestType.post,
      body: body,
      isMultipart: isMultipart,
    );

    if (response.data == null) {
      return ApiResponse.failure(message: response.message);
    }

    try {
      CommonModel model = CommonModel.fromJson(response.data);

      if (model.success == true) {
        return ApiResponse.success(data: model, message: model.message ?? "");
      } else {
        return ApiResponse.failure(message: model.message ?? "");
      }
    } catch (e) {
      appLog(name: "ChatRepo sendMessage Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }
}
