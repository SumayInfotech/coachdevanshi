import 'pathways_model.dart';

class FatLossInchLossModel {
  bool? success;
  String? message;
  FatLossInchLossData? data;

  FatLossInchLossModel({this.success, this.message, this.data});

  FatLossInchLossModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? FatLossInchLossData.fromJson(json['data']) : null;
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

class FatLossInchLossData {
  PathwayItem? pathway;
  String? title;
  String? status;
  String? submittedAt;
  List<FatLossInchLossFormField>? fields;
  FatLossInchLossAnswers? answers;

  FatLossInchLossData({
    this.pathway,
    this.title,
    this.status,
    this.submittedAt,
    this.fields,
    this.answers,
  });

  FatLossInchLossData.fromJson(Map<String, dynamic> json) {
    pathway = json['pathway'] != null ? PathwayItem.fromJson(json['pathway']) : null;
    title = json['title'];
    status = json['status'];
    submittedAt = json['submitted_at'];
    if (json['fields'] != null) {
      fields = <FatLossInchLossFormField>[];
      json['fields'].forEach((v) {
        fields!.add(FatLossInchLossFormField.fromJson(v));
      });
    }
    answers = json['answers'] != null ? FatLossInchLossAnswers.fromJson(json['answers']) : null;
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

class FatLossInchLossAnswers {
  String? weightUnit;
  num? highestWeight;
  int? highestWeightYear;
  num? lowestWeight;
  int? lowestWeightYear;
  String? majorWeightPeriods;
  String? pastTransitions;
  HabitReadinessAnswers? habitReadiness;
  String? maintenanceSupport;

  FatLossInchLossAnswers({
    this.weightUnit,
    this.highestWeight,
    this.highestWeightYear,
    this.lowestWeight,
    this.lowestWeightYear,
    this.majorWeightPeriods,
    this.pastTransitions,
    this.habitReadiness,
    this.maintenanceSupport,
  });

  FatLossInchLossAnswers.fromJson(Map<String, dynamic> json) {
    weightUnit = json['weight_unit']?.toString();
    highestWeight = num.tryParse(json['highest_weight']?.toString() ?? '');
    highestWeightYear = int.tryParse(json['highest_weight_year']?.toString() ?? '');
    lowestWeight = num.tryParse(json['lowest_weight']?.toString() ?? '');
    lowestWeightYear = int.tryParse(json['lowest_weight_year']?.toString() ?? '');
    majorWeightPeriods = json['major_weight_periods']?.toString();
    pastTransitions = json['past_transitions']?.toString();
    habitReadiness = json['habit_readiness'] != null
        ? HabitReadinessAnswers.fromJson(json['habit_readiness'])
        : null;
    maintenanceSupport = json['maintenance_support']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (weightUnit != null) {
      data['weight_unit'] = weightUnit;
    }
    if (highestWeight != null) {
      data['highest_weight'] = highestWeight;
    }
    if (highestWeightYear != null) {
      data['highest_weight_year'] = highestWeightYear;
    }
    if (lowestWeight != null) {
      data['lowest_weight'] = lowestWeight;
    }
    if (lowestWeightYear != null) {
      data['lowest_weight_year'] = lowestWeightYear;
    }
    if (majorWeightPeriods != null) {
      data['major_weight_periods'] = majorWeightPeriods;
    }
    if (pastTransitions != null) {
      data['past_transitions'] = pastTransitions;
    }
    if (habitReadiness != null) {
      data['habit_readiness'] = habitReadiness!.toJson();
    }
    if (maintenanceSupport != null) {
      data['maintenance_support'] = maintenanceSupport;
    }
    return data;
  }
}

class HabitReadinessAnswers {
  String? eatingOut;
  String? lateNightEating;
  String? sweets;
  String? packagedFoods;
  String? alcohol;
  String? skippingMeals;

  HabitReadinessAnswers({
    this.eatingOut,
    this.lateNightEating,
    this.sweets,
    this.packagedFoods,
    this.alcohol,
    this.skippingMeals,
  });

  HabitReadinessAnswers.fromJson(Map<String, dynamic> json) {
    eatingOut = json['eating_out']?.toString();
    lateNightEating = json['late_night_eating']?.toString();
    sweets = json['sweets']?.toString();
    packagedFoods = json['packaged_foods']?.toString();
    alcohol = json['alcohol']?.toString();
    skippingMeals = json['skipping_meals']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (eatingOut != null) {
      data['eating_out'] = eatingOut;
    }
    if (lateNightEating != null) {
      data['late_night_eating'] = lateNightEating;
    }
    if (sweets != null) {
      data['sweets'] = sweets;
    }
    if (packagedFoods != null) {
      data['packaged_foods'] = packagedFoods;
    }
    if (alcohol != null) {
      data['alcohol'] = alcohol;
    }
    if (skippingMeals != null) {
      data['skipping_meals'] = skippingMeals;
    }
    return data;
  }
}

class FatLossInchLossFormField {
  String? key;
  String? label;
  String? type;
  bool? required;
  num? min;
  num? max;
  List<FatLossInchLossOption>? options;
  List<FatLossInchLossFormField>? fields;

  FatLossInchLossFormField({
    this.key,
    this.label,
    this.type,
    this.required,
    this.min,
    this.max,
    this.options,
    this.fields,
  });

  FatLossInchLossFormField.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    label = json['label'];
    type = json['type'];
    required = json['required'];
    min = json['min'];
    max = json['max'];
    if (json['options'] != null) {
      options = <FatLossInchLossOption>[];
      json['options'].forEach((v) {
        options!.add(FatLossInchLossOption.fromJson(v));
      });
    }
    if (json['fields'] != null) {
      fields = <FatLossInchLossFormField>[];
      json['fields'].forEach((v) {
        fields!.add(FatLossInchLossFormField.fromJson(v));
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
    if (fields != null) {
      data['fields'] = fields!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FatLossInchLossOption {
  String? value;
  String? label;

  FatLossInchLossOption({this.value, this.label});

  FatLossInchLossOption.fromJson(Map<String, dynamic> json) {
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
