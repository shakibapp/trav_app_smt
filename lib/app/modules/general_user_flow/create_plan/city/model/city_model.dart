

class LocationModel {
  final String id;
  final String name;
  final String type;
  final String? regionId;
  final bool isPopular;

  LocationModel({
    required this.id,
    required this.name,
    required this.type,
    this.regionId,
    this.isPopular = false,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      regionId: json['regionId'],
      isPopular: json['isPopular'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "type": type,
      "regionId": regionId,
      "isPopular": isPopular,
    };
  }
}