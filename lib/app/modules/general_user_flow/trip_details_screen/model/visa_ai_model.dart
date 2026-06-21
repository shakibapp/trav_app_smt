

class VisaAiModel {
    final String? passport;
    final List<Destination>? destinations;
    final String? generalTips;
    final String? disclaimer;

    VisaAiModel({
        this.passport,
        this.destinations,
        this.generalTips,
        this.disclaimer,
    });

    factory VisaAiModel.fromJson(Map<String, dynamic> json) => VisaAiModel(
        passport: json["passport"],
        destinations: json["destinations"] == null ? [] : List<Destination>.from(json["destinations"]!.map((x) => Destination.fromJson(x))),
        generalTips: json["generalTips"],
        disclaimer: json["disclaimer"],
    );

    Map<String, dynamic> toJson() => {
        "passport": passport,
        "destinations": destinations == null ? [] : List<dynamic>.from(destinations!.map((x) => x.toJson())),
        "generalTips": generalTips,
        "disclaimer": disclaimer,
    };
}

class Destination {
    final String? city;
    final String? country;
    final bool? visaRequired;
    final String? visaType;
    final String? processingTime;
    final String? cost;
    final String? notes;
    final int? validityDays;

    Destination({
        this.city,
        this.country,
        this.visaRequired,
        this.visaType,
        this.processingTime,
        this.cost,
        this.notes,
        this.validityDays,
    });

    factory Destination.fromJson(Map<String, dynamic> json) => Destination(
        city: json["city"],
        country: json["country"],
        visaRequired: json["visaRequired"],
        visaType: json["visaType"],
        processingTime: json["processingTime"],
        cost: json["cost"],
        notes: json["notes"],
        validityDays: json["validityDays"],
    );

    Map<String, dynamic> toJson() => {
        "city": city,
        "country": country,
        "visaRequired": visaRequired,
        "visaType": visaType,
        "processingTime": processingTime,
        "cost": cost,
        "notes": notes,
        "validityDays": validityDays,
    };
}
