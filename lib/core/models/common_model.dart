class CommonModel {
  CommonModel({
    required this.success,
    required this.message,
  });

  final bool? success;
  final String? message;

  factory CommonModel.fromJson(Map<String, dynamic> json){
    return CommonModel(
      success: json["success"],
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };

}
