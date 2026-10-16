class OnboardingMastersModel {
  OnboardingMastersModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory OnboardingMastersModel.fromJson(Map<String, dynamic> json){
    return OnboardingMastersModel(
      success: json["success"],
      message: json["message"],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };

}

class Data {

  final List<OnboardingData>? coachingJourney;
  final List<OnboardingData>? approachesTried;
  final List<OnboardingData>? confidentAreas;
  final List<OnboardingData>? medicalDiagnoses;
  final List<OnboardingData>? familyMedicalHistory;
  final List<OnboardingData>? recentClinicalSymptoms;
  final List<OnboardingData>? allergiesIntolerances;
  final List<OnboardingData>? hormonalLifeStage;
  final List<OnboardingData>? eatingPattern;
  final List<OnboardingData>? culturalFastingPractices;
  final List<OnboardingData>? foodEnvWhoCooks;
  final List<OnboardingData>? foodEnvSupportLevel;
  final List<OnboardingData>? foodEnvMealsOutPerWeek;
  final List<OnboardingData>? intakeFruit;
  final List<OnboardingData>? intakeVegetables;
  final List<OnboardingData>? intakeWater;
  final List<OnboardingData>? intakeCaffeine;
  final List<OnboardingData>? intakeSugary;
  final List<OnboardingData>? substanceHabits;
  final List<OnboardingData>? digestiveHealth;
  final List<OnboardingData>? sleepNightWaking;
  final List<OnboardingData>? sleepFirstHour;
  final List<OnboardingData>? activityLevel;
  final List<OnboardingData>? activityDailySteps;
  final List<OnboardingData>? activityWorkoutsPerWeek;
  final List<OnboardingData>? activityAvailableDays;
  final List<OnboardingData>? stressFirstChanges;
  final List<OnboardingData>? readinessScore;
  final List<OnboardingData>? consistencyInterrupters;
  final List<OnboardingData>? goalMindset;

  const Data({
    required this.coachingJourney,
    required this.approachesTried,
    required this.confidentAreas,
    required this.medicalDiagnoses,
    required this.familyMedicalHistory,
    required this.recentClinicalSymptoms,
    required this.allergiesIntolerances,
    required this.hormonalLifeStage,
    required this.eatingPattern,
    required this.culturalFastingPractices,
    required this.foodEnvWhoCooks,
    required this.foodEnvSupportLevel,
    required this.foodEnvMealsOutPerWeek,
    required this.intakeFruit,
    required this.intakeVegetables,
    required this.intakeWater,
    required this.intakeCaffeine,
    required this.intakeSugary,
    required this.substanceHabits,
    required this.digestiveHealth,
    required this.sleepNightWaking,
    required this.sleepFirstHour,
    required this.activityLevel,
    required this.activityDailySteps,
    required this.activityWorkoutsPerWeek,
    required this.activityAvailableDays,
    required this.stressFirstChanges,
    required this.readinessScore,
    required this.consistencyInterrupters,
    required this.goalMindset,
  });

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      coachingJourney: json["coaching_journey"] == null ? [] : List<OnboardingData>.from(json["coaching_journey"]!.map((x) => OnboardingData.fromJson(x))),
      approachesTried: json["approaches_tried"] == null ? [] : List<OnboardingData>.from(json["approaches_tried"]!.map((x) => OnboardingData.fromJson(x))),
      confidentAreas: json["confident_areas"] == null ? [] : List<OnboardingData>.from(json["confident_areas"]!.map((x) => OnboardingData.fromJson(x))),
      medicalDiagnoses: json["medical_diagnoses"] == null ? [] : List<OnboardingData>.from(json["medical_diagnoses"]!.map((x) => OnboardingData.fromJson(x))),
      familyMedicalHistory: json["family_medical_history"] == null ? [] : List<OnboardingData>.from(json["family_medical_history"]!.map((x) => OnboardingData.fromJson(x))),
      recentClinicalSymptoms: json["recent_clinical_symptoms"] == null ? [] : List<OnboardingData>.from(json["recent_clinical_symptoms"]!.map((x) => OnboardingData.fromJson(x))),
      allergiesIntolerances: json["allergies_intolerances"] == null ? [] : List<OnboardingData>.from(json["allergies_intolerances"]!.map((x) => OnboardingData.fromJson(x))),
      hormonalLifeStage: json["hormonal_life_stage"] == null ? [] : List<OnboardingData>.from(json["hormonal_life_stage"]!.map((x) => OnboardingData.fromJson(x))),
      eatingPattern: json["eating_pattern"] == null ? [] : List<OnboardingData>.from(json["eating_pattern"]!.map((x) => OnboardingData.fromJson(x))),
      culturalFastingPractices: json["cultural_fasting_practices"] == null ? [] : List<OnboardingData>.from(json["cultural_fasting_practices"]!.map((x) => OnboardingData.fromJson(x))),
      foodEnvWhoCooks: json["food_env_who_cooks"] == null ? [] : List<OnboardingData>.from(json["food_env_who_cooks"]!.map((x) => OnboardingData.fromJson(x))),
      foodEnvSupportLevel: json["food_env_support_level"] == null ? [] : List<OnboardingData>.from(json["food_env_support_level"]!.map((x) => OnboardingData.fromJson(x))),
      foodEnvMealsOutPerWeek: json["food_env_meals_out_per_week"] == null ? [] : List<OnboardingData>.from(json["food_env_meals_out_per_week"]!.map((x) => OnboardingData.fromJson(x))),
      intakeFruit: json["intake_fruit"] == null ? [] : List<OnboardingData>.from(json["intake_fruit"]!.map((x) => OnboardingData.fromJson(x))),
      intakeVegetables: json["intake_vegetables"] == null ? [] : List<OnboardingData>.from(json["intake_vegetables"]!.map((x) => OnboardingData.fromJson(x))),
      intakeWater: json["intake_water"] == null ? [] : List<OnboardingData>.from(json["intake_water"]!.map((x) => OnboardingData.fromJson(x))),
      intakeCaffeine: json["intake_caffeine"] == null ? [] : List<OnboardingData>.from(json["intake_caffeine"]!.map((x) => OnboardingData.fromJson(x))),
      intakeSugary: json["intake_sugary"] == null ? [] : List<OnboardingData>.from(json["intake_sugary"]!.map((x) => OnboardingData.fromJson(x))),
      substanceHabits: json["substance_habits"] == null ? [] : List<OnboardingData>.from(json["substance_habits"]!.map((x) => OnboardingData.fromJson(x))),
      digestiveHealth: json["digestive_health"] == null ? [] : List<OnboardingData>.from(json["digestive_health"]!.map((x) => OnboardingData.fromJson(x))),
      sleepNightWaking: json["sleep_night_waking"] == null ? [] : List<OnboardingData>.from(json["sleep_night_waking"]!.map((x) => OnboardingData.fromJson(x))),
      sleepFirstHour: json["sleep_first_hour"] == null ? [] : List<OnboardingData>.from(json["sleep_first_hour"]!.map((x) => OnboardingData.fromJson(x))),
      activityLevel: json["activity_level"] == null ? [] : List<OnboardingData>.from(json["activity_level"]!.map((x) => OnboardingData.fromJson(x))),
      activityDailySteps: json["activity_daily_steps"] == null ? [] : List<OnboardingData>.from(json["activity_daily_steps"]!.map((x) => OnboardingData.fromJson(x))),
      activityWorkoutsPerWeek: json["activity_workouts_per_week"] == null ? [] : List<OnboardingData>.from(json["activity_workouts_per_week"]!.map((x) => OnboardingData.fromJson(x))),
      activityAvailableDays: json["activity_available_days"] == null ? [] : List<OnboardingData>.from(json["activity_available_days"]!.map((x) => OnboardingData.fromJson(x))),
      stressFirstChanges: json["stress_first_changes"] == null ? [] : List<OnboardingData>.from(json["stress_first_changes"]!.map((x) => OnboardingData.fromJson(x))),
      readinessScore: json["readiness_score"] == null ? [] : List<OnboardingData>.from(json["readiness_score"]!.map((x) => OnboardingData.fromJson(x))),
      consistencyInterrupters: json["consistency_interrupters"] == null ? [] : List<OnboardingData>.from(json["consistency_interrupters"]!.map((x) => OnboardingData.fromJson(x))),
      goalMindset: json["goal_mindset"] == null ? [] : List<OnboardingData>.from(json["goal_mindset"]!.map((x) => OnboardingData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "coachingJourney": coachingJourney?.map((x) => x.toJson()).toList(),
    "approachesTried": approachesTried?.map((x) => x.toJson()).toList(),
    "confidentAreas": confidentAreas?.map((x) => x.toJson()).toList(),
    "medicalDiagnoses": medicalDiagnoses?.map((x) => x.toJson()).toList(),
    "familyMedicalHistory": familyMedicalHistory?.map((x) => x.toJson()).toList(),
    "recentClinicalSymptoms": recentClinicalSymptoms?.map((x) => x.toJson()).toList(),
    "allergiesIntolerances": allergiesIntolerances?.map((x) => x.toJson()).toList(),
    "hormonalLifeStage": hormonalLifeStage?.map((x) => x.toJson()).toList(),
    "eatingPattern": eatingPattern?.map((x) => x.toJson()).toList(),
    "culturalFastingPractices": culturalFastingPractices?.map((x) => x.toJson()).toList(),
    "foodEnvWhoCooks": foodEnvWhoCooks?.map((x) => x.toJson()).toList(),
    "foodEnvSupportLevel": foodEnvSupportLevel?.map((x) => x.toJson()).toList(),
    "foodEnvMealsOutPerWeek": foodEnvMealsOutPerWeek?.map((x) => x.toJson()).toList(),
    "intakeFruit": intakeFruit?.map((x) => x.toJson()).toList(),
    "intakeVegetables": intakeVegetables?.map((x) => x.toJson()).toList(),
    "intakeWater": intakeWater?.map((x) => x.toJson()).toList(),
    "intakeCaffeine": intakeCaffeine?.map((x) => x.toJson()).toList(),
    "intakeSugary": intakeSugary?.map((x) => x.toJson()).toList(),
    "substanceHabits": substanceHabits?.map((x) => x.toJson()).toList(),
    "digestiveHealth": digestiveHealth?.map((x) => x.toJson()).toList(),
    "sleepNightWaking": sleepNightWaking?.map((x) => x.toJson()).toList(),
    "sleepFirstHour": sleepFirstHour?.map((x) => x.toJson()).toList(),
    "activityLevel": activityLevel?.map((x) => x.toJson()).toList(),
    "activityDailySteps": activityDailySteps?.map((x) => x.toJson()).toList(),
    "activityWorkoutsPerWeek": activityWorkoutsPerWeek?.map((x) => x.toJson()).toList(),
    "activityAvailableDays": activityAvailableDays?.map((x) => x.toJson()).toList(),
    "stressFirstChanges": stressFirstChanges?.map((x) => x.toJson()).toList(),
    "readinessScore": readinessScore?.map((x) => x.toJson()).toList(),
    "consistencyInterrupters": consistencyInterrupters?.map((x) => x.toJson()).toList(),
    "goalMindset": goalMindset?.map((x) => x.toJson()).toList(),
  };
}

class OnboardingData {
  OnboardingData({
    required this.uuid,
    required this.title,
    required this.description,
    required this.image,
    required this.sortOrder,
  });

  final String? uuid;
  final String? title;
  final String? description;
  final String? image;
  final int? sortOrder;

  factory OnboardingData.fromJson(Map<String, dynamic> json){
    return OnboardingData(
      uuid: json["uuid"],
      title: json["title"],
      description: json["description"],
      image: json["image"],
      sortOrder: json["sort_order"],
    );
  }

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "title": title,
    "description": description,
    "image": image,
    "sort_order": sortOrder,
  };
}