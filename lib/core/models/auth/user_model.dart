class UserModel {
  UserModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
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
    required this.token,
    required this.user,
  });

  final dynamic token;
  final UserData? user;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      token: json["token"],
      user: json["user"] == null ? null : UserData.fromJson(json["user"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "token": token,
    "user": user?.toJson(),
  };

}

class UserData {
  UserData({
    required this.id,
    required this.uuid,
    required this.name,
    required this.lastName,
    required this.email,
    required this.phoneCode,
    required this.mobile,
    required this.isEmailVerified,
    required this.emailVerifiedAt,
    required this.profileImage,
    required this.isProfileCompleted,
    required this.signUpThrough,
    required this.signUpType,
    required this.isSignup,
    required this.isSocial,
    required this.stateId,
    required this.stateName,
    required this.cityId,
    required this.cityName,
    required this.emailNotification,
    required this.smsNotification,
    required this.whatsappNotification,
    required this.language,
    required this.nickname,
    required this.dob,
    required this.gender,
    required this.countryName,
    required this.timezone,
    required this.weeklyCheckinDay,
    required this.pushNotification,
    required this.healthSource,
    required this.isHealthConnected,
    required this.isHomeTourCompleted,
    required this.isOnboardingCompleted,
    required this.pathwayUuid,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? uuid;
  final String? name;
  final String? lastName;
  final String? email;
  final String? phoneCode;
  final String? mobile;
  final bool? isEmailVerified;
  final String? emailVerifiedAt;
  final String? profileImage;
  final bool? isProfileCompleted;
  final String? signUpThrough;
  final String? signUpType;
  final bool? isSignup;
  final bool? isSocial;
  final int? stateId;
  final String? stateName;
  final int? cityId;
  final String? cityName;
  final bool? emailNotification;
  final bool? smsNotification;
  final bool? whatsappNotification;
  final String? language;
  final String? nickname;
  final DateTime? dob;
  final String? gender;
  final String? countryName;
  final String? timezone;
  final String? weeklyCheckinDay;
  final bool? pushNotification;
  final String? healthSource;
  final bool? isHealthConnected;
  final bool? isHomeTourCompleted;
  final bool? isOnboardingCompleted;
  final String? pathwayUuid;
  final String? createdAt;
  final String? updatedAt;

  factory UserData.fromJson(Map<String, dynamic> json){
    return UserData(
      id: json["id"],
      uuid: json["uuid"],
      name: json["name"],
      lastName: json["last_name"],
      email: json["email"],
      phoneCode: json["phone_code"],
      mobile: json["mobile"],
      isEmailVerified: json["is_email_verified"],
      emailVerifiedAt: json["email_verified_at"],
      profileImage: json["profile_image"],
      isProfileCompleted: json["is_profile_completed"],
      signUpThrough: json["sign_up_through"],
      signUpType: json["sign_up_type"],
      isSignup: json["is_signup"],
      isSocial: json["is_social"],
      stateId: json["state_id"],
      stateName: json["state_name"],
      cityId: json["city_id"],
      cityName: json["city_name"],
      emailNotification: json["email_notification"],
      smsNotification: json["sms_notification"],
      whatsappNotification: json["whatsapp_notification"],
      language: json["language"],
      nickname: json["nickname"],
      dob: DateTime.tryParse(json["dob"] ?? ""),
      gender: json["gender"],
      countryName: json["country_name"],
      timezone: json["timezone"],
      weeklyCheckinDay: json["weekly_checkin_day"],
      pushNotification: json["push_notification"],
      healthSource: json["health_source"],
      isHealthConnected: json["is_health_connected"],
      isHomeTourCompleted: json["is_home_tour_completed"],
      isOnboardingCompleted: json["is_onboarding_completed"],
      pathwayUuid: json["pathway_uuid"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "uuid": uuid,
    "name": name,
    "last_name": lastName,
    "email": email,
    "phone_code": phoneCode,
    "mobile": mobile,
    "is_email_verified": isEmailVerified,
    "email_verified_at": emailVerifiedAt,
    "profile_image": profileImage,
    "is_profile_completed": isProfileCompleted,
    "sign_up_through": signUpThrough,
    "sign_up_type": signUpType,
    "is_signup": isSignup,
    "is_social": isSocial,
    "state_id": stateId,
    "state_name": stateName,
    "city_id": cityId,
    "city_name": cityName,
    "email_notification": emailNotification,
    "sms_notification": smsNotification,
    "whatsapp_notification": whatsappNotification,
    "language": language,
    "nickname": nickname,
    "dob": "${dob?.year.toString().padLeft(4,'0')}-${dob?.month.toString().padLeft(2,'0')}-${dob?.day.toString().padLeft(2,'0')}",
    "gender": gender,
    "country_name": countryName,
    "timezone": timezone,
    "weekly_checkin_day": weeklyCheckinDay,
    "push_notification": pushNotification,
    "health_source": healthSource,
    "is_health_connected": isHealthConnected,
    "is_home_tour_completed": isHomeTourCompleted,
    "is_onboarding_completed": isOnboardingCompleted,
    "pathway_uuid": pathwayUuid,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };

}
