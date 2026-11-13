class DashboardModel {
  DashboardModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final DashboardData? data;

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : DashboardData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class DashboardData {
  DashboardData({
    required this.greeting,
    required this.name,
    required this.date,
    required this.dateLabel,
    required this.quote,
    required this.plan,
    required this.renewalRequested,
    required this.coachNote,
    required this.todayOverview,
    required this.checkins,
    required this.calendarStrip,
    required this.onboarding,
    required this.isHomeTourCompleted,
    required this.unreadNotifications,
    required this.unreadChatMessages,
  });

  final String? greeting;
  final String? name;
  final String? date;
  final String? dateLabel;
  final String? quote;
  final DashboardPlan? plan;
  final bool? renewalRequested;
  final CoachNote? coachNote;
  final TodayOverview? todayOverview;
  final DashboardCheckins? checkins;
  final List<CalendarStripItem> calendarStrip;
  final DashboardOnboarding? onboarding;
  final bool? isHomeTourCompleted;
  final int? unreadNotifications;
  final int? unreadChatMessages;

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      greeting: json["greeting"],
      name: json["name"],
      date: json["date"],
      dateLabel: json["date_label"],
      quote: json["quote"],
      plan: json["plan"] == null ? null : DashboardPlan.fromJson(json["plan"]),
      renewalRequested: json["renewal_requested"],
      coachNote: json["coach_note"] == null ? null : CoachNote.fromJson(json["coach_note"]),
      todayOverview: json["today_overview"] == null ? null : TodayOverview.fromJson(json["today_overview"]),
      checkins: json["checkins"] == null ? null : DashboardCheckins.fromJson(json["checkins"]),
      calendarStrip: json["calendar_strip"] == null
          ? []
          : List<CalendarStripItem>.from(json["calendar_strip"]!.map((x) => CalendarStripItem.fromJson(x))),
      onboarding: json["onboarding"] == null ? null : DashboardOnboarding.fromJson(json["onboarding"]),
      isHomeTourCompleted: json["is_home_tour_completed"],
      unreadNotifications: json["unread_notifications"],
      unreadChatMessages: json["unread_chat_messages"],
    );
  }

  Map<String, dynamic> toJson() => {
    "greeting": greeting,
    "name": name,
    "date": date,
    "date_label": dateLabel,
    "quote": quote,
    "plan": plan?.toJson(),
    "renewal_requested": renewalRequested,
    "coach_note": coachNote?.toJson(),
    "today_overview": todayOverview?.toJson(),
    "checkins": checkins?.toJson(),
    "calendar_strip": calendarStrip.map((x) => x.toJson()).toList(),
    "onboarding": onboarding?.toJson(),
    "is_home_tour_completed": isHomeTourCompleted,
    "unread_notifications": unreadNotifications,
    "unread_chat_messages": unreadChatMessages,
  };
}

class DashboardPlan {
  DashboardPlan({
    required this.uuid,
    required this.title,
    required this.pathway,
    required this.durationMonths,
    required this.planType,
    required this.startDate,
    required this.endDate,
    required this.endDateLabel,
    required this.daysLeft,
    required this.totalDays,
    required this.progressPercent,
    required this.status,
    required this.showRenewalCta,
  });

  final String? uuid;
  final String? title;
  final PlanPathway? pathway;
  final int? durationMonths;
  final String? planType;
  final String? startDate;
  final String? endDate;
  final String? endDateLabel;
  final int? daysLeft;
  final int? totalDays;
  final num? progressPercent;
  final String? status;
  final bool? showRenewalCta;

  factory DashboardPlan.fromJson(Map<String, dynamic> json) {
    return DashboardPlan(
      uuid: json["uuid"],
      title: json["title"],
      pathway: json["pathway"] == null ? null : PlanPathway.fromJson(json["pathway"]),
      durationMonths: json["duration_months"],
      planType: json["plan_type"],
      startDate: json["start_date"],
      endDate: json["end_date"],
      endDateLabel: json["end_date_label"],
      daysLeft: json["days_left"],
      totalDays: json["total_days"],
      progressPercent: json["progress_percent"],
      status: json["status"],
      showRenewalCta: json["show_renewal_cta"],
    );
  }

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "title": title,
    "pathway": pathway?.toJson(),
    "duration_months": durationMonths,
    "plan_type": planType,
    "start_date": startDate,
    "end_date": endDate,
    "end_date_label": endDateLabel,
    "days_left": daysLeft,
    "total_days": totalDays,
    "progress_percent": progressPercent,
    "status": status,
    "show_renewal_cta": showRenewalCta,
  };
}

