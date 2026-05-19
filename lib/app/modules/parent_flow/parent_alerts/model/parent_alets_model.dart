
class ParentAlertModel {
  final String? alertId;
  final String? type;
  final String? summary;
  final String? detail;
  final String? reason;
  final String? response;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ParentAlertModel({
    this.alertId,
    this.type,
    this.summary,
    this.detail,
    this.reason,
    this.response,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ParentAlertModel.fromJson(Map<String, dynamic> json) =>
      ParentAlertModel(
        alertId: json["alertId"],
        type: json["type"],
        summary: json["summary"],
        detail: json["detail"],
        reason: json["reason"],
        response: json["response"],
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  bool get isUnread => status == "Unread";
}