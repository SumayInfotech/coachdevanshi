class ProgressPhotosModel {
  final bool? success;
  final String? message;
  final ProgressPhotosData? data;

  ProgressPhotosModel({
    this.success,
    this.message,
    this.data,
  });

  factory ProgressPhotosModel.fromJson(Map<String, dynamic> json) {
    return ProgressPhotosModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? ProgressPhotosData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data?.toJson(),
  };
}

class ProgressPhotosData {
  final List<ProgressPhotoItem>? photos;
  final ProgressPhotosMeta? meta;

  ProgressPhotosData({
    this.photos,
    this.meta,
  });

  factory ProgressPhotosData.fromJson(Map<String, dynamic> json) {
    return ProgressPhotosData(
      photos: json['photos'] != null && json['photos'] is List
          ? (json['photos'] as List)
              .map((e) => ProgressPhotoItem.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      meta: json['meta'] != null && json['meta'] is Map<String, dynamic>
          ? ProgressPhotosMeta.fromJson(json['meta'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'photos': photos?.map((e) => e.toJson()).toList(),
    'meta': meta?.toJson(),
  };
}

class ProgressPhotoItem {
  final String? uuid;
  final String? recordDate;
  final ProgressPhotoFile? frontPhoto;
  final ProgressPhotoFile? sidePhoto;
  final ProgressPhotoFile? backPhoto;
  final List<dynamic>? extraPhotos;
  final bool? consent;
  final String? createdAt;

  ProgressPhotoItem({
    this.uuid,
    this.recordDate,
    this.frontPhoto,
    this.sidePhoto,
    this.backPhoto,
    this.extraPhotos,
    this.consent,
    this.createdAt,
  });

  factory ProgressPhotoItem.fromJson(Map<String, dynamic> json) {
    return ProgressPhotoItem(
      uuid: json['uuid'] as String?,
      recordDate: json['record_date'] as String?,
      frontPhoto: json['front_photo'] != null && json['front_photo'] is Map<String, dynamic>
          ? ProgressPhotoFile.fromJson(json['front_photo'])
          : null,
      sidePhoto: json['side_photo'] != null && json['side_photo'] is Map<String, dynamic>
          ? ProgressPhotoFile.fromJson(json['side_photo'])
          : null,
      backPhoto: json['back_photo'] != null && json['back_photo'] is Map<String, dynamic>
          ? ProgressPhotoFile.fromJson(json['back_photo'])
          : null,
      extraPhotos: json['extra_photos'] as List<dynamic>?,
      consent: json['consent'] as bool?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'record_date': recordDate,
    'front_photo': frontPhoto?.toJson(),
    'side_photo': sidePhoto?.toJson(),
    'back_photo': backPhoto?.toJson(),
    'extra_photos': extraPhotos,
    'consent': consent,
    'created_at': createdAt,
  };
}

class ProgressPhotoFile {
  final String? path;
  final String? url;

  ProgressPhotoFile({
    this.path,
    this.url,
  });

  factory ProgressPhotoFile.fromJson(Map<String, dynamic> json) {
    return ProgressPhotoFile(
      path: json['path'] as String?,
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'path': path,
    'url': url,
  };
}

class ProgressPhotosMeta {
  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;
  final int? from;
  final int? to;

  ProgressPhotosMeta({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
    this.from,
    this.to,
  });

  factory ProgressPhotosMeta.fromJson(Map<String, dynamic> json) {
    return ProgressPhotosMeta(
      currentPage: json['current_page'] as int?,
      lastPage: json['last_page'] as int?,
      perPage: json['per_page'] as int?,
      total: json['total'] as int?,
      from: json['from'] as int?,
      to: json['to'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    'last_page': lastPage,
    'per_page': perPage,
    'total': total,
    'from': from,
    'to': to,
  };
}
