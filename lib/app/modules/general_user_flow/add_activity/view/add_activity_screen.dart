import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/modules/general_user_flow/add_activity/controller/add_activity_controller.dart';
import 'package:hamishphipps/app/modules/general_user_flow/add_activity/model/add_activity_model.dart';
import '../../../../core/utils/date_formatter.dart';
import 'package:hamishphipps/app/modules/general_user_flow/create_plan/widget/back_button_widget.dart';

class AddActivityView extends StatelessWidget {
  final String id;
  AddActivityView({super.key, required this.id});
  final controller = Get.put(AddActivityController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Add Activities',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: backButton(),
        ),
        elevation: 0,
        backgroundColor: AppColors.bgColor,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Activity Name
              _buildActivityNameField(),
              SizedBox(height: 24),

              // Day Number
              _buildDayNumberDropdown(),
              SizedBox(height: 24),

              // Categories
              _buildCategoriesSection(),
              SizedBox(height: 24),

              // Dates Section
              _buildDatesSection(),
              SizedBox(height: 24),

              // Times Section
              _buildTimesSection(),
              SizedBox(height: 24),

              // Location
              _buildLocationField(),
              SizedBox(height: 24),

              // Expense
              _buildExpenseField(),
              SizedBox(height: 32),

              // Action Buttons
              _buildActionButtons(),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Activity Name Field
  Widget _buildActivityNameField() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('ACTIVITY NAME', isRequired: true),
          SizedBox(height: 8),
          TextField(
            controller: controller.activityNameController,
            decoration: _buildInputDecoration(
              hintText: 'e.g. City Exploring Tour',
              errorText: controller.activityNameError.value,
            ),
            maxLength: 100,
            buildCounter: (
              context, {
              required currentLength,
              required isFocused,
              maxLength,
            }) {
              return Text(
                '$currentLength/$maxLength',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              );
            },
          ),
        ],
      ),
    );
  }

  // Day Number Dropdown
  Widget _buildDayNumberDropdown() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('DAY NUMBER', isRequired: true),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.authFieldFill,
              border: Border.all(
                color: controller.dayNumberError.value != null
                    ? Colors.red
                    : AppColors.borderColor,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<int>(
              value: controller.selectedDayNumber.value,
              hint: Text('Day Number 1'),
              isExpanded: true,
              underline: SizedBox(),
              items: List.generate(30, (index) => index + 1)
                  .map(
                    (day) => DropdownMenuItem(
                      value: day,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Day $day'),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                controller.selectedDayNumber.value = value;
              },
            ),
          ),
          if (controller.dayNumberError.value != null)
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                controller.dayNumberError.value!,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  // Categories Section
  Widget _buildCategoriesSection() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('CATEGORIES', isRequired: true),
          SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: ActivityCategory.values.map((category) {
              final isSelected = controller.selectedCategories.contains(
                category,
              );
              return _buildCategoryChip(category, isSelected);
            }).toList(),
          ),
          if (controller.categoriesError.value != null)
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                controller.categoriesError.value!,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  // Category Chip
  Widget _buildCategoryChip(ActivityCategory category, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.toggleCategory(category),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.authOrange : Colors.grey[100],
          border: Border.all(
            color: isSelected ? AppColors.authOrange : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            SizedBox(width: 6),
            Text(
              category.label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dates Section
  Widget _buildDatesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Start Date
        Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('START DATE', isRequired: true),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () => controller.selectStartDate(Get.context!),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: controller.startDateError.value != null
                          ? Colors.red
                          : Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[50],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 12),
                      Text(
                        controller.selectedStartDate.value != null
                            ? _formatDate(controller.selectedStartDate.value!)
                            : 'DD/MM/YY',
                        style: TextStyle(
                          color: controller.selectedStartDate.value != null
                              ? Colors.black
                              : Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (controller.startDateError.value != null)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    controller.startDateError.value!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 16),

        // End Date
        Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('END DATE', isRequired: true),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () => controller.selectEndDate(Get.context!),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: controller.endDateError.value != null
                          ? Colors.red
                          : Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[50],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 12),
                      Text(
                        controller.selectedEndDate.value != null
                            ? _formatDate(controller.selectedEndDate.value!)
                            : 'DD/MM/YY',
                        style: TextStyle(
                          color: controller.selectedEndDate.value != null
                              ? Colors.black
                              : Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (controller.endDateError.value != null)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    controller.endDateError.value!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // Times Section
  Widget _buildTimesSection() {
    return Row(
      children: [
        Expanded(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel('START TIME', isRequired: true),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () => controller.selectStartTime(Get.context!),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: controller.startTimeError.value != null
                            ? Colors.red
                            : Colors.grey[300]!,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[50],
                    ),
                    child: Center(
                      child: Text(
                        controller.startTimeController.text.isNotEmpty
                            ? controller.startTimeController.text
                            : 'HH:MM',
                        style: TextStyle(
                          color: controller.startTimeController.text.isNotEmpty
                              ? Colors.black
                              : Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                if (controller.startTimeError.value != null)
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      controller.startTimeError.value!,
                      style: TextStyle(color: Colors.red, fontSize: 11),
                    ),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel('END TIME', isRequired: true),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () => controller.selectEndTime(Get.context!),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: controller.endTimeError.value != null
                            ? Colors.red
                            : Colors.grey[300]!,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[50],
                    ),
                    child: Center(
                      child: Text(
                        controller.endTimeController.text.isNotEmpty
                            ? controller.endTimeController.text
                            : 'HH:MM',
                        style: TextStyle(
                          color: controller.endTimeController.text.isNotEmpty
                              ? Colors.black
                              : Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                if (controller.endTimeError.value != null)
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      controller.endTimeError.value!,
                      style: TextStyle(color: Colors.red, fontSize: 11),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Location Field
  Widget _buildLocationField() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('LOCATION/ADDRESS', isRequired: false),
          SizedBox(height: 8),
          TextField(
            controller: controller.locationController,
            decoration: _buildInputDecoration(
              hintText: 'Address',
              errorText: controller.locationError.value,
            ),
            maxLength: 200,
            buildCounter: (
              context, {
              required currentLength,
              required isFocused,
              maxLength,
            }) {
              return Text(
                '$currentLength/$maxLength',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              );
            },
          ),
        ],
      ),
    );
  }

  // Expense Field
  Widget _buildExpenseField() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('EXPENSE', isRequired: false),
          SizedBox(height: 8),
          TextField(
            controller: controller.expenseController,
            decoration: _buildInputDecoration(
              hintText: 'Amount',
              errorText: controller.expenseError.value,
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              // Add currency formatter if needed
            ],
          ),
        ],
      ),
    );
  }

  // Action Buttons
  Widget _buildActionButtons() {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: controller.isLoading.value ? null : controller.cancel,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: AppColors.authOrange),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.authOrange,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Obx(() {
              return ElevatedButton(
                onPressed: () => controller.createActivity(id.toString()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.authOrange,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: controller.isLoading.value
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // Helper Widgets
  Widget _buildLabel(String text, {required bool isRequired}) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
            letterSpacing: 0.5,
          ),
        ),
        if (isRequired)
          Text(
            ' *',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
      ],
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    String? errorText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: errorText != null ? Colors.red : Colors.grey[300]!,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: errorText != null ? Colors.red : AppColors.authOrange,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }

  String _formatDate(DateTime date) {
    return AppDateFormatter.format(date);
  }
}
