class Reminder {
  final String id;
  final String title;
  final String daysLeft;
  final String? dueDate;
  final bool isCompleted;

  Reminder({
    required this.id,
    required this.title,
    required this.daysLeft,
    this.dueDate,
    this.isCompleted = false,
  });
}

class PriorityReminder {
  final String id;
  final String title;
  final String icon;
  final String status;
  final bool isCompleted;

  PriorityReminder({
    required this.id,
    required this.title,
    required this.icon,
    required this.status,
    this.isCompleted = false,
  });
}

class ItineraryStop {
  final int id;
  final String city;
  final String nights;
  final String? imageUrl;

  ItineraryStop({
    required this.id,
    required this.city,
    required this.nights,
    this.imageUrl,
  });
}

class TravelItinerary {
  final String destination;
  final String startDate;
  final String endDate;
  final int days;
  final String budget;
  final String travelers;
  final String accommodation;

  TravelItinerary({
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.budget,
    required this.travelers,
    required this.accommodation,
  });
}