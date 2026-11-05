import 'package:coach_devanshi_doshi/core/models/common_model.dart';

import '../../main.dart';

import '../models/profile/location_model.dart';

import '../models/profile/chapter_one_model.dart';
import '../models/profile/chapter_two_model.dart';
import '../models/profile/chapter_three_model.dart';
import '../models/profile/chapter_four_model.dart';
import '../models/profile/chapter_five_model.dart';
import '../models/profile/chapter_six_model.dart';
import '../models/profile/onboarding_master_status_model.dart';
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

  Future<ApiResponse<dynamic>> onboardingMastersStatus ({
    required String url,
  }) async {
    final response = await networkService.request(url: url, requestType: RequestType.get);

    if (response.data == null) {
      return ApiResponse.failure(message: response.message);
    }

    try {
      /// Convert JSON -> Model
      OnboardingMasterStatusModel model = OnboardingMasterStatusModel.fromJson(response.data);

      if (model.success == true) {
        return ApiResponse.success(data: model, message: model.message ?? "");
      } else {
        return ApiResponse.failure(message: model.message ?? "");
      }
    } catch (e) {
      appLog(name: "ProfileRepo onboardingMastersStatus Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

  Future<ApiResponse<dynamic>> chaptersOne ({
    required String url,
  }) async {
    final response = await networkService.request(url: url, requestType: RequestType.get);

    if (response.data == null) {
      return ApiResponse.failure(message: response.message);
    }

    try {
      /// Convert JSON -> Model
      ChapterOneModel model = ChapterOneModel.fromJson(response.data);

      if (model.success == true) {
        return ApiResponse.success(data: model, message: model.message ?? "");
      } else {
        return ApiResponse.failure(message: model.message ?? "");
      }
    } catch (e) {
      appLog(name: "ProfileRepo chaptersOne Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

  Future<ApiResponse<dynamic>> chaptersTwo ({
    required String url,
  }) async {
    final response = await networkService.request(url: url, requestType: RequestType.get);

    if (response.data == null) {
      return ApiResponse.failure(message: response.message);
    }

    try {
      /// Convert JSON -> Model
      ChapterTwoModel model = ChapterTwoModel.fromJson(response.data);

      if (model.success == true) {
        return ApiResponse.success(data: model, message: model.message ?? "");
      } else {
        return ApiResponse.failure(message: model.message ?? "");
      }
    } catch (e) {
      appLog(name: "ProfileRepo chaptersTwo Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

  Future<ApiResponse<dynamic>> chaptersThree ({
    required String url,
  }) async {
    final response = await networkService.request(url: url, requestType: RequestType.get);

    if (response.data == null) {
      return ApiResponse.failure(message: response.message);
    }

    try {
      /// Convert JSON -> Model
      ChapterThreeModel model = ChapterThreeModel.fromJson(response.data);

      if (model.success == true) {
        return ApiResponse.success(data: model, message: model.message ?? "");
      } else {
        return ApiResponse.failure(message: model.message ?? "");
      }
    } catch (e) {
      appLog(name: "ProfileRepo chaptersThree Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

  Future<ApiResponse<dynamic>> chaptersFour ({
    required String url,
  }) async {
    final response = await networkService.request(url: url, requestType: RequestType.get);

    if (response.data == null) {
      return ApiResponse.failure(message: response.message);
    }

    try {
      /// Convert JSON -> Model
      ChapterFourModel model = ChapterFourModel.fromJson(response.data);

      if (model.success == true) {
        return ApiResponse.success(data: model, message: model.message ?? "");
      } else {
        return ApiResponse.failure(message: model.message ?? "");
      }
    } catch (e) {
      appLog(name: "ProfileRepo chaptersFour Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

  Future<ApiResponse<dynamic>> chaptersFive ({
    required String url,
  }) async {
    final response = await networkService.request(url: url, requestType: RequestType.get);

    if (response.data == null) {
      return ApiResponse.failure(message: response.message);
    }

    try {
      /// Convert JSON -> Model
      ChapterFiveModel model = ChapterFiveModel.fromJson(response.data);

      if (model.success == true) {
        return ApiResponse.success(data: model, message: model.message ?? "");
      } else {
        return ApiResponse.failure(message: model.message ?? "");
      }
    } catch (e) {
      appLog(name: "ProfileRepo chaptersFive Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

  Future<ApiResponse<dynamic>> chaptersSix ({
    required String url,
  }) async {
    final response = await networkService.request(url: url, requestType: RequestType.get);

    if (response.data == null) {
      return ApiResponse.failure(message: response.message);
    }

    try {
      /// Convert JSON -> Model
      ChapterSixModel model = ChapterSixModel.fromJson(response.data);

      if (model.success == true) {
        return ApiResponse.success(data: model, message: model.message ?? "");
      } else {
        return ApiResponse.failure(message: model.message ?? "");
      }
    } catch (e) {
      appLog(name: "ProfileRepo chaptersSix Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

  Future<ApiResponse<dynamic>> saveChaptersOne ({
    required String url, required Map<String, dynamic> body
  }) async {
    final response = await networkService.request(requestType: RequestType.post, url: url, body: body);

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
      appLog(name: "ProfileRepo saveChaptersOne Exception", e.toString());
      return ApiResponse.failure(message: e.toString());
    }
  }

}