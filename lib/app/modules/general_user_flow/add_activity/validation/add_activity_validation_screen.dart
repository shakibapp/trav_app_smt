
class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  ValidationResult({
    required this.isValid,
    this.errorMessage,
  });

  static ValidationResult valid() => ValidationResult(isValid: true);
  
  static ValidationResult invalid(String message) => 
      ValidationResult(isValid: false, errorMessage: message);
}

class ActivityValidator {
  // Activity name validation
  static ValidationResult validateActivityName(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationResult.invalid('Activity name is required');
    }

    if (value.length < 3) {
      return ValidationResult.invalid(
        'Activity name must be at least 3 characters',
      );
    }

    if (value.length > 100) {
      return ValidationResult.invalid(
        'Activity name must not exceed 100 characters',
      );
    }

    // Check for valid characters (alphanumeric, spaces, common punctuation)
    if (!RegExp(r"^[a-zA-Z0-9\s\-'(),&]$").hasMatch(value)) {
      return ValidationResult.invalid(
        'Activity name contains invalid characters',
      );
    }

    return ValidationResult.valid();
  }

  // Day number validation
  static ValidationResult validateDayNumber(int? value) {
    if (value == null || value <= 0) {
      return ValidationResult.invalid('Day number is required');
    }

    if (value > 365) {
      return ValidationResult.invalid(
        'Day number cannot exceed 365',
      );
    }

    return ValidationResult.valid();
  }

  // Categories validation
  static ValidationResult validateCategories(List<dynamic> categories) {
    if (categories.isEmpty) {
      return ValidationResult.invalid('Please select at least one category');
    }

    if (categories.length > 5) {
      return ValidationResult.invalid(
        'You can select a maximum of 5 categories',
      );
    }

    return ValidationResult.valid();
  }

  // Date validation
  static ValidationResult validateStartDate(DateTime? value) {
    if (value == null) {
      return ValidationResult.invalid('Start date is required');
    }

    // Check if date is not in the past
    if (value.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
      return ValidationResult.invalid(
        'Start date cannot be in the past',
      );
    }

    return ValidationResult.valid();
  }

  static ValidationResult validateEndDate(
    DateTime? endDate,
    DateTime? startDate,
  ) {
    if (endDate == null) {
      return ValidationResult.invalid('End date is required');
    }

    if (startDate == null) {
      return ValidationResult.invalid('Start date must be set first');
    }

    if (endDate.isBefore(startDate)) {
      return ValidationResult.invalid(
        'End date cannot be before start date',
      );
    }

    // Check if duration is not more than 30 days
    final difference = endDate.difference(startDate).inDays;
    if (difference > 30) {
      return ValidationResult.invalid(
        'Activity duration cannot exceed 30 days',
      );
    }

    return ValidationResult.valid();
  }

  // Time validation
  static ValidationResult validateStartTime(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationResult.invalid('Start time is required');
    }

    if (!_isValidTimeFormat(value)) {
      return ValidationResult.invalid(
        'Invalid time format. Use HH:MM',
      );
    }

    return ValidationResult.valid();
  }

  static ValidationResult validateEndTime(
    String? endTime,
    String? startTime,
  ) {
    if (endTime == null || endTime.isEmpty) {
      return ValidationResult.invalid('End time is required');
    }

    if (!_isValidTimeFormat(endTime)) {
      return ValidationResult.invalid(
        'Invalid time format. Use HH:MM',
      );
    }

    if (startTime != null && startTime.isNotEmpty) {
      final start = _parseTime(startTime);
      final end = _parseTime(endTime);

      if (start != null && end != null) {
        if (end.isBefore(start)) {
          return ValidationResult.invalid(
            'End time must be after start time',
          );
        }

        // Check if duration is at least 15 minutes
        final duration = end.hour * 60 + end.minute - (start.hour * 60 + start.minute);
        if (duration < 15) {
          return ValidationResult.invalid(
            'Activity must be at least 15 minutes long',
          );
        }

        // Check if duration is not more than 24 hours
        if (duration > 1440) {
          return ValidationResult.invalid(
            'Activity cannot be longer than 24 hours',
          );
        }
      }
    }

    return ValidationResult.valid();
  }

  // Location validation
  static ValidationResult validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationResult.valid(); // Optional field
    }

    if (value.length < 3) {
      return ValidationResult.invalid(
        'Location must be at least 3 characters',
      );
    }

    if (value.length > 200) {
      return ValidationResult.invalid(
        'Location must not exceed 200 characters',
      );
    }

    return ValidationResult.valid();
  }

  // Expense validation
  static ValidationResult validateExpense(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationResult.valid(); // Optional field
    }

    final amount = double.tryParse(value);

    if (amount == null) {
      return ValidationResult.invalid('Please enter a valid amount');
    }

    if (amount < 0) {
      return ValidationResult.invalid('Expense amount cannot be negative');
    }

    if (amount > 1000000) {
      return ValidationResult.invalid(
        'Expense amount cannot exceed 1,000,000',
      );
    }

    return ValidationResult.valid();
  }

  // Helper methods
  static bool _isValidTimeFormat(String time) {
    final regex = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
    return regex.hasMatch(time);
  }

  static TimeOfDayValue? _parseTime(String time) {
    try {
      final parts = time.split(':');
      if (parts.length != 2) return null;

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;

      return TimeOfDayValue(hour: hour, minute: minute);
    } catch (e) {
      return null;
    }
  }
}

class TimeOfDayValue {
  final int hour;
  final int minute;

  TimeOfDayValue({required this.hour, required this.minute});

  bool isBefore(TimeOfDayValue other) {
    if (hour != other.hour) return hour < other.hour;
    return minute < other.minute;
  }
}