class BloodReportsModel {
  bool? success;
  String? message;
  BloodReportsData? data;

  BloodReportsModel({this.success, this.message, this.data});

  BloodReportsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? BloodReportsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class BloodReportsData {
  List<BloodReportItem>? reports;
  BloodReportsMeta? meta;

  BloodReportsData({this.reports, this.meta});

  BloodReportsData.fromJson(Map<String, dynamic> json) {
    if (json['reports'] != null) {
      reports = <BloodReportItem>[];
      json['reports'].forEach((v) {
        reports!.add(BloodReportItem.fromJson(v));
      });
    }
    meta = json['meta'] != null ? BloodReportsMeta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (reports != null) {
      data['reports'] = reports!.map((v) => v.toJson()).toList();
    }
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    return data;
  }
}

class BloodReportItem {
  String? uuid;
  String? reportDate;
  String? notes;
  List<BloodReportFileItem>? files;
  String? createdAt;

  BloodReportItem({
    this.uuid,
    this.reportDate,
    this.notes,
    this.files,
    this.createdAt,
  });

  BloodReportItem.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    reportDate = json['report_date'];
    notes = json['notes'];
    if (json['files'] != null) {
      files = <BloodReportFileItem>[];
      json['files'].forEach((v) {
        files!.add(BloodReportFileItem.fromJson(v));
      });
    }
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['report_date'] = reportDate;
    data['notes'] = notes;
    if (files != null) {
      data['files'] = files!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    return data;
  }
}

class BloodReportFileItem {
  String? uuid;
  String? url;
  String? originalName;
  String? mimeType;
  int? size;

  BloodReportFileItem({
    this.uuid,
    this.url,
    this.originalName,
    this.mimeType,
    this.size,
  });

  BloodReportFileItem.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    url = json['url'];
    originalName = json['original_name'];
    mimeType = json['mime_type'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['url'] = url;
    data['original_name'] = originalName;
    data['mime_type'] = mimeType;
    data['size'] = size;
    return data;
  }
}

class BloodReportsMeta {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;
  int? from;
  int? to;

  BloodReportsMeta({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
    this.from,
    this.to,
  });

  BloodReportsMeta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    data['last_page'] = lastPage;
    data['per_page'] = perPage;
    data['total'] = total;
    data['from'] = from;
    data['to'] = to;
    return data;
  }
}
