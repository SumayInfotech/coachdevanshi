class WeeklyCheckinModel {
  final bool? success;
  final String? message;
  final WeeklyCheckinData? data;

  WeeklyCheckinModel({
    this.success,
    this.message,
    this.data,
  });

  factory WeeklyCheckinModel.fromJson(Map<String, dynamic> json) {
    return WeeklyCheckinModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? WeeklyCheckinData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data?.toJson(),
  };
}

class WeeklyCheckinData {
  final String? uuid;
  final String? recordDate;
  final bool? isBaseline;
  final num? weight;
  final String? weightUnit;
  final WeeklyMeasurements? measurements;
  final String? selfConfidence;
  final String? lastPeriodStart;
  final String? cycleDay;
  final String? cycleNotes;
  final String? cravingsLevel;
  final String? cravingsNotes;
  final bool? travelled;
  final String? travelNotes;
  final String? wins;
  final String? proudMoments;
  final String? struggles;
  final String? notes;
  final Map<String, dynamic>? extra;
  final List<dynamic>? photos;
  final String? createdAt;
  final String? updatedAt;

  WeeklyCheckinData({
    this.uuid,
    this.recordDate,
    this.isBaseline,
    this.weight,
    this.weightUnit,
    this.measurements,
    this.selfConfidence,
    this.lastPeriodStart,
    this.cycleDay,
    this.cycleNotes,
    this.cravingsLevel,
    this.cravingsNotes,
    this.travelled,
    this.travelNotes,
    this.wins,
    this.proudMoments,
    this.struggles,
    this.notes,
    this.extra,
    this.photos,
    this.createdAt,
    this.updatedAt,
  });

  factory WeeklyCheckinData.fromJson(Map<String, dynamic> json) {
    return WeeklyCheckinData(
      uuid: json['uuid'] as String?,
      recordDate: json['record_date'] as String?,
      isBaseline: json['is_baseline'] as bool?,
      weight: json['weight'] as num?,
      weightUnit: json['weight_unit'] as String?,
      measurements: json['measurements'] != null && json['measurements'] is Map<String, dynamic>
          ? WeeklyMeasurements.fromJson(json['measurements'])
          : null,
      selfConfidence: json['self_confidence'] as String?,
      lastPeriodStart: json['last_period_start'] as String?,
      cycleDay: json['cycle_day'] as String?,
      cycleNotes: json['cycle_notes'] as String?,
      cravingsLevel: json['cravings_level'] as String?,
      cravingsNotes: json['cravings_notes'] as String?,
      travelled: json['travelled'] as bool?,
      travelNotes: json['travel_notes'] as String?,
      wins: json['wins'] as String?,
      proudMoments: json['proud_moments'] as String?,
      struggles: json['struggles'] as String?,
      notes: json['notes'] as String?,
      extra: json['extra'] != null && json['extra'] is Map<String, dynamic>
          ? json['extra'] as Map<String, dynamic>
          : null,
      photos: json['photos'] as List<dynamic>?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'record_date': recordDate,
    'is_baseline': isBaseline,
    'weight': weight,
    'weight_unit': weightUnit,
    'measurements': measurements?.toJson(),
    'self_confidence': selfConfidence,
    'last_period_start': lastPeriodStart,
    'cycle_day': cycleDay,
    'cycle_notes': cycleNotes,
    'cravings_level': cravingsLevel,
    'cravings_notes': cravingsNotes,
    'travelled': travelled,
    'travel_notes': travelNotes,
    'wins': wins,
    'proud_moments': proudMoments,
    'struggles': struggles,
    'notes': notes,
    'extra': extra,
    'photos': photos,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}

class WeeklyMeasurements {
  final num? chest;
  final num? abdomen;
  final num? waist;
  final num? hip;
  final num? thigh;
  final num? arm;
  final String? unit;

  WeeklyMeasurements({
    this.chest,
    this.abdomen,
    this.waist,
    this.hip,
    this.thigh,
    this.arm,
    this.unit,
  });

  factory WeeklyMeasurements.fromJson(Map<String, dynamic> json) {
    return WeeklyMeasurements(
      chest: json['chest'] as num?,
      abdomen: json['abdomen'] as num?,
      waist: json['waist'] as num?,
      hip: json['hip'] as num?,
      thigh: json['thigh'] as num?,
      arm: json['arm'] as num?,
      unit: json['unit'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'chest': chest,
    'abdomen': abdomen,
    'waist': waist,
    'hip': hip,
    'thigh': thigh,
    'arm': arm,
    'unit': unit,
  };
}
