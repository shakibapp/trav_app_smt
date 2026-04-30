
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
  culture,
  food,
  nature,
  nightlife,
  shopping,
  entertainment,
  beach,
  walking,
}

extension ActivityCategoryExtension on ActivityCategory {
  String get label {
    switch (this) {
      case ActivityCategory.culture:
        return 'Culture';
      case ActivityCategory.food:
        return 'Food';
      case ActivityCategory.nature:
        return 'Nature';
      case ActivityCategory.nightlife:
        return 'Nightlife';
      case ActivityCategory.shopping:
        return 'Shopping';
      case ActivityCategory.entertainment:
        return 'Entertainment';
      case ActivityCategory.beach:
        return 'Beach';
      case ActivityCategory.walking:
        return 'Walking';
    }
  }

  IconData get icon {
    switch (this) {
      case ActivityCategory.culture:
        return Icons.palette;
      case ActivityCategory.food:
        return Icons.restaurant;
      case ActivityCategory.nature:
        return Icons.nature;
      case ActivityCategory.nightlife:
        return Icons.nightlife;
      case ActivityCategory.shopping:
        return Icons.shopping_bag;
      case ActivityCategory.entertainment:
        return Icons.theater_comedy;
      case ActivityCategory.beach:
        return Icons.beach_access;
      case ActivityCategory.walking:
        return Icons.directions_walk;
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