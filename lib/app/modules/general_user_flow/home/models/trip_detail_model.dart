

class TripDetailModel {
    final String? id;
    final String? userId;
    final List<String>? region;
    final List<String>? city;
    final DateTime? startDate;
    final DateTime? endDate;
    final int? totalDays;
    final List<String>? interests;
    final int? budget;
    final String? status;
    final bool? isDeleted;
    final bool? isSharedWithParents;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final List<Remainder>? remainders;
    final List<Itinerary>? itineraries;
    final List<PriorityRemainder>? priorityRemainders;

    TripDetailModel({
        this.id,
        this.userId,
        this.region,
        this.city,
        this.startDate,
        this.endDate,
        this.totalDays,
        this.interests,
        this.budget,
        this.status,
        this.isDeleted,
        this.isSharedWithParents,
        this.createdAt,
        this.updatedAt,
        this.remainders,
        this.itineraries,
        this.priorityRemainders,
    });

    factory TripDetailModel.fromJson(Map<String, dynamic> json) => TripDetailModel(
        id: json["id"],
        userId: json["userId"],
        region: json["region"] == null ? [] : List<String>.from(json["region"]!.map((x) => x)),
        city: json["city"] == null ? [] : List<String>.from(json["city"]!.map((x) => x)),
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
        endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        totalDays: json["totalDays"],
        interests: json["interests"] == null ? [] : List<String>.from(json["interests"]!.map((x) => x)),
        budget: json["budget"],
        status: json["status"],
        isDeleted: json["isDeleted"],
        isSharedWithParents: json["isSharedWithParents"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        remainders: json["remainders"] == null ? [] : List<Remainder>.from(json["remainders"]!.map((x) => Remainder.fromJson(x))),
        itineraries: json["itineraries"] == null ? [] : List<Itinerary>.from(json["itineraries"]!.map((x) => Itinerary.fromJson(x))),
        priorityRemainders: json["priorityRemainders"] == null ? [] : List<PriorityRemainder>.from(json["priorityRemainders"]!.map((x) => PriorityRemainder.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "region": region == null ? [] : List<dynamic>.from(region!.map((x) => x)),
        "city": city == null ? [] : List<dynamic>.from(city!.map((x) => x)),
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "totalDays": totalDays,
        "interests": interests == null ? [] : List<dynamic>.from(interests!.map((x) => x)),
        "budget": budget,
        "status": status,
        "isDeleted": isDeleted,
        "isSharedWithParents": isSharedWithParents,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "remainders": remainders == null ? [] : List<dynamic>.from(remainders!.map((x) => x.toJson())),
        "itineraries": itineraries == null ? [] : List<dynamic>.from(itineraries!.map((x) => x.toJson())),
        "priorityRemainders": priorityRemainders == null ? [] : List<dynamic>.from(priorityRemainders!.map((x) => x.toJson())),
    };
}

class Itinerary {
    final String? id;
    final String? tripId;
    final String? name;
    final int? days;
    final String? accommodation;
    final String? transportation;
    final dynamic image;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Itinerary({
        this.id,
        this.tripId,
        this.name,
        this.days,
        this.accommodation,
        this.transportation,
        this.image,
        this.createdAt,
        this.updatedAt,
    });

    factory Itinerary.fromJson(Map<String, dynamic> json) => Itinerary(
        id: json["id"],
        tripId: json["tripId"],
        name: json["name"],
        days: json["days"],
        accommodation: json["accommodation"],
        transportation: json["transportation"],
        image: json["image"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tripId": tripId,
        "name": name,
        "days": days,
        "accommodation": accommodation,
        "transportation": transportation,
        "image": image,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}

class PriorityRemainder {
    final String? id;
    final String? tripId;
    final String? itineraryId;
    final String? passportCountry;
    final dynamic passportExpiry;
    final bool? isVisaConfirmed;
    final bool? noVisaRequired;
    final bool? needsAttention;
    final String? visaNotes;
    final bool? haveInsurance;
    final String? status;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    PriorityRemainder({
        this.id,
        this.tripId,
        this.itineraryId,
        this.passportCountry,
        this.passportExpiry,
        this.isVisaConfirmed,
        this.noVisaRequired,
        this.needsAttention,
        this.visaNotes,
        this.haveInsurance,
        this.status,
        this.createdAt,
        this.updatedAt,
    });

    factory PriorityRemainder.fromJson(Map<String, dynamic> json) => PriorityRemainder(
        id: json["id"],
        tripId: json["tripId"],
        itineraryId: json["itineraryId"],
        passportCountry: json["passportCountry"],
        passportExpiry: json["passportExpiry"],
        isVisaConfirmed: json["isVisaConfirmed"],
        noVisaRequired: json["noVisaRequired"],
        needsAttention: json["needsAttention"],
        visaNotes: json["visaNotes"],
        haveInsurance: json["haveInsurance"],
        status: json["status"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tripId": tripId,
        "itineraryId": itineraryId,
        "passportCountry": passportCountry,
        "passportExpiry": passportExpiry,
        "isVisaConfirmed": isVisaConfirmed,
        "noVisaRequired": noVisaRequired,
        "needsAttention": needsAttention,
        "visaNotes": visaNotes,
        "haveInsurance": haveInsurance,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}

class Remainder {
    final String? id;
    final String? tripId;
    final String? itineraryId;
    final String? title;
    final String? description;
    final int? daysLeft;
    final String? status;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Remainder({
        this.id,
        this.tripId,
        this.itineraryId,
        this.title,
        this.description,
        this.daysLeft,
        this.status,
        this.createdAt,
        this.updatedAt,
    });

    factory Remainder.fromJson(Map<String, dynamic> json) => Remainder(
        id: json["id"],
        tripId: json["tripId"],
        itineraryId: json["itineraryId"],
        title: json["title"],
        description: json["description"],
        daysLeft: json["daysLeft"],
        status: json["status"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tripId": tripId,
        "itineraryId": itineraryId,
        "title": title,
        "description": description,
        "daysLeft": daysLeft,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}
