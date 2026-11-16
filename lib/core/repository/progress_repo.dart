import '../../main.dart';
import '../models/common_model.dart';
import '../models/progress/food_diary_model.dart';
import '../models/progress/progress_photos_model.dart';
import '../models/progress/weekly_checkin_model.dart';
import '../network/base/base_repository.dart';
import '../network/enums/request_type.dart';
import '../network/models/api_response.dart';

class ProgressRepo extends BaseRepository {
  Future<ApiResponse<dynamic>> saveWeeklyCheckins({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    final response = await networkService.request(
      requestType: RequestType.post,
      url: url,
      body: body,
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
      appLog(name: "ProgressRepo saveWeeklyCheckins Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

  Future<ApiResponse<dynamic>> uploadProgressPhotos({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    final response = await networkService.request(
      requestType: RequestType.post,
      url: url,
      body: body,
      isMultipart: true,
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
      appLog(name: "ProgressRepo uploadProgressPhotos Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

  Future<ApiResponse<dynamic>> saveFoodDiary({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    final response = await networkService.request(
      requestType: RequestType.post,
      url: url,
      body: body,
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
      appLog(name: "ProgressRepo saveFoodDiary Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

  Future<ApiResponse<dynamic>> getWeeklyCheckin({required String url}) async {
    final response = await networkService.request(
      requestType: RequestType.get,
      url: url,
    );

    if (response.data == null) {
      return ApiResponse.failure(message: response.message);
    }

    try {
      WeeklyCheckinModel model = WeeklyCheckinModel.fromJson(response.data);

      if (model.success == true) {
        return ApiResponse.success(data: model, message: model.message ?? "");
      } else {
        return ApiResponse.failure(message: model.message ?? "");
      }
    } catch (e) {
      appLog(name: "ProgressRepo getWeeklyCheckin Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

  Future<ApiResponse<dynamic>> getProgressPhotos({required String url}) async {
    final response = await networkService.request(
      requestType: RequestType.get,
      url: url,
    );

    if (response.data == null) {
      return ApiResponse.failure(message: response.message);
    }

    try {
      ProgressPhotosModel model = ProgressPhotosModel.fromJson(response.data);

      if (model.success == true) {
        return ApiResponse.success(data: model, message: model.message ?? "");
      } else {
        return ApiResponse.failure(message: model.message ?? "");
      }
    } catch (e) {
      appLog(name: "ProgressRepo getProgressPhotos Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

  Future<ApiResponse<dynamic>> getFoodDiary({required String url}) async {
    final response = await networkService.request(
      requestType: RequestType.get,
      url: url,
    );

    if (response.data == null) {
      return ApiResponse.failure(message: response.message);
    }

    try {
      FoodDiaryModel model = FoodDiaryModel.fromJson(response.data);

      if (model.success == true) {
        return ApiResponse.success(data: model, message: model.message ?? "");
      } else {
        return ApiResponse.failure(message: model.message ?? "");
      }
    } catch (e) {
      appLog(name: "ProgressRepo getFoodDiary Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }
}
