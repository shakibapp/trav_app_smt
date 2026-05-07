
class SingleActivityModel {
    final String? id;
    final String? itineraryId;
    final String? name;
    final int? dayNumber;
    final List<String>? type;
    final DateTime? startDate;
    final DateTime? endDate;
    final String? startTime;
    final String? endTime;
    final String? location;
    final int? expense;
    final String? status;
    final dynamic rating;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    SingleActivityModel({
        this.id,
        this.itineraryId,
        this.name,
        this.dayNumber,
        this.type,
        this.startDate,
        this.endDate,
        this.startTime,
        this.endTime,
        this.location,
        this.expense,
        this.status,
        this.rating,
        this.createdAt,
        this.updatedAt,
    });

    factory SingleActivityModel.fromJson(Map<String, dynamic> json) => SingleActivityModel(
        id: json["id"],
        itineraryId: json["itineraryId"],
        name: json["name"],
        dayNumber: json["dayNumber"],
        type: json["type"] == null ? [] : List<String>.from(json["type"]!.map((x) => x)),
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
        endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        startTime: json["startTime"],
        endTime: json["endTime"],
        location: json["location"],
        expense: json["expense"],
        status: json["status"],
        rating: json["rating"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "itineraryId": itineraryId,
        "name": name,
        "dayNumber": dayNumber,
        "type": type == null ? [] : List<dynamic>.from(type!.map((x) => x)),
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "startTime": startTime,
        "endTime": endTime,
        "location": location,
        "expense": expense,
        "status": status,
        "rating": rating,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}
