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
    required this.uuid,
    required this.type,
    required this.user,
  });

  final String? token;
  final String? uuid;
  final String? type;
  final UserData? user;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      token: json["token"],
      uuid: json["uuid"],
      type: json["type"],
      user: json["user"] == null ? null : UserData.fromJson(json["user"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "token": token,
    "uuid": uuid,
    "type": type,
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
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? uuid;
  final String? name;
  final dynamic lastName;
  final String? email;
  final String? phoneCode;
  final String? mobile;
  final bool? isEmailVerified;
  final String? emailVerifiedAt;
  final dynamic profileImage;
  final bool? isProfileCompleted;
  final String? signUpThrough;
  final String? signUpType;
  final bool? isSignup;
  final bool? isSocial;
  final dynamic stateId;
  final dynamic stateName;
  final dynamic cityId;
  final dynamic cityName;
  final bool? emailNotification;
  final bool? smsNotification;
  final bool? whatsappNotification;
  final String? language;
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
    "created_at": createdAt,
    "updated_at": updatedAt,
  };

}
