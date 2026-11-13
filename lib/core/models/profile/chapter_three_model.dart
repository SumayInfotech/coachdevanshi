class ChapterThreeModel {
  ChapterThreeModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory ChapterThreeModel.fromJson(Map<String, dynamic> json){
    return ChapterThreeModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  Data({
    required this.chapter,
    required this.title,
    required this.subtitle,
    required this.total,
    required this.status,
    required this.completedAt,
    required this.fields,
    required this.answers,
  });

  final int? chapter;
  final String? title;
  final String? subtitle;
  final int? total;
  final String? status;
  final dynamic completedAt;
  final List<Field> fields;
  final Answers? answers;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      chapter: json["chapter"],
      title: json["title"],
      subtitle: json["subtitle"],
      total: json["total"],
      status: json["status"],
      completedAt: json["completed_at"],
      fields: json["fields"] == null ? [] : List<Field>.from(json["fields"]!.map((x) => Field.fromJson(x))),
      answers: json["answers"] == null ? null : Answers.fromJson(json["answers"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "chapter": chapter,
    "title": title,
    "subtitle": subtitle,
    "total": total,
    "status": status,
    "completed_at": completedAt,
    "fields": fields.map((x) => x.toJson()).toList(),
    "answers": answers?.toJson(),
  };
}

class Answers {
  Answers({
    this.medicalDiagnoses,
    this.medicalDiagnosesOther,
    this.familyMedicalHistory,
    this.familyHistoryOther,
    this.takingMedications,
    this.medications,
    this.hasMovementLimitations,
    this.movementLimitationsDetail,
    this.movementLimitationDetails,
    this.hasPhysicianRestrictions,
    this.physicianGuidance,
    this.recentClinicalSymptoms,
    this.recentClinicalSymptomsOther,
    this.allergiesIntolerances,
    this.allergyDetails,
    this.hormonalLifeStage,
    this.hormonalLifeStageOther,
  });

  final List<String>? medicalDiagnoses;
  final String? medicalDiagnosesOther;
  final List<String>? familyMedicalHistory;
  final String? familyHistoryOther;
  final bool? takingMedications;
  final List<MedicationItem>? medications;
  final bool? hasMovementLimitations;
  final String? movementLimitationsDetail;
  final String? movementLimitationDetails;
  final bool? hasPhysicianRestrictions;
  final String? physicianGuidance;
  final List<String>? recentClinicalSymptoms;
  final String? recentClinicalSymptomsOther;
  final String? allergiesIntolerances;
  final String? allergyDetails;
  final String? hormonalLifeStage;
  final String? hormonalLifeStageOther;

  factory Answers.fromJson(Map<String, dynamic> json){
    return Answers(
      medicalDiagnoses: json["medical_diagnoses"] == null
          ? []
          : List<String>.from(json["medical_diagnoses"]!.map((x) => x.toString())),
      medicalDiagnosesOther: json["medical_diagnoses_other"],
      familyMedicalHistory: json["family_medical_history"] == null
          ? []
          : List<String>.from(json["family_medical_history"]!.map((x) => x.toString())),
      familyHistoryOther: json["family_history_other"],
      takingMedications: json["taking_medications"],
      medications: json["medications"] == null
          ? []
          : List<MedicationItem>.from(json["medications"]!.map((x) => MedicationItem.fromJson(x))),
      hasMovementLimitations: json["has_movement_limitations"],
      movementLimitationsDetail: json["movement_limitations_detail"] ?? json["movement_limitation_details"],
      movementLimitationDetails: json["movement_limitations_detail"] ?? json["movement_limitation_details"],
      hasPhysicianRestrictions: json["has_physician_restrictions"],
      physicianGuidance: json["physician_guidance"],
      recentClinicalSymptoms: json["recent_clinical_symptoms"] == null
          ? []
          : List<String>.from(json["recent_clinical_symptoms"]!.map((x) => x.toString())),
      recentClinicalSymptomsOther: json["recent_clinical_symptoms_other"],
      allergiesIntolerances: json["allergies_intolerances"]?.toString(),
      allergyDetails: json["allergy_details"],
      hormonalLifeStage: json["hormonal_life_stage"]?.toString(),
      hormonalLifeStageOther: json["hormonal_life_stage_other"],
    );
  }

  Map<String, dynamic> toJson() => {
    "medical_diagnoses": medicalDiagnoses,
    "medical_diagnoses_other": medicalDiagnosesOther,
    "family_medical_history": familyMedicalHistory,
    "family_history_other": familyHistoryOther,
    "taking_medications": takingMedications,
    "medications": medications?.map((x) => x.toJson()).toList(),
    "has_movement_limitations": hasMovementLimitations,
    "movement_limitations_detail": movementLimitationsDetail ?? movementLimitationDetails,
    "movement_limitation_details": movementLimitationDetails ?? movementLimitationsDetail,
    "has_physician_restrictions": hasPhysicianRestrictions,
    "physician_guidance": physicianGuidance,
    "recent_clinical_symptoms": recentClinicalSymptoms,
    "recent_clinical_symptoms_other": recentClinicalSymptomsOther,
    "allergies_intolerances": allergiesIntolerances,
    "allergy_details": allergyDetails,
    "hormonal_life_stage": hormonalLifeStage,
    "hormonal_life_stage_other": hormonalLifeStageOther,
  };
}

class MedicationItem {
  MedicationItem({
    this.name,
    this.dose,
    this.frequency,
    this.reason,
  });

  final String? name;
  final String? dose;
  final String? frequency;
  final String? reason;

  factory MedicationItem.fromJson(Map<String, dynamic> json){
    return MedicationItem(
      name: json["name"],
      dose: json["dose"],
      frequency: json["frequency"],
      reason: json["reason"],
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "dose": dose,
    "frequency": frequency,
    "reason": reason,
  };
}

class Field {
  Field({
    required this.key,
    required this.label,
    required this.type,
    required this.required,
    required this.min,
    required this.max,
    required this.options,
  });

  final String? key;
  final String? label;
  final String? type;
  final bool? required;
  final int? min;
  final int? max;
  final List<Option> options;

  factory Field.fromJson(Map<String, dynamic> json){
    return Field(
      key: json["key"],
      label: json["label"],
      type: json["type"],
      required: json["required"],
      min: json["min"],
      max: json["max"],
      options: json["options"] == null ? [] : List<Option>.from(json["options"]!.map((x) => Option.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "key": key,
    "label": label,
    "type": type,
    "required": required,
    "min": min,
    "max": max,
    "options": options.map((x) => x.toJson()).toList(),
  };
}

class Option {
  Option({
    required this.value,
    required this.label,
    required this.description,
    required this.image,
  });

  final String? value;
  final String? label;
  final dynamic description;
  final dynamic image;

  factory Option.fromJson(Map<String, dynamic> json){
    return Option(
      value: json["value"],
      label: json["label"],
      description: json["description"],
      image: json["image"],
    );
  }

  Map<String, dynamic> toJson() => {
    "value": value,
    "label": label,
    "description": description,
    "image": image,
  };
}
