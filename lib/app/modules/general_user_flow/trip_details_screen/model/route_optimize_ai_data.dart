

class RouteOptimizeAiData {
    final String? tripId;
    final List<String>? currentOrder;
    final List<String>? optimizedOrder;
    final bool? isAlreadyOptimal;
    final String? estimatedTimeSaved;
    final String? reason;
    final List<String>? tips;

    RouteOptimizeAiData({
        this.tripId,
        this.currentOrder,
        this.optimizedOrder,
        this.isAlreadyOptimal,
        this.estimatedTimeSaved,
        this.reason,
        this.tips,
    });

    factory RouteOptimizeAiData.fromJson(Map<String, dynamic> json) => RouteOptimizeAiData(
        tripId: json["tripId"],
        currentOrder: json["currentOrder"] == null ? [] : List<String>.from(json["currentOrder"]!.map((x) => x)),
        optimizedOrder: json["optimizedOrder"] == null ? [] : List<String>.from(json["optimizedOrder"]!.map((x) => x)),
        isAlreadyOptimal: json["isAlreadyOptimal"],
        estimatedTimeSaved: json["estimatedTimeSaved"],
        reason: json["reason"],
        tips: json["tips"] == null ? [] : List<String>.from(json["tips"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "tripId": tripId,
        "currentOrder": currentOrder == null ? [] : List<dynamic>.from(currentOrder!.map((x) => x)),
        "optimizedOrder": optimizedOrder == null ? [] : List<dynamic>.from(optimizedOrder!.map((x) => x)),
        "isAlreadyOptimal": isAlreadyOptimal,
        "estimatedTimeSaved": estimatedTimeSaved,
        "reason": reason,
        "tips": tips == null ? [] : List<dynamic>.from(tips!.map((x) => x)),
    };
}
