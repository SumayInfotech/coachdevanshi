class LocationModel {
  LocationModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final List<LocationData> data;

  factory LocationModel.fromJson(Map<String, dynamic> json){
    return LocationModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? [] : List<LocationData>.from(json["data"]!.map((x) => LocationData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.map((x) => x.toJson()).toList(),
  };

}

class LocationData {
  LocationData({
    required this.id,
    required this.name,
    required this.stateId,
  });

  final int? id;
  final String? name;
  final int? stateId;

  factory LocationData.fromJson(Map<String, dynamic> json){
    return LocationData(
      id: json["id"],
      name: json["name"],
      stateId: json["state_id"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "state_id": stateId,
  };

}
