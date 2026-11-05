class DailyCheckinModel {
  final bool? success;
  final String? message;
  final DailyCheckinData? data;

  DailyCheckinModel({
    this.success,
    this.message,
    this.data,
  });

  factory DailyCheckinModel.fromJson(Map<String, dynamic> json) {
    return DailyCheckinModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? DailyCheckinData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data?.toJson(),
  };
}

class DailyCheckinData {
  final String? uuid;
  final String? recordDate;
  final int? baselineDay;
  final num? weight;
  final String? weightUnit;
  final String? wakeTime;
  final String? bedTime;
  final num? sleepHours;
  final String? sleepQuality;
  final int? steps;
  final num? waterIntake;
  final String? waterUnit;
  final dynamic waterGoalMet;
  final int? mood;
  final int? energy;
  final String? nutritionAdherence;
  final bool? movementDone;
  final String? movementType;
  final bool? meditationDone;
  final String? meditationNotes;
  final bool? journalingDone;
  final String? journalingNotes;
  final CheckinMeals? meals;
  final String? notes;
  final List<dynamic>? photos;
  final String? createdAt;
  final String? updatedAt;

  DailyCheckinData({
    this.uuid,
    this.recordDate,
    this.baselineDay,
    this.weight,
    this.weightUnit,
    this.wakeTime,
    this.bedTime,
    this.sleepHours,
    this.sleepQuality,
    this.steps,
    this.waterIntake,
    this.waterUnit,
    this.waterGoalMet,
    this.mood,
    this.energy,
    this.nutritionAdherence,
    this.movementDone,
    this.movementType,
    this.meditationDone,
    this.meditationNotes,
    this.journalingDone,
    this.journalingNotes,
    this.meals,
    this.notes,
    this.photos,
    this.createdAt,
    this.updatedAt,
  });

  factory DailyCheckinData.fromJson(Map<String, dynamic> json) {
    return DailyCheckinData(
      uuid: json['uuid'] as String?,
      recordDate: json['record_date'] as String?,
      baselineDay: json['baseline_day'] as int?,
      weight: json['weight'] != null ? (json['weight'] as num) : null,
      weightUnit: json['weight_unit'] as String?,
      wakeTime: json['wake_time'] as String?,
      bedTime: json['bed_time'] as String?,
      sleepHours: json['sleep_hours'] != null ? (json['sleep_hours'] as num) : null,
      sleepQuality: json['sleep_quality'] as String?,
      steps: json['steps'] as int?,
      waterIntake: json['water_intake'] != null ? (json['water_intake'] as num) : null,
      waterUnit: json['water_unit'] as String?,
      waterGoalMet: json['water_goal_met'],
      mood: json['mood'] as int?,
      energy: json['energy'] as int?,
      nutritionAdherence: json['nutrition_adherence'] as String?,
      movementDone: json['movement_done'] as bool?,
      movementType: json['movement_type'] as String?,
      meditationDone: json['meditation_done'] as bool?,
      meditationNotes: json['meditation_notes'] as String?,
      journalingDone: json['journaling_done'] as bool?,
      journalingNotes: json['journaling_notes'] as String?,
      meals: json['meals'] != null && json['meals'] is Map<String, dynamic>
          ? CheckinMeals.fromJson(json['meals'])
          : null,
      notes: json['notes'] as String?,
      photos: json['photos'] as List<dynamic>?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'record_date': recordDate,
    'baseline_day': baselineDay,
    'weight': weight,
    'weight_unit': weightUnit,
    'wake_time': wakeTime,
    'bed_time': bedTime,
    'sleep_hours': sleepHours,
    'sleep_quality': sleepQuality,
    'steps': steps,
    'water_intake': waterIntake,
    'water_unit': waterUnit,
    'water_goal_met': waterGoalMet,
    'mood': mood,
    'energy': energy,
    'nutrition_adherence': nutritionAdherence,
    'movement_done': movementDone,
    'movement_type': movementType,
    'meditation_done': meditationDone,
    'meditation_notes': meditationNotes,
    'journaling_done': journalingDone,
    'journaling_notes': journalingNotes,
    'meals': meals?.toJson(),
    'notes': notes,
    'photos': photos,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}

class CheckinMeals {
  final MealDetail? breakfast;
  final MealDetail? midMorning;
  final MealDetail? lunch;
  final MealDetail? dinner;

  CheckinMeals({
    this.breakfast,
    this.midMorning,
    this.lunch,
    this.dinner,
  });

  factory CheckinMeals.fromJson(Map<String, dynamic> json) {
    return CheckinMeals(
      breakfast: json['breakfast'] != null && json['breakfast'] is Map<String, dynamic>
          ? MealDetail.fromJson(json['breakfast'])
          : null,
      midMorning: json['mid_morning'] != null && json['mid_morning'] is Map<String, dynamic>
          ? MealDetail.fromJson(json['mid_morning'])
          : null,
      lunch: json['lunch'] != null && json['lunch'] is Map<String, dynamic>
          ? MealDetail.fromJson(json['lunch'])
          : null,
      dinner: json['dinner'] != null && json['dinner'] is Map<String, dynamic>
          ? MealDetail.fromJson(json['dinner'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'breakfast': breakfast?.toJson(),
    'mid_morning': midMorning?.toJson(),
    'lunch': lunch?.toJson(),
    'dinner': dinner?.toJson(),
  };
}

class MealDetail {
  final String? time;
  final String? items;

  MealDetail({this.time, this.items});

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    return MealDetail(
      time: json['time'] as String?,
      items: json['items'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'time': time,
    'items': items,
  };
}
