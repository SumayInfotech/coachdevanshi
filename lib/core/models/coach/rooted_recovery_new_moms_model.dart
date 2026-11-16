import 'pathways_model.dart';

class RootedRecoveryNewMomsModel {
  bool? success;
  String? message;
  RootedRecoveryNewMomsData? data;

  RootedRecoveryNewMomsModel({this.success, this.message, this.data});

  RootedRecoveryNewMomsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? RootedRecoveryNewMomsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class RootedRecoveryNewMomsData {
  PathwayItem? pathway;
  String? title;
  String? status;
  String? submittedAt;
  List<RootedRecoveryNewMomsFormField>? fields;
  RootedRecoveryNewMomsAnswers? answers;

  RootedRecoveryNewMomsData({
    this.pathway,
    this.title,
    this.status,
    this.submittedAt,
    this.fields,
    this.answers,
  });

  RootedRecoveryNewMomsData.fromJson(Map<String, dynamic> json) {
    pathway = json['pathway'] != null ? PathwayItem.fromJson(json['pathway']) : null;
    title = json['title'];
    status = json['status'];
    submittedAt = json['submitted_at'];
    if (json['fields'] != null) {
      fields = <RootedRecoveryNewMomsFormField>[];
      json['fields'].forEach((v) {
        fields!.add(RootedRecoveryNewMomsFormField.fromJson(v));
      });
    }
    answers = json['answers'] != null ? RootedRecoveryNewMomsAnswers.fromJson(json['answers']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pathway != null) {
      data['pathway'] = pathway!.toJson();
    }
    data['title'] = title;
    data['status'] = status;
    data['submitted_at'] = submittedAt;
    if (fields != null) {
      data['fields'] = fields!.map((v) => v.toJson()).toList();
    }
    if (answers != null) {
      data['answers'] = answers!.toJson();
    }
    return data;
  }
}

class RootedRecoveryNewMomsAnswers {
  String? deliveryDate;
  String? deliveryType;
  String? feedingStatus;
  bool? hasComplications;
  String? complicationDetails;
  String? exerciseClearance;
  List<String>? postpartumSensations;
  String? longestSleepStretch;
  String? caregivingSupport;
  List<String>? topPriorities;
  String? otherPriority;

  RootedRecoveryNewMomsAnswers({
    this.deliveryDate,
    this.deliveryType,
    this.feedingStatus,
    this.hasComplications,
    this.complicationDetails,
    this.exerciseClearance,
    this.postpartumSensations,
    this.longestSleepStretch,
    this.caregivingSupport,
    this.topPriorities,
    this.otherPriority,
  });

  RootedRecoveryNewMomsAnswers.fromJson(Map<String, dynamic> json) {
    deliveryDate = json['delivery_date']?.toString();
    deliveryType = json['delivery_type']?.toString();
    feedingStatus = json['feeding_status']?.toString();
    if (json['has_complications'] != null) {
      if (json['has_complications'] is bool) {
        hasComplications = json['has_complications'];
      } else {
        hasComplications = json['has_complications'].toString() == 'true' || json['has_complications'].toString() == '1';
      }
    }
    complicationDetails = json['complication_details']?.toString();
    exerciseClearance = json['exercise_clearance']?.toString();
    if (json['postpartum_sensations'] != null && json['postpartum_sensations'] is List) {
      postpartumSensations = (json['postpartum_sensations'] as List).map((e) => e.toString()).toList();
    }
    longestSleepStretch = json['longest_sleep_stretch']?.toString();
    caregivingSupport = json['caregiving_support']?.toString();
    if (json['top_priorities'] != null && json['top_priorities'] is List) {
      topPriorities = (json['top_priorities'] as List).map((e) => e.toString()).toList();
    }
    otherPriority = json['other_priority']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (deliveryDate != null) {
      data['delivery_date'] = deliveryDate;
    }
    if (deliveryType != null) {
      data['delivery_type'] = deliveryType;
    }
    if (feedingStatus != null) {
      data['feeding_status'] = feedingStatus;
    }
    if (hasComplications != null) {
      data['has_complications'] = hasComplications;
    }
    if (complicationDetails != null) {
      data['complication_details'] = complicationDetails;
    }
    if (exerciseClearance != null) {
      data['exercise_clearance'] = exerciseClearance;
    }
    if (postpartumSensations != null) {
      data['postpartum_sensations'] = postpartumSensations;
    }
    if (longestSleepStretch != null) {
      data['longest_sleep_stretch'] = longestSleepStretch;
    }
    if (caregivingSupport != null) {
      data['caregiving_support'] = caregivingSupport;
    }
    if (topPriorities != null) {
      data['top_priorities'] = topPriorities;
    }
    if (otherPriority != null) {
      data['other_priority'] = otherPriority;
    }
    return data;
  }
}

class RootedRecoveryNewMomsFormField {
  String? key;
  String? label;
  String? type;
  bool? required;
  int? max;
  List<RootedRecoveryNewMomsOption>? options;
  RequiredIf? requiredIf;

  RootedRecoveryNewMomsFormField({
    this.key,
    this.label,
    this.type,
    this.required,
    this.max,
    this.options,
    this.requiredIf,
  });

  RootedRecoveryNewMomsFormField.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    label = json['label'];
    type = json['type'];
    required = json['required'];
    max = json['max'];
    if (json['options'] != null) {
      options = <RootedRecoveryNewMomsOption>[];
      json['options'].forEach((v) {
        options!.add(RootedRecoveryNewMomsOption.fromJson(v));
      });
    }
    requiredIf = json['required_if'] != null ? RequiredIf.fromJson(json['required_if']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['label'] = label;
    data['type'] = type;
    data['required'] = required;
    data['max'] = max;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    if (requiredIf != null) {
      data['required_if'] = requiredIf!.toJson();
    }
    return data;
  }
}

class RootedRecoveryNewMomsOption {
  String? value;
  String? label;

  RootedRecoveryNewMomsOption({this.value, this.label});

  RootedRecoveryNewMomsOption.fromJson(Map<String, dynamic> json) {
    value = json['value']?.toString();
    label = json['label']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['label'] = label;
    return data;
  }
}

class RequiredIf {
  String? field;
  dynamic value;

  RequiredIf({this.field, this.value});

  RequiredIf.fromJson(Map<String, dynamic> json) {
    field = json['field'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['field'] = field;
    data['value'] = value;
    return data;
  }
}
