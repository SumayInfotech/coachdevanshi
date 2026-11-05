import '../../main.dart';
import '../models/common_model.dart';
import '../models/home/daily_checkin_model.dart';
import '../models/home/dashboard_model.dart';
import '../network/base/base_repository.dart';
import '../network/enums/request_type.dart';
import '../network/models/api_response.dart';

class HomeRepo extends BaseRepository {
  Future<ApiResponse<dynamic>> getDashboard({required String url}) async {
    final response = await networkService.request(url: url, requestType: RequestType.get);

    if (response.data == null) {
      return ApiResponse.failure(message: response.message);
    }

    try {
      DashboardModel model = DashboardModel.fromJson(response.data);

      if (model.success == true) {
        return ApiResponse.success(data: model, message: model.message ?? "");
      } else {
        return ApiResponse.failure(message: model.message ?? "");
      }
    } catch (e) {
      appLog(name: "HomeRepo getDashboard Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

  Future<ApiResponse<dynamic>> getDailyCheckin({required String url}) async {
    final response = await networkService.request(url: url, requestType: RequestType.get);

    if (response.data == null) {
      return ApiResponse.failure(message: response.message);
    }

    try {
      DailyCheckinModel model = DailyCheckinModel.fromJson(response.data);

      if (model.success == true) {
        return ApiResponse.success(data: model, message: model.message ?? "");
      } else {
        return ApiResponse.failure(message: model.message ?? "");
      }
    } catch (e) {
      appLog(name: "HomeRepo getDailyCheckin Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

  Future<ApiResponse<dynamic>> saveDailyCheckins({
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
      appLog(name: "HomeRepo saveDailyCheckins Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }
}
