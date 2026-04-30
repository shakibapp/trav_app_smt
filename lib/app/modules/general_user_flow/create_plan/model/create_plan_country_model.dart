
// Model
class Region {
  final String id;
  final String name;
  final String type; // 'region' or 'city'

  Region({
    required this.id,
    required this.name,
    required this.type,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['id'],
      name: json['name'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
    };
  }
}

class RegionResponse {
  final List<Region> regions;
  final String? selectedRegion;

  RegionResponse({
    required this.regions,
    this.selectedRegion,
  });
}