class PlanPathway {
  PlanPathway({
    required this.uuid,
    required this.title,
  });

  final String? uuid;
  final String? title;

  factory PlanPathway.fromJson(Map<String, dynamic> json) {
    return PlanPathway(
      uuid: json["uuid"],
      title: json["title"],
    );
  }

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "title": title,
  };
}

class TodayOverview {
  TodayOverview({
    required this.steps,
    required this.stepsSource,
    required this.stepsSyncedAt,
    required this.isHealthConnected,
    required this.healthSource,
    required this.weight,
  });

  final dynamic steps;
  final String? stepsSource;
  final String? stepsSyncedAt;
  final bool? isHealthConnected;
  final String? healthSource;
  final Weight? weight;

  factory TodayOverview.fromJson(Map<String, dynamic> json) {
    return TodayOverview(
      steps: json["steps"],
      stepsSource: json["steps_source"],
      stepsSyncedAt: json["steps_synced_at"],
      isHealthConnected: json["is_health_connected"],
      healthSource: json["health_source"],
      // weight: json["weight"],
      weight: json["weight"] == null ? null : Weight.fromJson(json["weight"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "steps": steps,
    "steps_source": stepsSource,
    "steps_synced_at": stepsSyncedAt,
    "is_health_connected": isHealthConnected,
    "health_source": healthSource,
    "weight": weight?.toJson(),
  };
}

class DashboardCheckins {
  DashboardCheckins({
    required this.micro,
    required this.weekly,
    required this.baseline,
  });

  final MicroCheckin? micro;
  final WeeklyCheckin? weekly;
  final BaselineCheckin? baseline;

  factory DashboardCheckins.fromJson(Map<String, dynamic> json) {
    return DashboardCheckins(
      micro: json["micro"] == null ? null : MicroCheckin.fromJson(json["micro"]),
      weekly: json["weekly"] == null ? null : WeeklyCheckin.fromJson(json["weekly"]),
      baseline: json["baseline"] == null ? null : BaselineCheckin.fromJson(json["baseline"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "micro": micro?.toJson(),
    "weekly": weekly?.toJson(),
    "baseline": baseline?.toJson(),
  };
}

class MicroCheckin {
  MicroCheckin({
    required this.status,
    required this.isDone,
    required this.checkinUuid,
    required this.date,
  });

  final String? status;
  final bool? isDone;
  final String? checkinUuid;
  final String? date;

  factory MicroCheckin.fromJson(Map<String, dynamic> json) {
    return MicroCheckin(
      status: json["status"],
      isDone: json["is_done"],
      checkinUuid: json["checkin_uuid"],
      date: json["date"],
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "is_done": isDone,
    "checkin_uuid": checkinUuid,
    "date": date,
  };
}

class WeeklyCheckin {
  WeeklyCheckin({
    required this.status,
    required this.isDue,
    required this.isSubmitted,
    required this.submittedUuid,
    required this.dueDay,
    required this.dueDate,
    required this.weekStart,
    required this.weekEnd,
  });

  final String? status;
  final bool? isDue;
  final bool? isSubmitted;
  final String? submittedUuid;
  final String? dueDay;
  final String? dueDate;
  final String? weekStart;
  final String? weekEnd;

  factory WeeklyCheckin.fromJson(Map<String, dynamic> json) {
    return WeeklyCheckin(
      status: json["status"],
      isDue: json["is_due"],
      isSubmitted: json["is_submitted"],
      submittedUuid: json["submitted_uuid"],
      dueDay: json["due_day"],
      dueDate: json["due_date"],
      weekStart: json["week_start"],
      weekEnd: json["week_end"],
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "is_due": isDue,
    "is_submitted": isSubmitted,
    "submitted_uuid": submittedUuid,
    "due_day": dueDay,
    "due_date": dueDate,
    "week_start": weekStart,
    "week_end": weekEnd,
  };
}

class BaselineCheckin {
  BaselineCheckin({
    required this.completedDays,
    required this.completed,
    required this.total,
    required this.nextDay,
    required this.isCompleted,
  });

  final List<dynamic> completedDays;
  final int? completed;
  final int? total;
  final int? nextDay;
  final bool? isCompleted;

  factory BaselineCheckin.fromJson(Map<String, dynamic> json) {
    return BaselineCheckin(
      completedDays: json["completed_days"] == null ? [] : List<dynamic>.from(json["completed_days"]!),
      completed: json["completed"],
      total: json["total"],
      nextDay: json["next_day"],
      isCompleted: json["is_completed"],
    );
  }

  Map<String, dynamic> toJson() => {
    "completed_days": completedDays,
    "completed": completed,
    "total": total,
    "next_day": nextDay,
    "is_completed": isCompleted,
  };
}

class CalendarStripItem {
  CalendarStripItem({
    required this.date,
    required this.day,
    required this.dayNumber,
    required this.isToday,
    required this.hasDailyCheckin,
  });

  final String? date;
  final String? day;
  final int? dayNumber;
  final bool? isToday;
  final bool? hasDailyCheckin;

  factory CalendarStripItem.fromJson(Map<String, dynamic> json) {
    return CalendarStripItem(
      date: json["date"],
      day: json["day"],
      dayNumber: json["day_number"],
      isToday: json["is_today"],
      hasDailyCheckin: json["has_daily_checkin"],
    );
  }

  Map<String, dynamic> toJson() => {
    "date": date,
    "day": day,
    "day_number": dayNumber,
    "is_today": isToday,
    "has_daily_checkin": hasDailyCheckin,
  };
}

class DashboardOnboarding {
  DashboardOnboarding({
    required this.isCompleted,
    required this.completedChapters,
    required this.totalChapters,
    required this.pathway,
    required this.protocolStatus,
  });

  final bool? isCompleted;
  final int? completedChapters;
  final int? totalChapters;
  final dynamic pathway;
  final dynamic protocolStatus;

  factory DashboardOnboarding.fromJson(Map<String, dynamic> json) {
    return DashboardOnboarding(
      isCompleted: json["is_completed"],
      completedChapters: json["completed_chapters"],
      totalChapters: json["total_chapters"],
      pathway: json["pathway"],
      protocolStatus: json["protocol_status"],
    );
  }

  Map<String, dynamic> toJson() => {
    "is_completed": isCompleted,
    "completed_chapters": completedChapters,
    "total_chapters": totalChapters,
    "pathway": pathway,
    "protocol_status": protocolStatus,
  };
}

class CoachNote {
  CoachNote({
    required this.uuid,
    required this.note,
    required this.createdAt,
  });

  final String? uuid;
  final String? note;
  final String? createdAt;

  factory CoachNote.fromJson(Map<String, dynamic> json){
    return CoachNote(
      uuid: json["uuid"],
      note: json["note"],
      createdAt: json["created_at"],
    );
  }

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "note": note,
    "created_at": createdAt,
  };

}

class Weight {
  Weight({
    required this.current,
    required this.unit,
    required this.recordedOn,
    required this.source,
    required this.isRecordedToday,
    required this.change,
    required this.trend,
  });

  final int? current;
  final String? unit;
  final String? recordedOn;
  final String? source;
  final bool? isRecordedToday;
  final dynamic change;
  final dynamic trend;

  factory Weight.fromJson(Map<String, dynamic> json){
    return Weight(
      current: json["current"],
      unit: json["unit"],
      recordedOn: json["recorded_on"],
      source: json["source"],
      isRecordedToday: json["is_recorded_today"],
      change: json["change"],
      trend: json["trend"],
    );
  }

  Map<String, dynamic> toJson() => {
    "current": current,
    "unit": unit,
    "recorded_on": recordedOn,
    "source": source,
    "is_recorded_today": isRecordedToday,
    "change": change,
    "trend": trend,
  };
}