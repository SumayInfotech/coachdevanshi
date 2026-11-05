class ChapterOneModel {
  ChapterOneModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory ChapterOneModel.fromJson(Map<String, dynamic> json){
    return ChapterOneModel(
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
    required this.email,
    required this.fullName,
    required this.nickname,
    required this.phoneCode,
    required this.mobile,
    required this.dob,
    required this.gender,
    required this.city,
    required this.country,
    required this.timezone,
    required this.dailyRhythm,
    required this.coachingJourney,
  });

  final String? email;
  final String? fullName;
  final String? nickname;
  final String? phoneCode;
  final String? mobile;
  final DateTime? dob;
  final String? gender;
  final String? city;
  final String? country;
  final String? timezone;
  final String? dailyRhythm;
  final String? coachingJourney;

  factory Answers.fromJson(Map<String, dynamic> json){
    return Answers(
      email: json["email"],
      fullName: json["full_name"],
      nickname: json["nickname"],
      phoneCode: json["phone_code"],
      mobile: json["mobile"],
      dob: DateTime.tryParse(json["dob"] ?? ""),
      gender: json["gender"],
      city: json["city"],
      country: json["country"],
      timezone: json["timezone"],
      dailyRhythm: json["daily_rhythm"],
      coachingJourney: json["coaching_journey"],
    );
  }

  Map<String, dynamic> toJson() => {
    "email": email,
    "full_name": fullName,
    "nickname": nickname,
    "phone_code": phoneCode,
    "mobile": mobile,
    "dob": "${dob?.year.toString().padLeft(4, '0')}-${dob?.month.toString().padLeft(2, '0')}-${dob?.day.toString().padLeft(2, '0')}",
    "gender": gender,
    "city": city,
    "country": country,
    "timezone": timezone,
    "daily_rhythm": dailyRhythm,
    "coaching_journey": coachingJourney,
  };

}

class Field {
  Field({
    required this.key,
    required this.label,
    required this.type,
    required this.required,
    required this.max,
    required this.options,
    required this.min,
  });

  final String? key;
  final String? label;
  final String? type;
  final bool? required;
  final int? max;
  final List<Option> options;
  final int? min;

  factory Field.fromJson(Map<String, dynamic> json){
    return Field(
      key: json["key"],
      label: json["label"],
      type: json["type"],
      required: json["required"],
      max: json["max"],
      options: json["options"] == null ? [] : List<Option>.from(json["options"]!.map((x) => Option.fromJson(x))),
      min: json["min"],
    );
  }

  Map<String, dynamic> toJson() => {
    "key": key,
    "label": label,
    "type": type,
    "required": required,
    "max": max,
    "options": options.map((x) => x.toJson()).toList(),
    "min": min,
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
  final String? image;

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
