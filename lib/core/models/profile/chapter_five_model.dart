class ChapterFiveModel {
  ChapterFiveModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory ChapterFiveModel.fromJson(Map<String, dynamic> json){
    return ChapterFiveModel(
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
    this.bedtime,
    this.wakeTime,
    this.sleepDuration,
    this.sleepNightWaking,
    this.sleepNightWakingOther,
    this.sleepFirstHour,
    this.activityLevel,
    this.activityDailySteps,
    this.activityWorkoutsPerWeek,
    this.movementTypes,
    this.wearableUsed,
    this.movementPreferences,
    this.activityAvailableDays,
    this.stressSources,
    this.stressFirstChanges,
    this.stressFirstChangesOther,
    this.stressRecovery,
    this.readinessScore,
    this.consistencyInterrupters,
    this.consistencyInterruptersOther,
  });

  final String? bedtime;
  final String? wakeTime;
  final String? sleepDuration;
  final String? sleepNightWaking;
  final String? sleepNightWakingOther;
  final String? sleepFirstHour;
  final String? activityLevel;
  final String? activityDailySteps;
  final String? activityWorkoutsPerWeek;
  final String? movementTypes;
  final String? wearableUsed;
  final String? movementPreferences;
  final String? activityAvailableDays;
  final List<String>? stressSources;
  final List<String>? stressFirstChanges;
  final String? stressFirstChangesOther;
  final String? stressRecovery;
  final String? readinessScore;
  final List<String>? consistencyInterrupters;
  final String? consistencyInterruptersOther;

  factory Answers.fromJson(Map<String, dynamic> json){
    return Answers(
      bedtime: json["bedtime"],
      wakeTime: json["wake_time"],
      sleepDuration: json["sleep_duration"],
      sleepNightWaking: json["sleep_night_waking"]?.toString(),
      sleepNightWakingOther: json["sleep_night_waking_other"],
      sleepFirstHour: json["sleep_first_hour"]?.toString(),
      activityLevel: json["activity_level"]?.toString(),
      activityDailySteps: json["activity_daily_steps"]?.toString(),
      activityWorkoutsPerWeek: json["activity_workouts_per_week"]?.toString(),
      movementTypes: json["movement_types"],
      wearableUsed: json["wearable_used"],
      movementPreferences: json["movement_preferences"],
      activityAvailableDays: json["activity_available_days"]?.toString(),
      stressSources: json["stress_sources"] == null
          ? []
          : List<String>.from(json["stress_sources"]!.map((x) => x.toString())),
      stressFirstChanges: json["stress_first_changes"] == null
          ? []
          : List<String>.from(json["stress_first_changes"]!.map((x) => x.toString())),
      stressFirstChangesOther: json["stress_first_changes_other"],
      stressRecovery: json["stress_recovery"],
      readinessScore: json["readiness_score"]?.toString(),
      consistencyInterrupters: json["consistency_interrupters"] == null
          ? []
          : List<String>.from(json["consistency_interrupters"]!.map((x) => x.toString())),
      consistencyInterruptersOther: json["consistency_interrupters_other"],
    );
  }

  Map<String, dynamic> toJson() => {
    "bedtime": bedtime,
    "wake_time": wakeTime,
    "sleep_duration": sleepDuration,
    "sleep_night_waking": sleepNightWaking,
    "sleep_night_waking_other": sleepNightWakingOther,
    "sleep_first_hour": sleepFirstHour,
    "activity_level": activityLevel,
    "activity_daily_steps": activityDailySteps,
    "activity_workouts_per_week": activityWorkoutsPerWeek,
    "movement_types": movementTypes,
    "wearable_used": wearableUsed,
    "movement_preferences": movementPreferences,
    "activity_available_days": activityAvailableDays,
    "stress_sources": stressSources,
    "stress_first_changes": stressFirstChanges,
    "stress_first_changes_other": stressFirstChangesOther,
    "stress_recovery": stressRecovery,
    "readiness_score": readinessScore,
    "consistency_interrupters": consistencyInterrupters,
    "consistency_interrupters_other": consistencyInterruptersOther,
  };
}

class Field {
  Field({
    required this.key,
    required this.label,
    required this.type,
    required this.required,
    this.max,
    this.options = const [],
  });

  final String? key;
  final String? label;
  final String? type;
  final bool? required;
  final int? max;
  final List<Option> options;

  factory Field.fromJson(Map<String, dynamic> json){
    return Field(
      key: json["key"],
      label: json["label"],
      type: json["type"],
      required: json["required"],
      max: json["max"],
      options: json["options"] == null ? [] : List<Option>.from(json["options"]!.map((x) => Option.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "key": key,
    "label": label,
    "type": type,
    "required": required,
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
  final String? description;
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
