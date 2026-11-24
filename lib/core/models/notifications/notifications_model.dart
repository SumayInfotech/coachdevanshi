class NotificationsModel {
  NotificationsModel({
    this.success,
    this.message,
    this.data,
  });

  final bool? success;
  final String? message;
  final NotificationsData? data;

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    return NotificationsModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] != null ? NotificationsData.fromJson(json["data"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class NotificationsData {
  NotificationsData({
    this.notifications,
    this.meta,
    this.unreadCount,
  });

  final List<NotificationItem>? notifications;
  final NotificationMeta? meta;
  final int? unreadCount;

  factory NotificationsData.fromJson(Map<String, dynamic> json) {
    return NotificationsData(
      notifications: json["notifications"] == null
          ? []
          : List<NotificationItem>.from(
              json["notifications"]!.map((x) => NotificationItem.fromJson(x)),
            ),
      meta: json["meta"] != null ? NotificationMeta.fromJson(json["meta"]) : null,
      unreadCount: json["unread_count"],
    );
  }

  Map<String, dynamic> toJson() => {
    "notifications": notifications?.map((x) => x.toJson()).toList(),
    "meta": meta?.toJson(),
    "unread_count": unreadCount,
  };
}

class NotificationItem {
  NotificationItem({
    this.uuid,
    this.type,
    this.title,
    this.body,
    this.badge,
    this.action,
    this.data,
    this.isRead,
    this.readAt,
    this.createdAt,
  });

  final String? uuid;
  final String? type;
  final String? title;
  final String? body;
  final String? badge;
  final String? action;
  final Map<String, dynamic>? data;
  bool? isRead;
  final String? readAt;
  final String? createdAt;

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      uuid: json["uuid"],
      type: json["type"],
      title: json["title"],
      body: json["body"],
      badge: json["badge"],
      action: json["action"],
      data: json["data"] is Map<String, dynamic> ? json["data"] : null,
      isRead: json["is_read"],
      readAt: json["read_at"],
      createdAt: json["created_at"],
    );
  }

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "type": type,
    "title": title,
    "body": body,
    "badge": badge,
    "action": action,
    "data": data,
    "is_read": isRead,
    "read_at": readAt,
    "created_at": createdAt,
  };
}

class NotificationMeta {
  NotificationMeta({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
    this.from,
    this.to,
  });

  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;
  final int? from;
  final int? to;

  factory NotificationMeta.fromJson(Map<String, dynamic> json) {
    return NotificationMeta(
      currentPage: json["current_page"],
      lastPage: json["last_page"],
      perPage: json["per_page"],
      total: json["total"],
      from: json["from"],
      to: json["to"],
    );
  }

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "last_page": lastPage,
    "per_page": perPage,
    "total": total,
    "from": from,
    "to": to,
  };
}
