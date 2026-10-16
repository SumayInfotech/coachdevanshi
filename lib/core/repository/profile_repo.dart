import '../../main.dart';

import '../models/profile/location_model.dart';

import '../models/profile/onboarding_masters_model.dart';
import '../network/base/base_repository.dart';
import '../network/enums/request_type.dart';
import '../network/models/api_response.dart';

class ProfileRepo extends BaseRepository {

  Future<ApiResponse<dynamic>> location ({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    final response = await networkService.request(url: url, requestType: RequestType.get, queryParameters: body);

    if (response.data == null) {
      return ApiResponse.failure(message: response.message);
    }

    try {
      /// Convert JSON -> Model
      LocationModel model = LocationModel.fromJson(response.data);

      if (model.success == true) {
        return ApiResponse.success(data: model, message: model.message ?? "");
      } else {
        return ApiResponse.failure(message: model.message ?? "");
      }
    } catch (e) {
      appLog(name: "ProfileRepo location Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

  Future<ApiResponse<dynamic>> onboardingMasters ({
    required String url,
  }) async {
    final response = await networkService.request(url: url, requestType: RequestType.get);

    if (response.data == null) {
      return ApiResponse.failure(message: response.message);
    }

    try {
      /// Convert JSON -> Model
      OnboardingMastersModel model = OnboardingMastersModel.fromJson(response.data);

      if (model.success == true) {
        return ApiResponse.success(data: model, message: model.message ?? "");
      } else {
        return ApiResponse.failure(message: model.message ?? "");
      }
    } catch (e) {
      appLog(name: "ProfileRepo onboardingMasters Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

}