
class ParentHomeModel {
    final String? currentCity;
    final bool? checkedIn;
    final dynamic checkedInAt;
    final String? accommodationType;
    final NextTransport? nextTransport;

    ParentHomeModel({
        this.currentCity,
        this.checkedIn,
        this.checkedInAt,
        this.accommodationType,
        this.nextTransport,
    });

    factory ParentHomeModel.fromJson(Map<String, dynamic> json) => ParentHomeModel(
        currentCity: json["currentCity"],
        checkedIn: json["checkedIn"],
        checkedInAt: json["checkedInAt"],
        accommodationType: json["accommodationType"],
        nextTransport: json["nextTransport"] == null ? null : NextTransport.fromJson(json["nextTransport"]),
    );

    Map<String, dynamic> toJson() => {
        "currentCity": currentCity,
        "checkedIn": checkedIn,
        "checkedInAt": checkedInAt,
        "accommodationType": accommodationType,
        "nextTransport": nextTransport?.toJson(),
    };
}

class NextTransport {
    final String? type;
    final String? from;
    final String? to;
    final DateTime? departureDate;
    final String? departureTime;
    final String? label;

    NextTransport({
        this.type,
        this.from,
        this.to,
        this.departureDate,
        this.departureTime,
        this.label,
    });

    factory NextTransport.fromJson(Map<String, dynamic> json) => NextTransport(
        type: json["type"],
        from: json["from"],
        to: json["to"],
        departureDate: json["departureDate"] == null ? null : DateTime.parse(json["departureDate"]),
        departureTime: json["departureTime"],
        label: json["label"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "from": from,
        "to": to,
        "departureDate": departureDate?.toIso8601String(),
        "departureTime": departureTime,
        "label": label,
    };
}
