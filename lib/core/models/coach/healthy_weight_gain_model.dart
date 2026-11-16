import 'pathways_model.dart';

class HealthyWeightGainModel {
  bool? success;
  String? message;
  HealthyWeightGainData? data;

  HealthyWeightGainModel({this.success, this.message, this.data});

  HealthyWeightGainModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? HealthyWeightGainData.fromJson(json['data']) : null;
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

class HealthyWeightGainData {
  PathwayItem? pathway;
  String? title;
  String? status;
  String? submittedAt;
  List<HealthyWeightGainFormField>? fields;
  HealthyWeightGainAnswers? answers;

  HealthyWeightGainData({
    this.pathway,
    this.title,
    this.status,
    this.submittedAt,
    this.fields,
    this.answers,
  });

  HealthyWeightGainData.fromJson(Map<String, dynamic> json) {
    pathway = json['pathway'] != null ? PathwayItem.fromJson(json['pathway']) : null;
    title = json['title'];
    status = json['status'];
    submittedAt = json['submitted_at'];
    if (json['fields'] != null) {
      fields = <HealthyWeightGainFormField>[];
      json['fields'].forEach((v) {
        fields!.add(HealthyWeightGainFormField.fromJson(v));
      });
    }
    answers = json['answers'] != null ? HealthyWeightGainAnswers.fromJson(json['answers']) : null;
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

class HealthyWeightGainAnswers {
  String? weightLossIntentional;
  String? weightUnit;
  num? startingWeight6m;
  num? currentWeight;
  String? trajectoryNature;
  List<String>? appetiteSensations;
  List<String>? weightGainGoals;
  String? otherGoals;

  HealthyWeightGainAnswers({
    this.weightLossIntentional,
    this.weightUnit,
    this.startingWeight6m,
    this.currentWeight,
    this.trajectoryNature,
    this.appetiteSensations,
    this.weightGainGoals,
    this.otherGoals,
  });

  HealthyWeightGainAnswers.fromJson(Map<String, dynamic> json) {
    weightLossIntentional = json['weight_loss_intentional']?.toString();
    weightUnit = json['weight_unit']?.toString();
    startingWeight6m = num.tryParse(json['starting_weight_6m']?.toString() ?? '');
    currentWeight = num.tryParse(json['current_weight']?.toString() ?? '');
    trajectoryNature = json['trajectory_nature']?.toString();
    if (json['appetite_sensations'] != null && json['appetite_sensations'] is List) {
      appetiteSensations = (json['appetite_sensations'] as List).map((e) => e.toString()).toList();
    }
    if (json['weight_gain_goals'] != null && json['weight_gain_goals'] is List) {
      weightGainGoals = (json['weight_gain_goals'] as List).map((e) => e.toString()).toList();
    }
    otherGoals = json['other_goals']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (weightLossIntentional != null) {
      data['weight_loss_intentional'] = weightLossIntentional;
    }
    if (weightUnit != null) {
      data['weight_unit'] = weightUnit;
    }
    if (startingWeight6m != null) {
      data['starting_weight_6m'] = startingWeight6m;
    }
    if (currentWeight != null) {
      data['current_weight'] = currentWeight;
    }
    if (trajectoryNature != null) {
      data['trajectory_nature'] = trajectoryNature;
    }
    if (appetiteSensations != null) {
      data['appetite_sensations'] = appetiteSensations;
    }
    if (weightGainGoals != null) {
      data['weight_gain_goals'] = weightGainGoals;
    }
    if (otherGoals != null) {
      data['other_goals'] = otherGoals;
    }
    return data;
  }
}

class HealthyWeightGainFormField {
  String? key;
  String? label;
  String? type;
  bool? required;
  num? min;
  num? max;
  List<HealthyWeightGainOption>? options;

  HealthyWeightGainFormField({
    this.key,
    this.label,
    this.type,
    this.required,
    this.min,
    this.max,
    this.options,
  });

  HealthyWeightGainFormField.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    label = json['label'];
    type = json['type'];
    required = json['required'];
    min = json['min'];
    max = json['max'];
    if (json['options'] != null) {
      options = <HealthyWeightGainOption>[];
      json['options'].forEach((v) {
        options!.add(HealthyWeightGainOption.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['label'] = label;
    data['type'] = type;
    data['required'] = required;
    data['min'] = min;
    data['max'] = max;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HealthyWeightGainOption {
  String? value;
  String? label;

  HealthyWeightGainOption({this.value, this.label});

  HealthyWeightGainOption.fromJson(Map<String, dynamic> json) {
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
