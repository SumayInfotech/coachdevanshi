import 'pathways_model.dart';

class MaintenanceLifestyleModel {
  bool? success;
  String? message;
  MaintenanceLifestyleData? data;

  MaintenanceLifestyleModel({this.success, this.message, this.data});

  MaintenanceLifestyleModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? MaintenanceLifestyleData.fromJson(json['data']) : null;
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

class MaintenanceLifestyleData {
  PathwayItem? pathway;
  String? title;
  String? status;
  String? submittedAt;
  List<MaintenanceLifestyleFormField>? fields;
  MaintenanceLifestyleAnswers? answers;

  MaintenanceLifestyleData({
    this.pathway,
    this.title,
    this.status,
    this.submittedAt,
    this.fields,
    this.answers,
  });

  MaintenanceLifestyleData.fromJson(Map<String, dynamic> json) {
    pathway = json['pathway'] != null ? PathwayItem.fromJson(json['pathway']) : null;
    title = json['title'];
    status = json['status'];
    submittedAt = json['submitted_at'];
    if (json['fields'] != null) {
      fields = <MaintenanceLifestyleFormField>[];
      json['fields'].forEach((v) {
        fields!.add(MaintenanceLifestyleFormField.fromJson(v));
      });
    }
    answers = json['answers'] != null ? MaintenanceLifestyleAnswers.fromJson(json['answers']) : null;
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

class MaintenanceLifestyleAnswers {
  String? achievedMilestones;
  String? sustainableEquilibrium;
  List<String>? maintenanceDisruptions;
  String? otherDisruption;
  String? coachingPartnership;

  MaintenanceLifestyleAnswers({
    this.achievedMilestones,
    this.sustainableEquilibrium,
    this.maintenanceDisruptions,
    this.otherDisruption,
    this.coachingPartnership,
  });

  MaintenanceLifestyleAnswers.fromJson(Map<String, dynamic> json) {
    achievedMilestones = json['achieved_milestones']?.toString();
    sustainableEquilibrium = json['sustainable_equilibrium']?.toString();
    if (json['maintenance_disruptions'] != null && json['maintenance_disruptions'] is List) {
      maintenanceDisruptions = (json['maintenance_disruptions'] as List).map((e) => e.toString()).toList();
    }
    otherDisruption = json['other_disruption']?.toString();
    coachingPartnership = json['coaching_partnership']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (achievedMilestones != null) {
      data['achieved_milestones'] = achievedMilestones;
    }
    if (sustainableEquilibrium != null) {
      data['sustainable_equilibrium'] = sustainableEquilibrium;
    }
    if (maintenanceDisruptions != null) {
      data['maintenance_disruptions'] = maintenanceDisruptions;
    }
    if (otherDisruption != null) {
      data['other_disruption'] = otherDisruption;
    }
    if (coachingPartnership != null) {
      data['coaching_partnership'] = coachingPartnership;
    }
    return data;
  }
}

class MaintenanceLifestyleFormField {
  String? key;
  String? label;
  String? type;
  bool? required;
  int? max;
  List<MaintenanceLifestyleOption>? options;

  MaintenanceLifestyleFormField({
    this.key,
    this.label,
    this.type,
    this.required,
    this.max,
    this.options,
  });

  MaintenanceLifestyleFormField.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    label = json['label'];
    type = json['type'];
    required = json['required'];
    max = json['max'];
    if (json['options'] != null) {
      options = <MaintenanceLifestyleOption>[];
      json['options'].forEach((v) {
        options!.add(MaintenanceLifestyleOption.fromJson(v));
      });
    }
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
    return data;
  }
}

class MaintenanceLifestyleOption {
  String? value;
  String? label;

  MaintenanceLifestyleOption({this.value, this.label});

  MaintenanceLifestyleOption.fromJson(Map<String, dynamic> json) {
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
