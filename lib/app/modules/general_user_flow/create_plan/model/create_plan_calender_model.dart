import '../../../../core/utils/date_formatter.dart';

class DateRange {
  final DateTime startDate;
  final DateTime? endDate;
  final List<DateTime> selectedDates;

  DateRange({
    required this.startDate,
    this.endDate,
    this.selectedDates = const [],
  });

  int get totalDays {
    if (endDate == null) return 1;
    return endDate!.difference(startDate).inDays + 1;
  }

  bool isDateInRange(DateTime date) {
    if (endDate == null) return date == startDate;
    return date.isAfter(startDate.subtract(Duration(days: 1))) &&
        date.isBefore(endDate!.add(Duration(days: 1)));
  }

  factory DateRange.fromJson(Map<String, dynamic> json) {
    return DateRange(
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      selectedDates:
          (json['selectedDates'] as List?)
              ?.map((date) => DateTime.parse(date as String))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'selectedDates': selectedDates.map((d) => d.toIso8601String()).toList(),
    };
  }

  String get formattedStartDate {
    return AppDateFormatter.format(startDate);
  }

  String get formattedEndDate {
    if (endDate == null) return formattedStartDate;
    return AppDateFormatter.format(endDate);
  }

  @override
  String toString() {
    return 'DateRange: $formattedStartDate to $formattedEndDate ($totalDays days)';
  }
}

class Trip {
  final String id;
  final String country;
  final DateRange dateRange;
  final DateTime createdAt;

  Trip({
    required this.id,
    required this.country,
    required this.dateRange,
    required this.createdAt,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      country: json['country'],
      dateRange: DateRange.fromJson(json['dateRange']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country': country,
      'dateRange': dateRange.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
