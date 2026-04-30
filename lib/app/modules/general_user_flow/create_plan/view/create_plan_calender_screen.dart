import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/modules/general_user_flow/create_plan/view/create_plan_interest_screen.dart';

import '../controller/create_plan_calender_controller.dart';

class DatePickerView extends StatelessWidget {
  DatePickerView({super.key});
  final controller = Get.put(DatePickerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                _buildBackButton(),
                Divider(),

                const SizedBox(height: 16),

                // Title section
                _buildTitleSection(),
                const SizedBox(height: 20),

                // Calendar
                _buildCalendar(),
                const SizedBox(height: 20),

                // Selected dates summary
                _buildDatesSummary(),
                const SizedBox(height: 24),

                // Next button
                _buildNextButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange, width: 2),
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Icon(Icons.chevron_left, color: Colors.orange),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pick your start date',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          "We'll highlight the rest of your trip.",
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          // Month header with navigation
          _buildMonthHeader(),
          const SizedBox(height: 16),

          // Weekday labels
          _buildWeekdayLabels(),
          const SizedBox(height: 12),

          // Calendar grid
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildMonthHeader() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Month and Year display
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.getMonthName(controller.currentMonth.value.month),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${controller.currentMonth.value.year}',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          // Navigation buttons
          Row(
            children: [
              // Previous month button (disabled)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey.shade100,
                ),
                child: const Icon(Icons.chevron_left, color: Colors.grey),
              ),
              const SizedBox(width: 8),

              // Next month button
              GestureDetector(
                onTap: controller.nextMonth,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Icon(Icons.chevron_right, color: Colors.orange),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayLabels() {
    const weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: weekdays
          .map(
            (day) => SizedBox(
              width: 40,
              child: Center(
                child: Text(
                  day,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildCalendarGrid() {
    return Obx(() {
      final days = <Widget>[];

      // Empty cells for days before month starts
      for (int i = 0; i < controller.firstWeekdayOfMonth; i++) {
        days.add(
          SizedBox(
            width: 40,
            height: 40,
            child: Center(
              child: Text(
                '',
                style: TextStyle(color: Colors.grey.shade300, fontSize: 12),
              ),
            ),
          ),
        );
      }

      // Days of month
      for (int day = 1; day <= controller.daysInMonth; day++) {
        final isSelectable = controller.isDateSelectable(day);
        final isSelected = controller.isDateSelected(day);
        final isStart = controller.isStartDate(day);
        final isEnd = controller.isEndDate(day);

        days.add(_buildDayCell(day, isSelectable, isSelected, isStart, isEnd));
      }

      // Wrap in grid view
      return GridView.count(
        crossAxisCount: 7,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8,
        crossAxisSpacing: 4,
        children: days,
      );
    });
  }

  Widget _buildDayCell(
    int day,
    bool isSelectable,
    bool isSelected,
    bool isStart,
    bool isEnd,
  ) {
    Color? backgroundColor;
    Color textColor = Colors.black;

    if (isStart || isEnd) {
      backgroundColor = AppColors.authOrange;
      textColor = Colors.white;
    } else if (isSelected) {
      backgroundColor = AppColors.authOrange.withOpacity(0.6);
      textColor = Colors.white;
    }

    return GestureDetector(
      onTap: isSelectable ? () => controller.selectDate(day) : null,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: isStart || isEnd
              ? Border.all(color: Colors.orange, width: 2)
              : null,
        ),
        child: Center(
          child: Text(
            '$day',
            style: TextStyle(
              color: isSelectable ? textColor : Colors.grey.shade400,
              fontWeight: isStart || isEnd
                  ? FontWeight.bold
                  : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatesSummary() {
    return Obx(() {
      final startDate = controller.selectedStartDate.value;
      final endDate = controller.selectedEndDate.value;
      final totalDays = controller.getTotalDays();

      if (startDate == null) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFffe7d8), Color(0xFFFFFFFF), Color(0xFFf3f5c3)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),

            color: Colors.yellow.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.yellow.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Select a date to start planning your trip',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              ),
            ],
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFffe7d8), Color(0xFFFFFFFF), Color(0xFFf3f5c3)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDateCard(
              'Start Date',
              controller.formatDate(startDate),
              Colors.orange,
            ),
            SizedBox(width: 10),
            if (endDate != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$totalDays Days',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
            SizedBox(width: 10),
            _buildDateCard(
              'End Date',
              endDate != null ? controller.formatDate(endDate) : 'Select',
              endDate != null ? Colors.green : Colors.grey,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDateCard(String label, String date, Color color) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),

            child: Center(
              child: Text(
                date,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => Get.to(InterestView()),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.authOrange,
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Next',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
