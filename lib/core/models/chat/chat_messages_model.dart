import 'dart:io';

class ChatMessagesModel {
  bool? success;
  String? message;
  ChatMessagesData? data;

  ChatMessagesModel({this.success, this.message, this.data});

  factory ChatMessagesModel.fromJson(Map<String, dynamic> json) {
    return ChatMessagesModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? ChatMessagesData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> res = {};
    res['success'] = success;
    res['message'] = message;
    if (data != null) {
      res['data'] = data!.toJson();
    }
    return res;
  }
}

class ChatMessagesData {
  List<ChatMessageItem>? messages;
  ChatMeta? meta;

  ChatMessagesData({this.messages, this.meta});

  factory ChatMessagesData.fromJson(dynamic json) {
    if (json is List) {
      return ChatMessagesData(
        messages: json.map((x) => ChatMessageItem.fromJson(x)).toList(),
        meta: null,
      );
    } else if (json is Map<String, dynamic>) {
      List<ChatMessageItem> items = [];
      final rawList = json['messages'] ?? json['data'] ?? json['items'];
      if (rawList is List) {
        items = rawList.map((x) => ChatMessageItem.fromJson(x)).toList();
      }
      return ChatMessagesData(
        messages: items,
        meta: json['meta'] != null ? ChatMeta.fromJson(json['meta']) : null,
      );
    }
    return ChatMessagesData(messages: [], meta: null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> res = {};
    if (messages != null) {
      res['messages'] = messages!.map((x) => x.toJson()).toList();
    }
    if (meta != null) {
      res['meta'] = meta!.toJson();
    }
    return res;
  }
}

class ChatMessageItem {
  dynamic id;
  String? uuid;
  String? senderType;
  String? senderName;
  bool? isMine;
  bool? isMe;
  String? message;
  List<ChatAttachmentItem>? attachments;
  bool? isRead;
  String? createdAt;
  String? readAt;
  dynamic senderId;
  ChatSenderItem? sender;

  // Local/UI helper fields
  bool isSending;
  bool hasError;
  List<File>? localAttachments;

  ChatMessageItem({
    this.id,
    this.uuid,
    this.senderType,
    this.senderName,
    this.isMine,
    this.isMe,
    this.message,
    this.attachments,
    this.isRead,
    this.createdAt,
    this.readAt,
    this.senderId,
    this.sender,
    this.isSending = false,
    this.hasError = false,
    this.localAttachments,
  });

  factory ChatMessageItem.fromJson(Map<String, dynamic> json) {
    List<ChatAttachmentItem> parsedAttachments = [];
    final rawAttachments = json['attachments'] ?? json['files'] ?? json['images'];
    if (rawAttachments is List) {
      for (var item in rawAttachments) {
        if (item is Map<String, dynamic>) {
          parsedAttachments.add(ChatAttachmentItem.fromJson(item));
        } else if (item is String) {
          parsedAttachments.add(ChatAttachmentItem(url: item));
        }
      }
    }

    // Determine if sent by client/user (is_mine takes priority)
    bool resolvedIsMine = false;
    if (json['is_mine'] != null) {
      resolvedIsMine = json['is_mine'] == true || json['is_mine'] == 1 || json['is_mine'] == '1';
    } else if (json['is_me'] != null) {
      resolvedIsMine = json['is_me'] == true || json['is_me'] == 1 || json['is_me'] == '1';
    } else if (json['sender_type'] != null) {
      final sType = json['sender_type'].toString().toLowerCase().trim();
      resolvedIsMine = sType == 'user' || sType == 'client';
    }

    return ChatMessageItem(
      id: json['id'],
      uuid: json['uuid']?.toString(),
      senderType: json['sender_type']?.toString(),
      senderName: json['sender_name']?.toString(),
      isMine: resolvedIsMine,
      isMe: resolvedIsMine,
      message: (json['message'] ?? json['text'] ?? json['body'] ?? json['content'])?.toString(),
      attachments: parsedAttachments,
      isRead: json['is_read'] != null
          ? (json['is_read'] == true || json['is_read'] == 1 || json['is_read'] == '1')
          : null,
      createdAt: json['created_at']?.toString(),
      readAt: json['read_at']?.toString(),
      senderId: json['sender_id'] ?? json['user_id'],
      sender: json['sender'] != null && json['sender'] is Map<String, dynamic>
          ? ChatSenderItem.fromJson(json['sender'])
          : (json['sender_name'] != null ? ChatSenderItem(name: json['sender_name']?.toString()) : null),
      isSending: false,
      hasError: false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> res = {};
    if (id != null) res['id'] = id;
    res['uuid'] = uuid;
    res['sender_type'] = senderType;
    res['sender_name'] = senderName;
    res['is_mine'] = isMine ?? isMe;
    res['is_me'] = isMe ?? isMine;
    if (senderId != null) res['sender_id'] = senderId;
    res['message'] = message;
    if (attachments != null) {
      res['attachments'] = attachments!.map((x) => x.toJson()).toList();
    }
    if (isRead != null) res['is_read'] = isRead;
    if (sender != null) res['sender'] = sender!.toJson();
    res['created_at'] = createdAt;
    if (readAt != null) res['read_at'] = readAt;
    return res;
  }
}

class ChatAttachmentItem {
  dynamic id;
  String? uuid;
  String? url;
  String? originalName;
  String? mimeType;
  int? size;

