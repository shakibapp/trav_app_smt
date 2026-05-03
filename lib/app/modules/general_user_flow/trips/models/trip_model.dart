class AllTripDataModel {
  final String id;
  final String userId;
  final List<String> region;
  final List<String> city;
  final String startDate;
  final String endDate;
  final int totalDays;
  final List<String> interests;
  final int budget;
  final String status;
  final bool isDeleted;
  final bool isSharedWithParents;
  final String createdAt;
  final String updatedAt;
  final List<Itinerary>? itineraries;

  AllTripDataModel({
    required this.id,
    required this.userId,
    required this.region,
    required this.city,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.interests,
    required this.budget,
    required this.status,
    required this.isDeleted,
    required this.isSharedWithParents,
    required this.createdAt,
    required this.updatedAt,
    this.itineraries
  });

  factory AllTripDataModel.fromJson(Map<String, dynamic> json) {
    return AllTripDataModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      region: List<String>.from(json['region'] ?? []),
      city: List<String>.from(json['city'] ?? []),
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      totalDays: json['totalDays'] as int,
      interests: List<String>.from(json['interests'] ?? []),
      budget: json['budget'] as int,
      status: json['status'] as String,
      isDeleted: json['isDeleted'] as bool,
      isSharedWithParents: json['isSharedWithParents'] as bool,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
       itineraries: json['itineraries'] != null
          ? List<Itinerary>.from(
              json['itineraries'].map((x) => Itinerary.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'region': region,
      'city': city,
      'startDate': startDate,
      'endDate': endDate,
      'totalDays': totalDays,
      'interests': interests,
      'budget': budget,
      'status': status,
      'isDeleted': isDeleted,
      'isSharedWithParents': isSharedWithParents,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'itineraries': itineraries?.map((e) => e.toJson()).toList(),
    };
  }
}

class TripListResponse {
  final bool success;
  final String message;
  final dynamic meta;
  final TripListData data;

  TripListResponse({
    required this.success,
    required this.message,
    required this.meta,
    required this.data,
  });

  factory TripListResponse.fromJson(Map<String, dynamic> json) {
    return TripListResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      meta: json['meta'],
      data: TripListData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class TripListData {
  final TripMeta meta;
  final List<AllTripDataModel> data;

  TripListData({required this.meta, required this.data});

  factory TripListData.fromJson(Map<String, dynamic> json) {
    return TripListData(
      meta: TripMeta.fromJson(json['meta'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>)
          .map((item) => AllTripDataModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TripMeta {
  final int total;
  final int page;
  final int limit;

  TripMeta({required this.total, required this.page, required this.limit});

  factory TripMeta.fromJson(Map<String, dynamic> json) {
    return TripMeta(
      total: json['total'] as int,
      page: json['page'] as int,
      limit: json['limit'] as int,
    );
  }
}
class Itinerary {
  final String? id;
  final String? image;

  Itinerary({
    this.id,
    this.image,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      id: json['id'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
    };
  }
}