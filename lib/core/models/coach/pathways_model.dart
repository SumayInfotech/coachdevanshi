class PathwaysModel {
  bool? success;
  String? message;
  PathwaysData? data;

  PathwaysModel({this.success, this.message, this.data});

  PathwaysModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? PathwaysData.fromJson(json['data']) : null;
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

class PathwaysData {
  String? selectedPathwayUuid;
  List<PathwayGroupItem>? groups;

  PathwaysData({this.selectedPathwayUuid, this.groups});

  PathwaysData.fromJson(Map<String, dynamic> json) {
    selectedPathwayUuid = json['selected_pathway_uuid'];
    if (json['groups'] != null) {
      groups = <PathwayGroupItem>[];
      json['groups'].forEach((v) {
        groups!.add(PathwayGroupItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['selected_pathway_uuid'] = selectedPathwayUuid;
    if (groups != null) {
      data['groups'] = groups!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PathwayGroupItem {
  String? group;
  String? title;
  List<PathwayItem>? pathways;

  PathwayGroupItem({this.group, this.title, this.pathways});

  PathwayGroupItem.fromJson(Map<String, dynamic> json) {
    group = json['group'];
    title = json['title'];
    if (json['pathways'] != null) {
      pathways = <PathwayItem>[];
      json['pathways'].forEach((v) {
        pathways!.add(PathwayItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['group'] = group;
    data['title'] = title;
    if (pathways != null) {
      data['pathways'] = pathways!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PathwayItem {
  String? uuid;
  String? title;
  String? slug;
  String? group;
  String? description;
  List<String>? tags;
  String? image;
  bool? hasProtocol;
  bool? isSelected;

  PathwayItem({
    this.uuid,
    this.title,
    this.slug,
    this.group,
    this.description,
    this.tags,
    this.image,
    this.hasProtocol,
    this.isSelected,
  });

  PathwayItem.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    title = json['title'];
    slug = json['slug'];
    group = json['group'];
    description = json['description'];
    tags = json['tags'] != null ? List<String>.from(json['tags']) : null;
    image = json['image'];
    hasProtocol = json['has_protocol'];
    isSelected = json['is_selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['title'] = title;
    data['slug'] = slug;
    data['group'] = group;
    data['description'] = description;
    data['tags'] = tags;
    data['image'] = image;
    data['has_protocol'] = hasProtocol;
    data['is_selected'] = isSelected;
    return data;
  }
}
