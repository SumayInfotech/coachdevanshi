import 'pathways_model.dart';

class ReproductiveLifeStageModel {
  bool? success;
  String? message;
  ReproductiveLifeStageData? data;

  ReproductiveLifeStageModel({this.success, this.message, this.data});

  ReproductiveLifeStageModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? ReproductiveLifeStageData.fromJson(json['data']) : null;
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

class ReproductiveLifeStageData {
  PathwayItem? pathway;
  String? title;
  String? status;
  String? submittedAt;
  List<ReproductiveLifeStageFormField>? fields;
  ReproductiveLifeStageAnswers? answers;

  ReproductiveLifeStageData({
    this.pathway,
    this.title,
    this.status,
    this.submittedAt,
    this.fields,
    this.answers,
  });

  ReproductiveLifeStageData.fromJson(Map<String, dynamic> json) {
    pathway = json['pathway'] != null ? PathwayItem.fromJson(json['pathway']) : null;
    title = json['title'];
    status = json['status'];
    submittedAt = json['submitted_at'];
    if (json['fields'] != null) {
      fields = <ReproductiveLifeStageFormField>[];
      json['fields'].forEach((v) {
        fields!.add(ReproductiveLifeStageFormField.fromJson(v));
      });
    }
    answers = json['answers'] != null ? ReproductiveLifeStageAnswers.fromJson(json['answers']) : null;
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

class ReproductiveLifeStageAnswers {
  String? avgCycleLength;
  bool? cycleLengthNotSure;
  String? bleedingDuration;
  String? cycleRegularity;
  List<String>? cyclicalMarkers;
  bool? underGynaeCare;
  String? attendingClinician;
  bool? hasDoctorGuidance;
  String? doctorGuidanceDetails;
  String? conceptionStatus;
  String? estimatedDueDate;
  String? gestationalWeek;
  String? lastMenstrualPeriod;
  bool? lmpNotSure;
  List<String>? menopauseChanges;
  String? otherCyclicalNotes;

  ReproductiveLifeStageAnswers({
    this.avgCycleLength,
    this.cycleLengthNotSure,
    this.bleedingDuration,
    this.cycleRegularity,
    this.cyclicalMarkers,
    this.underGynaeCare,
    this.attendingClinician,
    this.hasDoctorGuidance,
    this.doctorGuidanceDetails,
    this.conceptionStatus,
    this.estimatedDueDate,
    this.gestationalWeek,
    this.lastMenstrualPeriod,
    this.lmpNotSure,
    this.menopauseChanges,
    this.otherCyclicalNotes,
  });

  ReproductiveLifeStageAnswers.fromJson(Map<String, dynamic> json) {
    avgCycleLength = json['avg_cycle_length']?.toString();
    cycleLengthNotSure = _parseBool(json['cycle_length_not_sure']);
    bleedingDuration = json['bleeding_duration']?.toString();
    cycleRegularity = json['cycle_regularity']?.toString();
    if (json['cyclical_markers'] != null && json['cyclical_markers'] is List) {
      cyclicalMarkers = (json['cyclical_markers'] as List).map((e) => e.toString()).toList();
    }
    underGynaeCare = _parseBool(json['under_gynae_care']);
    attendingClinician = json['attending_clinician']?.toString();
    hasDoctorGuidance = _parseBool(json['has_doctor_guidance']);
    doctorGuidanceDetails = json['doctor_guidance_details']?.toString();
    conceptionStatus = json['conception_status']?.toString();
    estimatedDueDate = json['estimated_due_date']?.toString();
    gestationalWeek = json['gestational_week']?.toString();
    lastMenstrualPeriod = json['last_menstrual_period']?.toString();
    lmpNotSure = _parseBool(json['lmp_not_sure']);
    if (json['menopause_changes'] != null && json['menopause_changes'] is List) {
      menopauseChanges = (json['menopause_changes'] as List).map((e) => e.toString()).toList();
    }
    otherCyclicalNotes = json['other_cyclical_notes']?.toString();
  }

  static bool? _parseBool(dynamic val) {
    if (val == null) return null;
    if (val is bool) return val;
    return val.toString() == 'true' || val.toString() == '1';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (avgCycleLength != null) data['avg_cycle_length'] = avgCycleLength;
    if (cycleLengthNotSure != null) data['cycle_length_not_sure'] = cycleLengthNotSure;
    if (bleedingDuration != null) data['bleeding_duration'] = bleedingDuration;
    if (cycleRegularity != null) data['cycle_regularity'] = cycleRegularity;
    if (cyclicalMarkers != null) data['cyclical_markers'] = cyclicalMarkers;
    if (underGynaeCare != null) data['under_gynae_care'] = underGynaeCare;
    if (attendingClinician != null) data['attending_clinician'] = attendingClinician;
    if (hasDoctorGuidance != null) data['has_doctor_guidance'] = hasDoctorGuidance;
    if (doctorGuidanceDetails != null) data['doctor_guidance_details'] = doctorGuidanceDetails;
    if (conceptionStatus != null) data['conception_status'] = conceptionStatus;
    if (estimatedDueDate != null) data['estimated_due_date'] = estimatedDueDate;
    if (gestationalWeek != null) data['gestational_week'] = gestationalWeek;
    if (lastMenstrualPeriod != null) data['last_menstrual_period'] = lastMenstrualPeriod;
    if (lmpNotSure != null) data['lmp_not_sure'] = lmpNotSure;
    if (menopauseChanges != null) data['menopause_changes'] = menopauseChanges;
    if (otherCyclicalNotes != null) data['other_cyclical_notes'] = otherCyclicalNotes;
    return data;
  }
}

class ReproductiveLifeStageFormField {
  String? key;
  String? label;
  String? type;
  bool? required;
  List<ReproductiveLifeStageOption>? options;

  ReproductiveLifeStageFormField({
    this.key,
    this.label,
    this.type,
    this.required,
    this.options,
  });

  ReproductiveLifeStageFormField.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    label = json['label'];
    type = json['type'];
    required = json['required'];
    if (json['options'] != null) {
      options = <ReproductiveLifeStageOption>[];
      json['options'].forEach((v) {
        options!.add(ReproductiveLifeStageOption.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['label'] = label;
    data['type'] = type;
    data['required'] = required;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReproductiveLifeStageOption {
  String? value;
  String? label;

  ReproductiveLifeStageOption({this.value, this.label});

  ReproductiveLifeStageOption.fromJson(Map<String, dynamic> json) {
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
