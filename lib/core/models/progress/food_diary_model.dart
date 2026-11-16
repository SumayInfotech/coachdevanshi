class FoodDiaryModel {
  final bool? success;
  final String? message;
  final FoodDiaryData? data;

  FoodDiaryModel({
    this.success,
    this.message,
    this.data,
  });

  factory FoodDiaryModel.fromJson(Map<String, dynamic> json) {
    return FoodDiaryModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? FoodDiaryData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data?.toJson(),
  };
}

class FoodDiaryData {
  final List<FoodDiaryDayItem>? days;
  final int? completed;
  final int? total;
  final bool? isCompleted;

  FoodDiaryData({
    this.days,
    this.completed,
    this.total,
    this.isCompleted,
  });

  factory FoodDiaryData.fromJson(Map<String, dynamic> json) {
    return FoodDiaryData(
      days: json['days'] != null && json['days'] is List
          ? (json['days'] as List)
              .map((e) => FoodDiaryDayItem.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      completed: json['completed'] as int?,
      total: json['total'] as int?,
      isCompleted: json['is_completed'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    'days': days?.map((e) => e.toJson()).toList(),
    'completed': completed,
    'total': total,
    'is_completed': isCompleted,
  };
}

class FoodDiaryDayItem {
  final int? dayNumber;
  final String? label;
  final String? dayType;
  final bool? isCompleted;
  final FoodDiaryEntry? entry;

  FoodDiaryDayItem({
    this.dayNumber,
    this.label,
    this.dayType,
    this.isCompleted,
    this.entry,
  });

  factory FoodDiaryDayItem.fromJson(Map<String, dynamic> json) {
    return FoodDiaryDayItem(
      dayNumber: json['day_number'] as int?,
      label: json['label'] as String?,
      dayType: json['day_type'] as String?,
      isCompleted: json['is_completed'] as bool?,
      entry: json['entry'] != null && json['entry'] is Map<String, dynamic>
          ? FoodDiaryEntry.fromJson(json['entry'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'day_number': dayNumber,
    'label': label,
    'day_type': dayType,
    'is_completed': isCompleted,
    'entry': entry?.toJson(),
  };
}

class FoodDiaryEntry {
  final String? uuid;
  final int? dayNumber;
  final String? dayType;
  final String? recordDate;
  final FoodDiaryMeals? meals;
  final List<String>? sensations;
  final String? contextNotes;
  final String? updatedAt;

  FoodDiaryEntry({
    this.uuid,
    this.dayNumber,
    this.dayType,
    this.recordDate,
    this.meals,
    this.sensations,
    this.contextNotes,
    this.updatedAt,
  });

  factory FoodDiaryEntry.fromJson(Map<String, dynamic> json) {
    return FoodDiaryEntry(
      uuid: json['uuid'] as String?,
      dayNumber: json['day_number'] as int?,
      dayType: json['day_type'] as String?,
      recordDate: json['record_date'] as String?,
      meals: json['meals'] != null && json['meals'] is Map<String, dynamic>
          ? FoodDiaryMeals.fromJson(json['meals'])
          : null,
      sensations: json['sensations'] != null && json['sensations'] is List
          ? (json['sensations'] as List).map((e) => e.toString()).toList()
          : null,
      contextNotes: json['context_notes'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'day_number': dayNumber,
    'day_type': dayType,
    'record_date': recordDate,
    'meals': meals?.toJson(),
    'sensations': sensations,
    'context_notes': contextNotes,
    'updated_at': updatedAt,
  };
}

class FoodDiaryMeals {
  final FoodDiaryMeal? breakfast;
  final FoodDiaryMeal? lunch;
  final FoodDiaryMeal? dinner;
  final FoodDiarySnacks? snacks;

  FoodDiaryMeals({
    this.breakfast,
    this.lunch,
    this.dinner,
    this.snacks,
  });

  factory FoodDiaryMeals.fromJson(Map<String, dynamic> json) {
    return FoodDiaryMeals(
      breakfast: json['breakfast'] != null && json['breakfast'] is Map<String, dynamic>
          ? FoodDiaryMeal.fromJson(json['breakfast'])
          : null,
      lunch: json['lunch'] != null && json['lunch'] is Map<String, dynamic>
          ? FoodDiaryMeal.fromJson(json['lunch'])
          : null,
      dinner: json['dinner'] != null && json['dinner'] is Map<String, dynamic>
          ? FoodDiaryMeal.fromJson(json['dinner'])
          : null,
      snacks: json['snacks'] != null && json['snacks'] is Map<String, dynamic>
          ? FoodDiarySnacks.fromJson(json['snacks'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'breakfast': breakfast?.toJson(),
    'lunch': lunch?.toJson(),
    'dinner': dinner?.toJson(),
    'snacks': snacks?.toJson(),
  };
}

class FoodDiaryMeal {
  final String? time;
  final String? items;

  FoodDiaryMeal({
    this.time,
    this.items,
  });

  factory FoodDiaryMeal.fromJson(Map<String, dynamic> json) {
    return FoodDiaryMeal(
      time: json['time'] as String?,
      items: json['items'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'time': time,
    'items': items,
  };
}

class FoodDiarySnacks {
  final String? items;

  FoodDiarySnacks({
    this.items,
  });

  factory FoodDiarySnacks.fromJson(Map<String, dynamic> json) {
    return FoodDiarySnacks(
      items: json['items'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'items': items,
  };
}
