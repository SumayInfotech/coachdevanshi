class SignUpModel {
  SignUpModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory SignUpModel.fromJson(Map<String, dynamic> json){
    return SignUpModel(
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
    required this.otp,
    required this.expiresIn,
    required this.uuid,
    required this.mobile,
    required this.phoneCode,
    required this.email,
  });

  final String? otp;
  final int? expiresIn;
  final String? uuid;
  final String? mobile;
  final String? phoneCode;
  final String? email;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      otp: json["otp"],
      expiresIn: json["expires_in"],
      uuid: json["uuid"],
      mobile: json["mobile"],
      phoneCode: json["phone_code"],
      email: json["email"],
    );
  }

  Map<String, dynamic> toJson() => {
    "otp": otp,
    "expires_in": expiresIn,
    "uuid": uuid,
    "mobile": mobile,
    "phone_code": phoneCode,
    "email": email,
  };

}
