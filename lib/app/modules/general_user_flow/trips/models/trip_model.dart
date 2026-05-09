// class AllTripDataModel {
//   final String id;
//   final String userId;
//   final List<String> region;
//   final List<String> city;
//   final String startDate;
//   final String endDate;
//   final int totalDays;
//   final List<String> interests;
//   final int budget;
//   final String status;
//   final bool isDeleted;
//   final bool isSharedWithParents;
//   final String createdAt;
//   final String updatedAt;
//   final List<Itinerary>? itineraries;
//
//   AllTripDataModel({
//     required this.id,
//     required this.userId,
//     required this.region,
//     required this.city,
//     required this.startDate,
//     required this.endDate,
//     required this.totalDays,
//     required this.interests,
//     required this.budget,
//     required this.status,
//     required this.isDeleted,
//     required this.isSharedWithParents,
//     required this.createdAt,
//     required this.updatedAt,
//     this.itineraries
//   });
//
//   factory AllTripDataModel.fromJson(Map<String, dynamic> json) {
//     return AllTripDataModel(
//       id: json['id'] as String,
//       userId: json['userId'] as String,
//       region: List<String>.from(json['region'] ?? []),
//       city: List<String>.from(json['city'] ?? []),
//       startDate: json['startDate'] as String,
//       endDate: json['endDate'] as String,
//       totalDays: json['totalDays'] as int,
//       interests: List<String>.from(json['interests'] ?? []),
//       budget: json['budget'] as int,
//       status: json['status'] as String,
//       isDeleted: json['isDeleted'] as bool,
//       isSharedWithParents: json['isSharedWithParents'] as bool,
//       createdAt: json['createdAt'] as String,
//       updatedAt: json['updatedAt'] as String,
//        itineraries: json['itineraries'] != null
//           ? List<Itinerary>.from(
//               json['itineraries'].map((x) => Itinerary.fromJson(x)),
//             )
//           : [],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'userId': userId,
//       'region': region,
//       'city': city,
//       'startDate': startDate,
//       'endDate': endDate,
//       'totalDays': totalDays,
//       'interests': interests,
//       'budget': budget,
//       'status': status,
//       'isDeleted': isDeleted,
//       'isSharedWithParents': isSharedWithParents,
//       'createdAt': createdAt,
//       'updatedAt': updatedAt,
//       'itineraries': itineraries?.map((e) => e.toJson()).toList(),
//     };
//   }
// }
//
// class TripListResponse {
//   final bool success;
//   final String message;
//   final dynamic meta;
//   final TripListData data;
//
//   TripListResponse({
//     required this.success,
//     required this.message,
//     required this.meta,
//     required this.data,
//   });
//
//   factory TripListResponse.fromJson(Map<String, dynamic> json) {
//     return TripListResponse(
//       success: json['success'] as bool,
//       message: json['message'] as String,
//       meta: json['meta'],
//       data: TripListData.fromJson(json['data'] as Map<String, dynamic>),
//     );
//   }
// }
//
// class TripListData {
//   final TripMeta meta;
//   final List<AllTripDataModel> data;
//
//   TripListData({required this.meta, required this.data});
//
//   factory TripListData.fromJson(Map<String, dynamic> json) {
//     return TripListData(
//       meta: TripMeta.fromJson(json['meta'] as Map<String, dynamic>),
//       data: (json['data'] as List<dynamic>)
//           .map((item) => AllTripDataModel.fromJson(item as Map<String, dynamic>))
//           .toList(),
//     );
//   }
// }
//
// class TripMeta {
//   final int total;
//   final int page;
//   final int limit;
//
//   TripMeta({required this.total, required this.page, required this.limit});
//
//   factory TripMeta.fromJson(Map<String, dynamic> json) {
//     return TripMeta(
//       total: json['total'] as int,
//       page: json['page'] as int,
//       limit: json['limit'] as int,
//     );
//   }
// }
// class Itinerary {
//   final String? id;
//   final String? image;
//
//   Itinerary({
//     this.id,
//     this.image,
//   });
//
//   factory Itinerary.fromJson(Map<String, dynamic> json) {
//     return Itinerary(
//       id: json['id'],
//       image: json['image'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'image': image,
//     };
//   }
// }

// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);


class  AllTripDataModel{
  final String? id;
  final String? userId;
  final List<String>? region;
  final List<String>? city;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? totalDays;
  final List<String>? interests;
  final int? budget;
  final List<String>? images;
  final String? status;
  final bool? isDeleted;
  final bool? isSharedWithParents;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Itinerary>? itineraries;

  AllTripDataModel({
    this.id,
    this.userId,
    this.region,
    this.city,
    this.startDate,
    this.endDate,
    this.totalDays,
    this.interests,
    this.budget,
    this.images,
    this.status,
    this.isDeleted,
    this.isSharedWithParents,
    this.createdAt,
    this.updatedAt,
    this.itineraries,
  });

  factory AllTripDataModel.fromJson(Map<String, dynamic> json) => AllTripDataModel(
    id: json["id"],
    userId: json["userId"],
    region: json["region"] == null ? [] : List<String>.from(json["region"]!.map((x) => x)),
    city: json["city"] == null ? [] : List<String>.from(json["city"]!.map((x) => x)),
    startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
    endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
    totalDays: json["totalDays"],
    interests: json["interests"] == null ? [] : List<String>.from(json["interests"]!.map((x) => x)),
    budget: json["budget"],
    images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
    status: json["status"],
    isDeleted: json["isDeleted"],
    isSharedWithParents: json["isSharedWithParents"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    itineraries: json["itineraries"] == null ? [] : List<Itinerary>.from(json["itineraries"]!.map((x) => Itinerary.fromJson(x))),
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
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "status": status,
    "isDeleted": isDeleted,
    "isSharedWithParents": isSharedWithParents,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "itineraries": itineraries == null ? [] : List<dynamic>.from(itineraries!.map((x) => x.toJson())),
  };
}

class Itinerary {
  final String? id;
  final String? image;

  Itinerary({
    this.id,
    this.image,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) => Itinerary(
    id: json["id"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
  };
}

class Meta {
  final int? total;
  final int? page;
  final int? limit;

  Meta({
    this.total,
    this.page,
    this.limit,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    total: json["total"],
    page: json["page"],
    limit: json["limit"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "page": page,
    "limit": limit,
  };
}
