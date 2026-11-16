import 'pathways_model.dart';

class GutResetModel {
  bool? success;
  String? message;
  GutResetData? data;

  GutResetModel({this.success, this.message, this.data});

  GutResetModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? GutResetData.fromJson(json['data']) : null;
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

class GutResetData {
  PathwayItem? pathway;
  String? title;
  String? status;
  String? submittedAt;
  List<GutResetFormField>? fields;
  GutResetAnswers? answers;

  GutResetData({
    this.pathway,
    this.title,
    this.status,
    this.submittedAt,
    this.fields,
    this.answers,
  });

  GutResetData.fromJson(Map<String, dynamic> json) {
    pathway = json['pathway'] != null ? PathwayItem.fromJson(json['pathway']) : null;
    title = json['title'];
    status = json['status'];
    submittedAt = json['submitted_at'];
    if (json['fields'] != null) {
      fields = <GutResetFormField>[];
      json['fields'].forEach((v) {
        fields!.add(GutResetFormField.fromJson(v));
      });
    }
    answers = json['answers'] != null ? GutResetAnswers.fromJson(json['answers']) : null;
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

class GutResetAnswers {
  List<String>? primarySymptoms;
  String? symptomOnset;
  String? occurrenceFrequency;
  List<String>? symptomPeakTiming;
  String? bowelCadence;
  String? feelFullyEmptied;
  String? needsStimulant;
  List<String>? triggerFoods;
  String? otherTriggers;
  bool? priorDiagnosis;
  String? clinicalHistory;
  String? priorityReliefFocus;

  GutResetAnswers({
    this.primarySymptoms,
    this.symptomOnset,
    this.occurrenceFrequency,
    this.symptomPeakTiming,
    this.bowelCadence,
    this.feelFullyEmptied,
    this.needsStimulant,
    this.triggerFoods,
    this.otherTriggers,
    this.priorDiagnosis,
    this.clinicalHistory,
    this.priorityReliefFocus,
  });

  GutResetAnswers.fromJson(Map<String, dynamic> json) {
    if (json['primary_symptoms'] != null && json['primary_symptoms'] is List) {
      primarySymptoms = (json['primary_symptoms'] as List).map((e) => e.toString()).toList();
    }
    symptomOnset = json['symptom_onset']?.toString();
    occurrenceFrequency = json['occurrence_frequency']?.toString();
    if (json['symptom_peak_timing'] != null && json['symptom_peak_timing'] is List) {
      symptomPeakTiming = (json['symptom_peak_timing'] as List).map((e) => e.toString()).toList();
    }
    bowelCadence = json['bowel_cadence']?.toString();
    feelFullyEmptied = json['feel_fully_emptied']?.toString();
    needsStimulant = json['needs_stimulant']?.toString();
    if (json['trigger_foods'] != null && json['trigger_foods'] is List) {
      triggerFoods = (json['trigger_foods'] as List).map((e) => e.toString()).toList();
    }
    otherTriggers = json['other_triggers']?.toString();
    if (json['prior_diagnosis'] != null) {
      if (json['prior_diagnosis'] is bool) {
        priorDiagnosis = json['prior_diagnosis'];
      } else {
        priorDiagnosis = json['prior_diagnosis'].toString() == 'true' || json['prior_diagnosis'].toString() == '1';
      }
    }
    clinicalHistory = json['clinical_history']?.toString();
    priorityReliefFocus = json['priority_relief_focus']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (primarySymptoms != null) {
      data['primary_symptoms'] = primarySymptoms;
    }
    if (symptomOnset != null) {
      data['symptom_onset'] = symptomOnset;
    }
    if (occurrenceFrequency != null) {
      data['occurrence_frequency'] = occurrenceFrequency;
    }
    if (symptomPeakTiming != null) {
      data['symptom_peak_timing'] = symptomPeakTiming;
    }
    if (bowelCadence != null) {
      data['bowel_cadence'] = bowelCadence;
    }
    if (feelFullyEmptied != null) {
      data['feel_fully_emptied'] = feelFullyEmptied;
    }
    if (needsStimulant != null) {
      data['needs_stimulant'] = needsStimulant;
    }
    if (triggerFoods != null) {
      data['trigger_foods'] = triggerFoods;
    }
    if (otherTriggers != null) {
      data['other_triggers'] = otherTriggers;
    }
    if (priorDiagnosis != null) {
      data['prior_diagnosis'] = priorDiagnosis;
    }
    if (clinicalHistory != null) {
      data['clinical_history'] = clinicalHistory;
    }
    if (priorityReliefFocus != null) {
      data['priority_relief_focus'] = priorityReliefFocus;
    }
    return data;
  }
}

class GutResetFormField {
  String? key;
  String? label;
  String? type;
  bool? required;
  int? max;
  List<GutResetOption>? options;
  RequiredIf? requiredIf;

  GutResetFormField({
    this.key,
    this.label,
    this.type,
    this.required,
    this.max,
    this.options,
    this.requiredIf,
  });

  GutResetFormField.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    label = json['label'];
    type = json['type'];
    required = json['required'];
    max = json['max'];
    if (json['options'] != null) {
      options = <GutResetOption>[];
      json['options'].forEach((v) {
        options!.add(GutResetOption.fromJson(v));
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

class GutResetOption {
  String? value;
  String? label;

  GutResetOption({this.value, this.label});

  GutResetOption.fromJson(Map<String, dynamic> json) {
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
