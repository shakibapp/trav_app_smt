import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../../core/utils/date_formatter.dart';
import '../model/create_plan_calender_model.dart';

class DatePickerController extends GetxController {
  // Observable variables
  final selectedStartDate = Rxn<DateTime>();
  final selectedEndDate = Rxn<DateTime>();
  final selectedDates = <DateTime>[].obs;

  final currentMonth = DateTime.now().obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Current country (passed from previous screen)
  late String selectedCountry;

  // Selection mode: 'range' or 'multiple'
  final selectionMode = 'range'.obs;

  // Get days in current month
  late int daysInMonth;
  late int firstWeekdayOfMonth;

  @override
  void onInit() {
    super.onInit();
    // Get country from arguments
    if (Get.arguments != null && Get.arguments is String) {
      selectedCountry = Get.arguments;
    }

    // Initialize with current month
    final now = DateTime.now();
    currentMonth(DateTime(now.year, now.month, 1));
    updateCalendar();
  }

  // Update calendar when month changes
  void updateCalendar() {
    final month = currentMonth.value;
    daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    firstWeekdayOfMonth = DateTime(month.year, month.month, 1).weekday % 7;
  }

  // Get next month
  void nextMonth() {
    final nextMonth = DateTime(
      currentMonth.value.year,
      currentMonth.value.month + 1,
      1,
    );
    currentMonth(nextMonth);
    updateCalendar();
  }

  // Get previous month - but NOT allowed if it's before current month
  void previousMonth() {
    final now = DateTime.now();
    final firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);

    final previousMonth = DateTime(
      currentMonth.value.year,
      currentMonth.value.month - 1,
      1,
    );

    // Check if we're trying to go to a previous month
    if (previousMonth.isBefore(firstDayOfCurrentMonth)) {
      Get.snackbar(
        'Cannot Go Back',
        'You cannot select dates from previous months',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    currentMonth(previousMonth);
    updateCalendar();
  }

  // Check if date is in current month or future
  bool isDateSelectable(int day) {
    final date = DateTime(
      currentMonth.value.year,
      currentMonth.value.month,
      day,
    );
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    // Only allow current month and future dates
    return !date.isBefore(todayStart);
  }

  // Select a single date
  void selectDate(int day) {
    final date = DateTime(
      currentMonth.value.year,
      currentMonth.value.month,
      day,
    );

    if (!isDateSelectable(day)) {
      Get.snackbar(
        'Invalid Date',
        'You cannot select past dates',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (selectionMode.value == 'range') {
      // Range selection mode
      if (selectedStartDate.value == null) {
        selectedStartDate(date);
        selectedDates.clear();
        selectedDates.add(date);
      } else if (selectedEndDate.value == null) {
        if (date.isBefore(selectedStartDate.value!)) {
          Get.snackbar(
            'Invalid Selection',
            'End date must be after start date',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.orange,
          );
          return;
        }
        selectedEndDate(date);
        _generateDateRange();
      } else {
        // Reset and start new selection
        selectedStartDate(date);
        selectedEndDate(null);
        selectedDates.clear();
        selectedDates.add(date);
      }
    }
  }

  // Generate all dates in range
  void _generateDateRange() {
    if (selectedStartDate.value == null || selectedEndDate.value == null) {
      return;
    }

    selectedDates.clear();
    final start = selectedStartDate.value!;
    final end = selectedEndDate.value!;

    for (int i = 0; i <= end.difference(start).inDays; i++) {
      selectedDates.add(start.add(Duration(days: i)));
    }
  }

  // Check if date is selected
  bool isDateSelected(int day) {
    final date = DateTime(
      currentMonth.value.year,
      currentMonth.value.month,
      day,
    );
    return selectedDates.any(
      (d) => d.year == date.year && d.month == date.month && d.day == date.day,
    );
  }

  // Check if date is start date
  bool isStartDate(int day) {
    final date = DateTime(
      currentMonth.value.year,
      currentMonth.value.month,
      day,
    );
    if (selectedStartDate.value == null) return false;
    final startDate = selectedStartDate.value!;
    return date.year == startDate.year &&
        date.month == startDate.month &&
        date.day == startDate.day;
  }

  // Check if date is end date
  bool isEndDate(int day) {
    final date = DateTime(
      currentMonth.value.year,
      currentMonth.value.month,
      day,
    );
    if (selectedEndDate.value == null) return false;
    final endDate = selectedEndDate.value!;
    return date.year == endDate.year &&
        date.month == endDate.month &&
        date.day == endDate.day;
  }

  // Format date for display
  String formatDate(DateTime date) {
    return AppDateFormatter.format(date);
  }

  // Get total days selected
  int getTotalDays() {
    if (selectedDates.isEmpty) return 0;
    return selectedDates.length;
  }

  // Validate and proceed
  void proceedWithDates() {
    if (selectedStartDate.value == null || selectedEndDate.value == null) {
      Get.snackbar(
        'Incomplete Selection',
        'Please select both start and end dates',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Create trip with selected dates
    final trip = Trip(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      country: selectedCountry,
      dateRange: DateRange(
        startDate: selectedStartDate.value!,
        endDate: selectedEndDate.value!,
        selectedDates: selectedDates,
      ),
      createdAt: DateTime.now(),
    );

    // Print selected dates
    log('=== TRIP DETAILS ===');
    log('Country: ${trip.country}');
    log('Start Date: ${trip.dateRange.formattedStartDate}');
    log('End Date: ${trip.dateRange.formattedEndDate}');
    log('Total Days: ${trip.dateRange.totalDays}');
    log('Selected Dates:');
    for (var date in trip.dateRange.selectedDates) {
      log('  - ${formatDate(date)}');
    }
    log('====================');

    // Show summary dialog
    showTripSummary(trip);

    // Navigate to next screen with trip data
    // Get.toNamed('/trip_summary', arguments: trip);
  }

  // Show trip summary
  void showTripSummary(Trip trip) {
    Get.dialog(
      AlertDialog(
        title: const Text('Trip Summary'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Country: ${trip.country}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Start Date: ${trip.dateRange.formattedStartDate}',
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                'End Date: ${trip.dateRange.formattedEndDate}',
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                'Total Days: ${trip.dateRange.totalDays}',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 16),
              const Text(
                'Selected Dates:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: trip.dateRange.selectedDates
                        .map(
                          (date) => Text(
                            '• ${formatDate(date)}',
                            style: const TextStyle(fontSize: 11),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Edit')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Navigate to next screen
              Get.toNamed('/trip_itinerary', arguments: trip);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  // Clear selection
  void clearSelection() {
    selectedStartDate(null);
    selectedEndDate(null);
    selectedDates.clear();
  }

  // Get month name
  String getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
