class ChapterFourModel {
  ChapterFourModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory ChapterFourModel.fromJson(Map<String, dynamic> json){
    return ChapterFourModel(
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
    this.eatingPattern,
    this.eatingPatternOther,
    this.culturalFastingPractices,
    this.weekdayMeals,
    this.weekendRoutine,
    this.foodsEnjoyed,
    this.foodsDisliked,
    this.foodsNotReadyToGiveUp,
    this.foodEnvWhoCooks,
    this.foodEnvShareMealsWith,
    this.foodEnvSupportLevel,
    this.foodEnvMealsOutPerWeek,
    this.intakeFruit,
    this.intakeVegetables,
    this.intakeWater,
    this.intakeCaffeine,
    this.intakeSugary,
    this.substanceHabits,
    this.digestiveHealth,
  });

  final String? eatingPattern;
  final String? eatingPatternOther;
  final List<String>? culturalFastingPractices;
  final WeekdayMeals? weekdayMeals;
  final String? weekendRoutine;
  final String? foodsEnjoyed;
  final String? foodsDisliked;
  final String? foodsNotReadyToGiveUp;
  final String? foodEnvWhoCooks;
  final String? foodEnvShareMealsWith;
  final String? foodEnvSupportLevel;
  final String? foodEnvMealsOutPerWeek;
  final String? intakeFruit;
  final String? intakeVegetables;
  final String? intakeWater;
  final String? intakeCaffeine;
  final String? intakeSugary;
  final List<String>? substanceHabits;
  final List<String>? digestiveHealth;

  factory Answers.fromJson(Map<String, dynamic> json){
    return Answers(
      eatingPattern: json["eating_pattern"]?.toString(),
      eatingPatternOther: json["eating_pattern_other"],
      culturalFastingPractices: json["cultural_fasting_practices"] == null
          ? []
          : List<String>.from(json["cultural_fasting_practices"]!.map((x) => x.toString())),
      weekdayMeals: json["weekday_meals"] == null ? null : WeekdayMeals.fromJson(json["weekday_meals"]),
      weekendRoutine: json["weekend_routine"],
      foodsEnjoyed: json["foods_enjoyed"],
      foodsDisliked: json["foods_disliked"],
      foodsNotReadyToGiveUp: json["foods_not_ready_to_give_up"],
      foodEnvWhoCooks: json["food_env_who_cooks"]?.toString(),
      foodEnvShareMealsWith: json["food_env_share_meals_with"],
      foodEnvSupportLevel: json["food_env_support_level"]?.toString(),
      foodEnvMealsOutPerWeek: json["food_env_meals_out_per_week"]?.toString(),
      intakeFruit: json["intake_fruit"]?.toString(),
      intakeVegetables: json["intake_vegetables"]?.toString(),
      intakeWater: json["intake_water"]?.toString(),
      intakeCaffeine: json["intake_caffeine"]?.toString(),
      intakeSugary: json["intake_sugary"]?.toString(),
      substanceHabits: json["substance_habits"] == null
          ? []
          : List<String>.from(json["substance_habits"]!.map((x) => x.toString())),
      digestiveHealth: json["digestive_health"] == null
          ? []
          : List<String>.from(json["digestive_health"]!.map((x) => x.toString())),
    );
  }

  Map<String, dynamic> toJson() => {
    "eating_pattern": eatingPattern,
    "eating_pattern_other": eatingPatternOther,
    "cultural_fasting_practices": culturalFastingPractices,
    "weekday_meals": weekdayMeals?.toJson(),
    "weekend_routine": weekendRoutine,
    "foods_enjoyed": foodsEnjoyed,
    "foods_disliked": foodsDisliked,
    "foods_not_ready_to_give_up": foodsNotReadyToGiveUp,
    "food_env_who_cooks": foodEnvWhoCooks,
    "food_env_share_meals_with": foodEnvShareMealsWith,
    "food_env_support_level": foodEnvSupportLevel,
    "food_env_meals_out_per_week": foodEnvMealsOutPerWeek,
    "intake_fruit": intakeFruit,
    "intake_vegetables": intakeVegetables,
    "intake_water": intakeWater,
    "intake_caffeine": intakeCaffeine,
    "intake_sugary": intakeSugary,
    "substance_habits": substanceHabits,
    "digestive_health": digestiveHealth,
  };
}

class WeekdayMeals {
  WeekdayMeals({
    this.firstIntake,
    this.breakfast,
    this.lunch,
    this.eveningSnack,
    this.dinner,
    this.lateNight,
    this.mealTimings,
  });

  final String? firstIntake;
  final String? breakfast;
  final String? lunch;
  final String? eveningSnack;
  final String? dinner;
  final String? lateNight;
  final String? mealTimings;

  factory WeekdayMeals.fromJson(Map<String, dynamic> json){
    return WeekdayMeals(
      firstIntake: json["first_intake"],
      breakfast: json["breakfast"],
      lunch: json["lunch"],
      eveningSnack: json["evening_snack"],
      dinner: json["dinner"],
      lateNight: json["late_night"],
      mealTimings: json["meal_timings"],
    );
  }

  Map<String, dynamic> toJson() => {
    "first_intake": firstIntake,
    "breakfast": breakfast,
    "lunch": lunch,
    "evening_snack": eveningSnack,
    "dinner": dinner,
    "late_night": lateNight,
    "meal_timings": mealTimings,
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
    this.fields,
  });

  final String? key;
  final String? label;
  final String? type;
  final bool? required;
  final int? min;
  final int? max;
  final List<Option> options;
  final List<Field>? fields;

  factory Field.fromJson(Map<String, dynamic> json){
    return Field(
      key: json["key"],
      label: json["label"],
      type: json["type"],
      required: json["required"],
      min: json["min"],
      max: json["max"],
      options: json["options"] == null ? [] : List<Option>.from(json["options"]!.map((x) => Option.fromJson(x))),
      fields: json["fields"] == null ? null : List<Field>.from(json["fields"]!.map((x) => Field.fromJson(x))),
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
    "fields": fields?.map((x) => x.toJson()).toList(),
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
