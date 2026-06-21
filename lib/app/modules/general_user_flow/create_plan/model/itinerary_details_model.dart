class ItineraryDetailsModel {
  final String? id;
  final String? tripId;
  final String? name;
  final int? days;
  final String? image;
  final String? accommodation;
  final String? transportation;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Remainder>? remainders;
  final List<PriorityRemainder>? priorityRemainders;
  final List<Accommodation>? accommodations;
  final List<Transportation>? transportations;
  final List<Activity>? activities;

  ItineraryDetailsModel({
    this.id,
    this.tripId,
    this.name,
    this.days,
    this.image,
    this.accommodation,
    this.transportation,
    this.createdAt,
    this.updatedAt,
    this.remainders,
    this.priorityRemainders,
    this.accommodations,
    this.transportations,
    this.activities,
  });

  factory ItineraryDetailsModel.fromJson(Map<String, dynamic> json) =>
      ItineraryDetailsModel(
        id: json["id"],
        tripId: json["tripId"],
        name: json["name"],
        days: json["days"],
        image: json["image"],
        accommodation: json["accommodation"],
        transportation: json["transportation"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        remainders: json["remainders"] == null
            ? []
            : List<Remainder>.from(
                json["remainders"]!.map((x) => Remainder.fromJson(x))),
        priorityRemainders: json["priorityRemainders"] == null
            ? []
            : List<PriorityRemainder>.from(json["priorityRemainders"]!
                .map((x) => PriorityRemainder.fromJson(x))),
        accommodations: json["accommodations"] == null
            ? []
            : List<Accommodation>.from(
                json["accommodations"]!.map((x) => Accommodation.fromJson(x))),
        transportations: json["transportations"] == null
            ? []
            : List<Transportation>.from(json["transportations"]!
                .map((x) => Transportation.fromJson(x))),
        activities: json["activities"] == null
            ? []
            : List<Activity>.from(
                json["activities"]!.map((x) => Activity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tripId": tripId,
        "name": name,
        "days": days,
        "image": image,
        "accommodation": accommodation,
        "transportation": transportation,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "remainders": remainders == null
            ? []
            : List<dynamic>.from(remainders!.map((x) => x.toJson())),
        "priorityRemainders": priorityRemainders == null
            ? []
            : List<dynamic>.from(priorityRemainders!.map((x) => x.toJson())),
        "accommodations": accommodations == null
            ? []
            : List<dynamic>.from(accommodations!.map((x) => x.toJson())),
        "transportations": transportations == null
            ? []
            : List<dynamic>.from(transportations!.map((x) => x.toJson())),
        "activities": activities == null
            ? []
            : List<dynamic>.from(activities!.map((x) => x.toJson())),
      };
}

class Accommodation {
  final String? id;
  final String? itineraryId;
  final String? name;
  final String? type;
  final String? address;
  final String? bookingPlatform;
  final String? bookingReference;
  final int? numberOfGuests;
  final int? totalNights;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final String? currency;
  final int? totalCost;
  final String? paymentStatus;
  final int? amountOwing;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Accommodation({
    this.id,
    this.itineraryId,
    this.name,
    this.type,
    this.address,
    this.bookingPlatform,
    this.bookingReference,
    this.numberOfGuests,
    this.totalNights,
    this.checkInDate,
    this.checkOutDate,
    this.currency,
    this.totalCost,
    this.paymentStatus,
    this.amountOwing,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory Accommodation.fromJson(Map<String, dynamic> json) => Accommodation(
        id: json["id"],
        itineraryId: json["itineraryId"],
        name: json["name"],
        type: json["type"],
        address: json["address"],
        bookingPlatform: json["bookingPlatform"],
        bookingReference: json["bookingReference"],
        numberOfGuests: json["numberOfGuests"],
        totalNights: json["totalNights"],
        checkInDate: json["checkInDate"] == null
            ? null
            : DateTime.parse(json["checkInDate"]),
        checkOutDate: json["checkOutDate"] == null
            ? null
            : DateTime.parse(json["checkOutDate"]),
        currency: json["currency"],
        totalCost: json["totalCost"],
        paymentStatus: json["paymentStatus"],
        amountOwing: json["amountOwing"],
        notes: json["notes"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "itineraryId": itineraryId,
        "name": name,
        "type": type,
        "address": address,
        "bookingPlatform": bookingPlatform,
        "bookingReference": bookingReference,
        "numberOfGuests": numberOfGuests,
        "totalNights": totalNights,
        "checkInDate": checkInDate?.toIso8601String(),
        "checkOutDate": checkOutDate?.toIso8601String(),
        "currency": currency,
        "totalCost": totalCost,
        "paymentStatus": paymentStatus,
        "amountOwing": amountOwing,
        "notes": notes,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class Activity {
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

  Activity({
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

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        id: json["id"],
        itineraryId: json["itineraryId"],
        name: json["name"],
        dayNumber: json["dayNumber"],
        type: json["type"] == null
            ? []
            : List<String>.from(json["type"]!.map((x) => x)),
        startDate: json["startDate"] == null
            ? null
            : DateTime.parse(json["startDate"]),
        endDate:
            json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        startTime: json["startTime"],
        endTime: json["endTime"],
        location: json["location"],
        expense: json["expense"],
        status: json["status"],
        rating: json["rating"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
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

class PriorityRemainder {
  final String? id;
  final String? tripId;
  final String? itineraryId;
  final String? passportCountry;
  final DateTime? passportExpiry;
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

  factory PriorityRemainder.fromJson(Map<String, dynamic> json) =>
      PriorityRemainder(
        id: json["id"],
        tripId: json["tripId"],
        itineraryId: json["itineraryId"],
        passportCountry: json["passportCountry"],
        passportExpiry: json["passportExpiry"] == null
            ? null
            : DateTime.parse(json["passportExpiry"]),
        isVisaConfirmed: json["isVisaConfirmed"],
        noVisaRequired: json["noVisaRequired"],
        needsAttention: json["needsAttention"],
        visaNotes: json["visaNotes"],
        haveInsurance: json["haveInsurance"],
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tripId": tripId,
        "itineraryId": itineraryId,
        "passportCountry": passportCountry,
        "passportExpiry": passportExpiry?.toIso8601String(),
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
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
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

class Transportation {
  final String? id;
  final String? itineraryId;
  final String? type;
  final String? dpeartureLocation;
  final String? arrivalLocation;
  final DateTime? departureDate;
  final String? departureTime;
  final DateTime? arrivalDate;
  final String? arrivalTime;
  final String? bookingPlatform;
  final String? bookingReference;
  final String? airline;
  final String? flightNumber;
  final String? terminal;
  final String? gate;
  final dynamic trainOperator;
  final dynamic trainNumber;
  final dynamic busCompany;
  final dynamic serviceNumber;
  final dynamic carNumberPlate;
  final dynamic seat;
  final String? currency;
  final int? totalCost;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Transportation({
    this.id,
    this.itineraryId,
    this.type,
    this.dpeartureLocation,
    this.arrivalLocation,
    this.departureDate,
    this.departureTime,
    this.arrivalDate,
    this.arrivalTime,
    this.bookingPlatform,
    this.bookingReference,
    this.airline,
    this.flightNumber,
    this.terminal,
    this.gate,
    this.trainOperator,
    this.trainNumber,
    this.busCompany,
    this.serviceNumber,
    this.carNumberPlate,
    this.seat,
    this.currency,
    this.totalCost,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory Transportation.fromJson(Map<String, dynamic> json) => Transportation(
        id: json["id"],
        itineraryId: json["itineraryId"],
        type: json["type"],
        dpeartureLocation: json["dpeartureLocation"],
        arrivalLocation: json["arrivalLocation"],
        departureDate: json["departureDate"] == null
            ? null
            : DateTime.parse(json["departureDate"]),
        departureTime: json["departureTime"],
        arrivalDate: json["arrivalDate"] == null
            ? null
            : DateTime.parse(json["arrivalDate"]),
        arrivalTime: json["arrivalTime"],
        bookingPlatform: json["bookingPlatform"],
        bookingReference: json["bookingReference"],
        airline: json["airline"],
        flightNumber: json["flightNumber"],
        terminal: json["terminal"],
        gate: json["gate"],
        trainOperator: json["trainOperator"],
        trainNumber: json["trainNumber"],
        busCompany: json["busCompany"],
        serviceNumber: json["serviceNumber"],
        carNumberPlate: json["carNumberPlate"],
        seat: json["seat"],
        currency: json["currency"],
        totalCost: json["totalCost"],
        notes: json["notes"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "itineraryId": itineraryId,
        "type": type,
        "dpeartureLocation": dpeartureLocation,
        "arrivalLocation": arrivalLocation,
        "departureDate": departureDate?.toIso8601String(),
        "departureTime": departureTime,
        "arrivalDate": arrivalDate?.toIso8601String(),
        "arrivalTime": arrivalTime,
        "bookingPlatform": bookingPlatform,
        "bookingReference": bookingReference,
        "airline": airline,
        "flightNumber": flightNumber,
        "terminal": terminal,
        "gate": gate,
        "trainOperator": trainOperator,
        "trainNumber": trainNumber,
        "busCompany": busCompany,
        "serviceNumber": serviceNumber,
        "carNumberPlate": carNumberPlate,
        "seat": seat,
        "currency": currency,
        "totalCost": totalCost,
        "notes": notes,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
