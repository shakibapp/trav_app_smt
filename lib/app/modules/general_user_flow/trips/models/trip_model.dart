class TripData {
  final String location;
  final String imageUrl;
  final String startDate;
  final String endDate;
  final int days;
  final String priceRange;
  final String vibe;
  final String accommodation;

  TripData({
    required this.location,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.priceRange,
    required this.vibe,
    required this.accommodation,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'imageUrl': imageUrl,
      'startDate': startDate,
      'endDate': endDate,
      'days': days,
      'priceRange': priceRange,
      'vibe': vibe,
      'accommodation': accommodation,
    };
  }

  /// Create from JSON
  factory TripData.fromJson(Map<String, dynamic> json) {
    return TripData(
      location: json['location'] as String,
      imageUrl: json['imageUrl'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      days: json['days'] as int,
      priceRange: json['priceRange'] as String,
      vibe: json['vibe'] as String,
      accommodation: json['accommodation'] as String,
    );
  }

  /// Copy with method for updates
  TripData copyWith({
    String? location,
    String? imageUrl,
    String? startDate,
    String? endDate,
    int? days,
    String? priceRange,
    String? vibe,
    String? accommodation,
  }) {
    return TripData(
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      days: days ?? this.days,
      priceRange: priceRange ?? this.priceRange,
      vibe: vibe ?? this.vibe,
      accommodation: accommodation ?? this.accommodation,
    );
  }
}
