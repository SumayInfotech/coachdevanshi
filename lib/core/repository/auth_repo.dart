import 'package:coach_devanshi_doshi/core/models/auth/user_model.dart';
import 'package:coach_devanshi_doshi/main.dart';

import '../models/auth/sign_up_model.dart';
import '../models/common_model.dart';
import '../network/base/base_repository.dart';
import '../network/enums/request_type.dart';
import '../network/models/api_response.dart';

class AuthRepo extends BaseRepository {

  Future<ApiResponse<dynamic>> signUp ({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    final response = await networkService.request(url: url, requestType: RequestType.post, body: body);

    if (response.data == null) {
      return ApiResponse.failure(message: response.message);
    }

    try {
      /// Convert JSON -> Model
      SignUpModel model = SignUpModel.fromJson(response.data);

      if (model.success == true) {
        return ApiResponse.success(data: model, message: model.message ?? "");
      } else {
        return ApiResponse.failure(message: model.message ?? "");
      }
    } catch (e) {
      appLog(name: "AuthRepo signUp Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

  Future<ApiResponse<dynamic>> login ({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    final response = await networkService.request(url: url, requestType: RequestType.post, body: body);

    if (response.data == null) {
      return ApiResponse.failure(message: response.message);
    }

    try {
      /// Convert JSON -> Model
      SignUpModel model = SignUpModel.fromJson(response.data);

      if (model.success == true) {
        return ApiResponse.success(data: model, message: model.message ?? "");
      } else {
        return ApiResponse.failure(message: model.message ?? "");
      }
    } catch (e) {
      appLog(name: "AuthRepo login Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

  Future<ApiResponse<dynamic>> verifyOTP ({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    final response = await networkService.request(url: url, requestType: RequestType.post, body: body);

    if (response.data == null) {
      return ApiResponse.failure(message: response.message);
    }

    try {
      /// Convert JSON -> Model
      UserModel model = UserModel.fromJson(response.data);

      if (model.success == true) {
        return ApiResponse.success(data: model, message: model.message ?? "");
      } else {
        return ApiResponse.failure(message: model.message ?? "");
      }
    } catch (e) {
      appLog(name: "AuthRepo verifyOTP Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

  Future<ApiResponse<dynamic>> resendSignUpOtp ({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    final response = await networkService.request(url: url, requestType: RequestType.post, body: body);

    if (response.data == null) {
      return ApiResponse.failure(message: response.message);
    }

    try {
      /// Convert JSON -> Model
      CommonModel model = CommonModel.fromJson(response.data);

      if (model.success == true) {
        return ApiResponse.success(data: model, message: model.message ?? "");
      } else {
        return ApiResponse.failure(message: model.message ?? "");
      }
    } catch (e) {
      appLog(name: "AuthRepo resendSignUpOtp Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

  Future<ApiResponse<dynamic>> profile ({
    required String url,
  }) async {
    final response = await networkService.request(url: url, requestType: RequestType.get);

    if (response.data == null) {
      return ApiResponse.failure(message: response.message);
    }

    try {
      /// Convert JSON -> Model
      UserModel model = UserModel.fromJson(response.data);

      if (model.success == true) {
        return ApiResponse.success(data: model, message: model.message ?? "");
      } else {
        return ApiResponse.failure(message: model.message ?? "");
      }
    } catch (e) {
      appLog(name: "AuthRepo profile Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

  Future<ApiResponse<dynamic>> logout ({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    final response = await networkService.request(url: url, requestType: RequestType.post, body: body);

    if (response.data == null) {
      return ApiResponse.failure(message: response.message);
    }

    try {
      /// Convert JSON -> Model
      CommonModel model = CommonModel.fromJson(response.data);

      if (model.success == true) {
        return ApiResponse.success(data: model, message: model.message ?? "");
      } else {
        return ApiResponse.failure(message: model.message ?? "");
      }
    } catch (e) {
      appLog(name: "AuthRepo logout Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

}