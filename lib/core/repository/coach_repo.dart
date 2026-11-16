import '../../main.dart';
import '../models/coach/fat_loss_inch_loss_model.dart';
import '../models/coach/gut_reset_model.dart';
import '../models/coach/healthy_weight_gain_model.dart';
import '../models/coach/maintenance_lifestyle_model.dart';
import '../models/coach/reproductive_life_stage_model.dart';
import '../models/coach/rooted_recovery_new_moms_model.dart';
import '../models/coach/pathways_model.dart';
import '../models/common_model.dart';
import '../network/base/base_repository.dart';
import '../network/enums/request_type.dart';
import '../network/models/api_response.dart';

class CoachRepo extends BaseRepository {
  Future<ApiResponse<dynamic>> getPathways({
    required String url,
  }) async {
    final response = await networkService.request(
      requestType: RequestType.get,
      url: url,
    );

    if (response.data == null) {
      return ApiResponse.failure(message: response.message);
    }

    try {
      PathwaysModel model = PathwaysModel.fromJson(response.data);

      if (model.success == true) {
        return ApiResponse.success(data: model, message: model.message ?? "");
      } else {
        return ApiResponse.failure(message: model.message ?? "");
      }
    } catch (e) {
      appLog(name: "CoachRepo getPathways Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

  Future<ApiResponse<dynamic>> getGutReset({
    required String url,
  }) async {
    final response = await networkService.request(
      requestType: RequestType.get,
      url: url,
    );

    if (response.data == null) {
      return ApiResponse.failure(message: response.message);
    }

    try {
      GutResetModel model = GutResetModel.fromJson(response.data);

      if (model.success == true) {
        return ApiResponse.success(data: model, message: model.message ?? "");
      } else {
        return ApiResponse.failure(message: model.message ?? "");
      }
    } catch (e) {
      appLog(name: "CoachRepo getGutReset Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

  Future<ApiResponse<dynamic>> getFatLossInchLoss({
    required String url,
  }) async {
    final response = await networkService.request(
      requestType: RequestType.get,
      url: url,
    );

    if (response.data == null) {
      return ApiResponse.failure(message: response.message);
    }

    try {
      FatLossInchLossModel model = FatLossInchLossModel.fromJson(response.data);

      if (model.success == true) {
        return ApiResponse.success(data: model, message: model.message ?? "");
      } else {
        return ApiResponse.failure(message: model.message ?? "");
      }
    } catch (e) {
      appLog(name: "CoachRepo getFatLossInchLoss Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

  Future<ApiResponse<dynamic>> getHealthyWeightGain({
    required String url,
  }) async {
    final response = await networkService.request(
      requestType: RequestType.get,
      url: url,
    );

    if (response.data == null) {
      return ApiResponse.failure(message: response.message);
    }

    try {
      HealthyWeightGainModel model = HealthyWeightGainModel.fromJson(response.data);

      if (model.success == true) {
        return ApiResponse.success(data: model, message: model.message ?? "");
      } else {
        return ApiResponse.failure(message: model.message ?? "");
      }
    } catch (e) {
      appLog(name: "CoachRepo getHealthyWeightGain Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

  Future<ApiResponse<dynamic>> getRootedRecoveryNewMoms({
    required String url,
  }) async {
    final response = await networkService.request(
      requestType: RequestType.get,
      url: url,
    );

    if (response.data == null) {
      return ApiResponse.failure(message: response.message);
    }

    try {
      RootedRecoveryNewMomsModel model = RootedRecoveryNewMomsModel.fromJson(response.data);

      if (model.success == true) {
        return ApiResponse.success(data: model, message: model.message ?? "");
      } else {
        return ApiResponse.failure(message: model.message ?? "");
      }
    } catch (e) {
      appLog(name: "CoachRepo getRootedRecoveryNewMoms Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

  Future<ApiResponse<dynamic>> getMaintenanceLifestyle({
    required String url,
  }) async {
    final response = await networkService.request(
      requestType: RequestType.get,
      url: url,
    );

    if (response.data == null) {
      return ApiResponse.failure(message: response.message);
    }

    try {
      MaintenanceLifestyleModel model = MaintenanceLifestyleModel.fromJson(response.data);

      if (model.success == true) {
        return ApiResponse.success(data: model, message: model.message ?? "");
      } else {
        return ApiResponse.failure(message: model.message ?? "");
      }
    } catch (e) {
      appLog(name: "CoachRepo getMaintenanceLifestyle Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

  Future<ApiResponse<dynamic>> getReproductiveLifeStage({
    required String url,
  }) async {
    final response = await networkService.request(
      requestType: RequestType.get,
      url: url,
    );

    if (response.data == null) {
      return ApiResponse.failure(message: response.message);
    }

    try {
      ReproductiveLifeStageModel model = ReproductiveLifeStageModel.fromJson(response.data);

      if (model.success == true) {
        return ApiResponse.success(data: model, message: model.message ?? "");
      } else {
        return ApiResponse.failure(message: model.message ?? "");
      }
    } catch (e) {
      appLog(name: "CoachRepo getReproductiveLifeStage Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

  Future<ApiResponse<dynamic>> saveProtocolForm({
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
      appLog(name: "CoachRepo saveProtocolForm Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }
}



