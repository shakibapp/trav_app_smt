
class SingleAccommodationModel {
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

    SingleAccommodationModel({
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

    factory SingleAccommodationModel.fromJson(Map<String, dynamic> json) => SingleAccommodationModel(
        id: json["id"],
        itineraryId: json["itineraryId"],
        name: json["name"],
        type: json["type"],
        address: json["address"],
        bookingPlatform: json["bookingPlatform"],
        bookingReference: json["bookingReference"],
        numberOfGuests: json["numberOfGuests"],
        totalNights: json["totalNights"],
        checkInDate: json["checkInDate"] == null ? null : DateTime.parse(json["checkInDate"]),
        checkOutDate: json["checkOutDate"] == null ? null : DateTime.parse(json["checkOutDate"]),
        currency: json["currency"],
        totalCost: json["totalCost"],
        paymentStatus: json["paymentStatus"],
        amountOwing: json["amountOwing"],
        notes: json["notes"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
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
