import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  final bool? success;
  final String? message;
  final dynamic meta;
  final Data? data;

  Welcome({this.success, this.message, this.meta, this.data});

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    success: json["success"],
    message: json["message"],
    meta: json["meta"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "meta": meta,
    "data": data?.toJson(),
  };
}

class Data {
  final int? total;
  final int? page;
  final int? limit;
  final List<NotificationModel>? data;

  Data({this.total, this.page, this.limit, this.data});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    total: json["total"],
    page: json["page"],
    limit: json["limit"],
    data: json["data"] == null
        ? []
        : List<NotificationModel>.from(
            json["data"]!.map((x) => NotificationModel.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "page": page,
    "limit": limit,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class NotificationModel {
  final String? id;
  final String? userId;
  final String? title;
  final String? body;
  final dynamic data;
  final bool? read;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NotificationModel({
    this.id,
    this.userId,
    this.title,
    this.body,
    this.data,
    this.read,
    this.createdAt,
    this.updatedAt,
  });

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    dynamic data,
    bool? read,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      read: read ?? this.read,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        userId: json["userId"],
        title: json["title"],
        body: json["body"],
        data: json["data"],
        read: json["read"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "title": title,
    "body": body,
    "data": data,
    "read": read,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
