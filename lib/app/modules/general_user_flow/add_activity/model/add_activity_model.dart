
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/date_formatter.dart';


class Activity {
  final String? id;
  final String activityName;
  final int dayNumber;
  final List<ActivityCategory> categories;
  final DateTime startDate;
  final DateTime endDate;
  final String startTime;
  final String endTime;
  final String? location;
  final double? expense;
  final DateTime createdAt;
  final DateTime updatedAt;

  Activity({
    this.id,
    required this.activityName,
    required this.dayNumber,
    required this.categories,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    this.location,
    this.expense,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activityName': activityName,
      'dayNumber': dayNumber,
      'categories': categories.map((c) => c.toString()).toList(),
      'startDate': AppDateFormatter.format(startDate),
      'endDate': AppDateFormatter.format(endDate),
      'startTime': '',
      'endTime': '',
      'location': location,
      'expense': expense,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Copy with method
  Activity copyWith({
    String? id,
    String? activityName,
    int? dayNumber,
    List<ActivityCategory>? categories,
    DateTime? startDate,
    DateTime? endDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? location,
    double? expense,
  }) {
    return Activity(
      id: id ?? this.id,
      activityName: activityName ?? this.activityName,
      dayNumber: dayNumber ?? this.dayNumber,
      categories: categories ?? this.categories,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime:  this.startTime.toString(),
      endTime:  this.endTime,
      location: location ?? this.location,
      expense: expense ?? this.expense,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

enum ActivityCategory {
  Culture,
  Food,
  Nature,
  Nightlife,
  Shopping,
  Entertainment,
  Beach,
  Walking,
  Sports,
  Relaxation,
  Adventure,
  Camping,
  Other
}

extension ActivityCategoryExtension on ActivityCategory {
  String get label {
  switch (this) {
    case ActivityCategory.Culture:
      return 'Culture';
    case ActivityCategory.Food:
      return 'Food';
    case ActivityCategory.Nature:
      return 'Nature';
    case ActivityCategory.Nightlife:
      return 'Nightlife';
    case ActivityCategory.Shopping:
      return 'Shopping';
    case ActivityCategory.Entertainment:
      return 'Entertainment';
    case ActivityCategory.Beach:
      return 'Beach';
    case ActivityCategory.Walking:
      return 'Walking';
    // ✅ Missing cases added:
    case ActivityCategory.Sports:
      return 'Sports';
    case ActivityCategory.Relaxation:
      return 'Relaxation';
    case ActivityCategory.Adventure:
      return 'Adventure';
    case ActivityCategory.Camping:
      return 'Camping';
    case ActivityCategory.Other:
      return 'Other';
  }
}

IconData get icon {
  switch (this) {
    case ActivityCategory.Culture:
      return Icons.palette;
    case ActivityCategory.Food:
      return Icons.restaurant;
    case ActivityCategory.Nature:
      return Icons.nature;
    case ActivityCategory.Nightlife:
      return Icons.nightlife;
    case ActivityCategory.Shopping:
      return Icons.shopping_bag;
    case ActivityCategory.Entertainment:
      return Icons.theater_comedy;
    case ActivityCategory.Beach:
      return Icons.beach_access;
    case ActivityCategory.Walking:
      return Icons.directions_walk;
    // ✅ Missing cases added:
    case ActivityCategory.Sports:
      return Icons.sports;
    case ActivityCategory.Relaxation:
      return Icons.spa;
    case ActivityCategory.Adventure:
      return Icons.hiking;
    case ActivityCategory.Camping:
      return Icons.cabin;
    case ActivityCategory.Other:
      return Icons.category;
  }
}
}

class TimeOfDay {
  final int hour;
  final int minute;

  TimeOfDay({required this.hour, required this.minute});

  @override
  String toString() => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  bool isAfter(TimeOfDay other) {
    if (hour != other.hour) return hour > other.hour;
    return minute > other.minute;
  }

  bool isBefore(TimeOfDay other) {
    if (hour != other.hour) return hour < other.hour;
    return minute < other.minute;
  }
}