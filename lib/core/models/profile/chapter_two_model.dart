class ChapterTwoModel {
  ChapterTwoModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory ChapterTwoModel.fromJson(Map<String, dynamic> json){
    return ChapterTwoModel(
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
    this.height,
    this.heightUnit,
    this.weight,
    this.weightUnit,
    this.approachesTried,
    this.approachesLearning,
    this.confidentAreas,
    this.confusingAreas,
    this.whatHelped,
  });

  final dynamic height;
  final String? heightUnit;
  final dynamic weight;
  final String? weightUnit;
  final List<String>? approachesTried;
  final String? approachesLearning;
  final List<String>? confidentAreas;
  final String? confusingAreas;
  final String? whatHelped;

  factory Answers.fromJson(Map<String, dynamic> json){
    return Answers(
      height: json["height"],
      heightUnit: json["height_unit"],
      weight: json["weight"],
      weightUnit: json["weight_unit"],
      approachesTried: json["approaches_tried"] == null ? [] : List<String>.from(json["approaches_tried"]!.map((x) => x.toString())),
      approachesLearning: json["approaches_learning"],
      confidentAreas: json["confident_areas"] == null ? [] : List<String>.from(json["confident_areas"]!.map((x) => x.toString())),
      confusingAreas: json["confusing_areas"],
      whatHelped: json["what_helped"],
    );
  }

  Map<String, dynamic> toJson() => {
    "height": height,
    "height_unit": heightUnit,
    "weight": weight,
    "weight_unit": weightUnit,
    "approaches_tried": approachesTried,
    "approaches_learning": approachesLearning,
    "confident_areas": confidentAreas,
    "confusing_areas": confusingAreas,
    "what_helped": whatHelped,
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