  ChatAttachmentItem({
    this.id,
    this.uuid,
    this.url,
    this.originalName,
    this.mimeType,
    this.size,
  });

  factory ChatAttachmentItem.fromJson(Map<String, dynamic> json) {
    return ChatAttachmentItem(
      id: json['id'],
      uuid: json['uuid']?.toString(),
      url: (json['url'] ?? json['file_url'] ?? json['path'])?.toString(),
      originalName: (json['original_name'] ?? json['file_name'] ?? json['name'])?.toString(),
      mimeType: (json['mime_type'] ?? json['type'])?.toString(),
      size: json['size'] is int ? json['size'] : int.tryParse(json['size']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> res = {};
    res['id'] = id;
    res['uuid'] = uuid;
    res['url'] = url;
    res['original_name'] = originalName;
    res['mime_type'] = mimeType;
    res['size'] = size;
    return res;
  }
}

class ChatSenderItem {
  dynamic id;
  String? name;
  String? avatar;
  String? role;

  ChatSenderItem({this.id, this.name, this.avatar, this.role});

  factory ChatSenderItem.fromJson(Map<String, dynamic> json) {
    return ChatSenderItem(
      id: json['id'],
      name: json['name']?.toString(),
      avatar: (json['avatar'] ?? json['profile_image'] ?? json['image'])?.toString(),
      role: json['role']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> res = {};
    res['id'] = id;
    res['name'] = name;
    res['avatar'] = avatar;
    res['role'] = role;
    return res;
  }
}

class ChatMeta {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;
  int? from;
  int? to;

  ChatMeta({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
    this.from,
    this.to,
  });

  factory ChatMeta.fromJson(Map<String, dynamic> json) {
    return ChatMeta(
      currentPage: json['current_page'] is int
          ? json['current_page']
          : int.tryParse(json['current_page']?.toString() ?? ''),
      lastPage: json['last_page'] is int
          ? json['last_page']
          : int.tryParse(json['last_page']?.toString() ?? ''),
      perPage: json['per_page'] is int
          ? json['per_page']
          : int.tryParse(json['per_page']?.toString() ?? ''),
      total: json['total'] is int
          ? json['total']
          : int.tryParse(json['total']?.toString() ?? ''),
      from: json['from'] is int
          ? json['from']
          : int.tryParse(json['from']?.toString() ?? ''),
      to: json['to'] is int
          ? json['to']
          : int.tryParse(json['to']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> res = {};
    res['current_page'] = currentPage;
    res['last_page'] = lastPage;
    res['per_page'] = perPage;
    res['total'] = total;
    res['from'] = from;
    res['to'] = to;
    return res;
  }
}
