class LocationModel {
  final String id;
  final String name;
  final String type;
  final String? regionId;
  final bool isPopular;
  final String? image;

  LocationModel({
    required this.id,
    required this.name,
    required this.type,
    this.regionId,
    this.isPopular = false,
    this.image,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      regionId: json['regionId'],
      isPopular: json['isPopular'] ?? false,
      image: _normalizeImagePath(json['image'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "type": type,
      "regionId": regionId,
      "isPopular": isPopular,
      "image": image,
    };
  }

  static String? _normalizeImagePath(String? image) {
    if (image == null || image.trim().isEmpty) return null;
    final normalized = image.trim();
    var path = normalized;

    if (path.startsWith('assets/')) {
      path = path.substring('assets/'.length);
    } else if (path.startsWith('/')) {
      path = path.substring(1);
    }

    final parts = path.split('/');
    if (parts.isEmpty) return null;

    final fileName = parts.last;
    final baseName = fileName.startsWith('city_')
        ? fileName.substring('city_'.length)
        : fileName;

    return 'assets/images/cities/$baseName';
  }
}
