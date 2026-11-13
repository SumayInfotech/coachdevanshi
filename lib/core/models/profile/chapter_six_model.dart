class ChapterSixModel {
  ChapterSixModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory ChapterSixModel.fromJson(Map<String, dynamic> json){
    return ChapterSixModel(
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
    this.goalMindset,
    this.goalMindsetOther,
    this.slowProgressResponse,
    this.oneChangeToStart,
    this.notReadyToChange,
    this.visionOfSuccess,
    this.openReflections,
  });

  final List<String>? goalMindset;
  final String? goalMindsetOther;
  final String? slowProgressResponse;
  final String? oneChangeToStart;
  final String? notReadyToChange;
  final String? visionOfSuccess;
  final String? openReflections;

  factory Answers.fromJson(Map<String, dynamic> json){
    return Answers(
      goalMindset: json["goal_mindset"] == null
          ? []
          : List<String>.from(json["goal_mindset"]!.map((x) => x.toString())),
      goalMindsetOther: json["goal_mindset_other"],
      slowProgressResponse: json["slow_progress_response"],
      oneChangeToStart: json["one_change_to_start"],
      notReadyToChange: json["not_ready_to_change"],
      visionOfSuccess: json["vision_of_success"],
      openReflections: json["open_reflections"],
    );
  }

  Map<String, dynamic> toJson() => {
    "goal_mindset": goalMindset,
    "goal_mindset_other": goalMindsetOther,
    "slow_progress_response": slowProgressResponse,
    "one_change_to_start": oneChangeToStart,
    "not_ready_to_change": notReadyToChange,
    "vision_of_success": visionOfSuccess,
    "open_reflections": openReflections,
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
