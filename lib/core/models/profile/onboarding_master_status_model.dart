class OnboardingMasterStatusModel {
  OnboardingMasterStatusModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory OnboardingMasterStatusModel.fromJson(Map<String, dynamic> json){
    return OnboardingMasterStatusModel(
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
    required this.isOnboardingCompleted,
    required this.completedChapters,
    required this.totalChapters,
    required this.chapters,
    required this.consent,
    required this.pathway,
    required this.protocolStatus,
  });

  final bool? isOnboardingCompleted;
  final int? completedChapters;
  final int? totalChapters;
  final List<Chapter> chapters;
  final Consent? consent;
  final dynamic pathway;
  final dynamic protocolStatus;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      isOnboardingCompleted: json["is_onboarding_completed"],
      completedChapters: json["completed_chapters"],
      totalChapters: json["total_chapters"],
      chapters: json["chapters"] == null ? [] : List<Chapter>.from(json["chapters"]!.map((x) => Chapter.fromJson(x))),
      consent: json["consent"] == null ? null : Consent.fromJson(json["consent"]),
      pathway: json["pathway"],
      protocolStatus: json["protocol_status"],
    );
  }

  Map<String, dynamic> toJson() => {
    "is_onboarding_completed": isOnboardingCompleted,
    "completed_chapters": completedChapters,
    "total_chapters": totalChapters,
    "chapters": chapters.map((x) => x?.toJson()).toList(),
    "consent": consent?.toJson(),
    "pathway": pathway,
    "protocol_status": protocolStatus,
  };

}

class Chapter {
  Chapter({
    required this.chapter,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.completedAt,
  });

  final int? chapter;
  final String? title;
  final String? subtitle;
  final String? status;
  final dynamic completedAt;

  factory Chapter.fromJson(Map<String, dynamic> json){
    return Chapter(
      chapter: json["chapter"],
      title: json["title"],
      subtitle: json["subtitle"],
      status: json["status"],
      completedAt: json["completed_at"],
    );
  }

  Map<String, dynamic> toJson() => {
    "chapter": chapter,
    "title": title,
    "subtitle": subtitle,
    "status": status,
    "completed_at": completedAt,
  };

}

class Consent {
  Consent({
    required this.isAccepted,
    required this.acceptedAt,
    required this.items,
  });

  final bool? isAccepted;
  final dynamic acceptedAt;
  final List<Item> items;

  factory Consent.fromJson(Map<String, dynamic> json){
    return Consent(
      isAccepted: json["is_accepted"],
      acceptedAt: json["accepted_at"],
      items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "is_accepted": isAccepted,
    "accepted_at": acceptedAt,
    "items": items.map((x) => x?.toJson()).toList(),
  };

}

class Item {
  Item({
    required this.key,
    required this.label,
    required this.required,
    required this.accepted,
  });

  final String? key;
  final String? label;
  final bool? required;
  final bool? accepted;

  factory Item.fromJson(Map<String, dynamic> json){
    return Item(
      key: json["key"],
      label: json["label"],
      required: json["required"],
      accepted: json["accepted"],
    );
  }

  Map<String, dynamic> toJson() => {
    "key": key,
    "label": label,
    "required": required,
    "accepted": accepted,
  };

}
