

class SingleTransportModel {
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
    final String? seat;
    final String? currency;
    final int? totalCost;
    final String? notes;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    SingleTransportModel({
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

    factory SingleTransportModel.fromJson(Map<String, dynamic> json) => SingleTransportModel(
        id: json["id"],
        itineraryId: json["itineraryId"],
        type: json["type"],
        dpeartureLocation: json["dpeartureLocation"],
        arrivalLocation: json["arrivalLocation"],
        departureDate: json["departureDate"] == null ? null : DateTime.parse(json["departureDate"]),
        departureTime: json["departureTime"],
        arrivalDate: json["arrivalDate"] == null ? null : DateTime.parse(json["arrivalDate"]),
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
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
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
