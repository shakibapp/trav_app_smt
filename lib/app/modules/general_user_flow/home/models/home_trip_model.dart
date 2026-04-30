class HomeTripData {
  final String location;
  final String imageUrl;
  final String startDate;
  final String endDate;
  final int days;
  final String budget;

  /// e.g. "Upcoming" or "Ongoing"
  final String status;

  HomeTripData({
    required this.location,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.budget,
    required this.status,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'imageUrl': imageUrl,
      'startDate': startDate,
      'endDate': endDate,
      'days': days,
      'budget': budget,
      'status': status,
    };
  }

  /// Create from JSON
  factory HomeTripData.fromJson(Map<String, dynamic> json) {
    final status = (json['status'] as String?)?.trim();
    final isOngoing = json['isOngoing'] as bool?;

    return HomeTripData(
      location: json['location'] as String,
      imageUrl: json['imageUrl'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      days: json['days'] as int,
      budget: json['budget'] as String,
      status: status?.isNotEmpty == true
          ? status!
          : (isOngoing == true ? 'Ongoing' : 'Upcoming'),
    );
  }
}
