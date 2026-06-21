// trip_overview_model.dart



import 'package:flutter/material.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';

class TripOverviewModel {
  final String? tripId;
  final List<TripRoute>? route; // ✅ Route → TripRoute

  TripOverviewModel({
    this.tripId,
    this.route,
  });

  factory TripOverviewModel.fromJson(Map<String, dynamic> json) =>
      TripOverviewModel(
        tripId: json["tripId"],
        route: json["route"] == null
            ? []
            : List<TripRoute>.from( // ✅ Route → TripRoute
                json["route"]!.map((x) => TripRoute.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "tripId": tripId,
        "route": route == null
            ? []
            : List<dynamic>.from(route!.map((x) => x.toJson())),
      };
}

class TripRoute { // ✅ Route → TripRoute
  final String? itineraryId;
  final String? city;
  final int? days;
  final TripStatus status;

  TripRoute({
    this.itineraryId,
    this.city,
    this.days,
    this.status = TripStatus.upcoming,
  });

  factory TripRoute.fromJson(Map<String, dynamic> json) => TripRoute(
        itineraryId: json["itineraryId"],
        city: json["city"],
        days: json["days"],
        status: TripStatus.fromString(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "itineraryId": itineraryId,
        "city": city,
        "days": days,
        "status": status.label,
      };
}
// trip_status.dart



enum TripStatus {
  ongoing,
  upcoming,
  completed;

  static TripStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'ongoing':
        return TripStatus.ongoing;
      case 'upcoming':
        return TripStatus.upcoming;
      case 'completed':
        return TripStatus.completed;
      default:
        return TripStatus.upcoming;
    }
  }

  String get label {
    switch (this) {
      case TripStatus.ongoing:
        return 'Ongoing';
      case TripStatus.upcoming:
        return 'Upcoming';
      case TripStatus.completed:
        return 'Completed';
    }
  }

  Color get dotColor {
    switch (this) {
      case TripStatus.ongoing:
        return Colors.orange;
      case TripStatus.upcoming:
        return Colors.grey.shade300;
      case TripStatus.completed:
        return Colors.orange;
    }
  }

  Color get textColor {
    switch (this) {
      case TripStatus.ongoing:
        return AppColors.blackColor;
      case TripStatus.upcoming:
        return AppColors.greyColor;
      case TripStatus.completed:
        return AppColors.blackColor;
    }
  }
}