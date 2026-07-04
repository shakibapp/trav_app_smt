import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_button.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/core/widgets/app_input_textfield.dart';
import 'package:hamishphipps/app/modules/general_user_flow/add_accommodation_screen/controller/add_accommodation_controller.dart';
import 'package:hamishphipps/app/modules/general_user_flow/create_plan/widget/back_button_widget.dart';
import 'package:intl/intl.dart';

class AddAccommodationView extends StatelessWidget {
  final String id;
  final DateTime tripStartDate; 
  final DateTime tripEndDate;
  final bool isEdit;              
  final String? accommodationId;  
  AddAccommodationView(
      {super.key,
      required this.id,
      required this.tripStartDate,
      required this.tripEndDate,
      this.isEdit = false,          
    this.accommodationId});

  final AccommodationController controller = Get.put(AccommodationController());

  @override
  Widget build(BuildContext context) {
     if (isEdit && accommodationId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await controller.getSingleAccommodationDetails(accommodationId!);
        controller.prefillForm();
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: backButton(onTap: () => Get.back()),
        ),
        title:  Text(
          isEdit ? 'Edit Accommodation' : 'Add Accommodation',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Accommodation Name
              _buildAccommodationNameSection(),
              const SizedBox(height: 24),

              // Accommodation Type Selection
              _buildAccommodationTypeSection(),
              const SizedBox(height: 24),

              // Address
              _buildAddressSection(),
              const SizedBox(height: 24),

              // Booking Platform
              _buildBookingPlatformSection(),
              const SizedBox(height: 24),

              // Booking Reference
              _buildBookingReferenceSection(),
              const SizedBox(height: 24),

              // Number of Guests
              _buildNumberOfGuestsSection(),
              const SizedBox(height: 24),

              // Check-in and Check-out Dates
              _buildCheckInOutDateSection(context),
              const SizedBox(height: 24),

              // Currency and Total Cost
              _buildCurrencyCostSection(),
              const SizedBox(height: 24),

              // Payment Status
            
              _buildPaymentStatusSection(),
              const SizedBox(height: 24),
              Obx(() => controller.selectedPaymentStatus.value == 'Paid'
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        _buildAmountOwingSection(),
                        const SizedBox(height: 24),
                      ],
                    )),

              // Notes
              _buildNotesSection(),
              const SizedBox(height: 32),

              // Action Buttons
              _buildActionButtons(),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccommodationNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'NAME OF ACCOMMODATION *',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        AppInputTextField(
          controller: controller.accommodationNameController,
          hintText: 'e.g. Generator Barcelona Hostel',
          borderColor: Colors.grey,
          validator: controller.validateAccommodationName,
        ),
      ],
    );
  }

  Widget _buildAccommodationTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ACCOMMODATION TYPE *',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTypeButton(
                  'Hotel',
                  Icons.hotel,
                  'Hotel',
                  controller.selectedAccommodationType.value == 'Hotel',
                ),
                const SizedBox(width: 12),
                _buildTypeButton(
                  'Hostel',
                  Icons.house_outlined,
                  'Hostel',
                  controller.selectedAccommodationType.value == 'Hostel',
                ),
                const SizedBox(width: 12),
                _buildTypeButton(
                  'Airbnb',
                  Icons.local_airport,
                  'Airbnb',
                  controller.selectedAccommodationType.value == 'Airbnb',
                ),
                const SizedBox(width: 12),
                _buildTypeButton(
                  'Resort',
                  Icons.local_restaurant,
                  'Resort',
                  controller.selectedAccommodationType.value == 'Resort',
                ),
              ],
            ),
          ),
        ),
        Obx(
          () => controller.hasTypeError.value
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                  child: Text(
                    'Please select an accommodation type',
                    style: TextStyle(
                      color: Colors.red[700],
                      fontSize: 12,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildTypeButton(
    String label,
    IconData icon,
    String value,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () => controller.selectAccommodationType(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF8C42) : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF8C42) : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ADDRESS (OPTIONAL)',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        AppInputTextField(
          controller: controller.addressController,
          hintText: 'e.g. Carrer de Jolis 97, Rome, Italy',
          borderColor: Colors.grey,
        ),
      ],
    );
  }

  Widget _buildBookingPlatformSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'BOOKING PLATFORM',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.authFieldFill,
              border: Border.all(color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: controller.selectedBookingPlatform.value,
              isExpanded: true,
              underline: const SizedBox(),
              items: controller.bookingPlatforms.map((platform) {
                return DropdownMenuItem(value: platform, child: Text(platform));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.selectBookingPlatform(value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBookingReferenceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'BOOKING REFERENCE (OPTIONAL)',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        AppInputTextField(
          controller: controller.bookingReferenceController,
          hintText: 'e.g. HW-99234',
        ),
      ],
    );
  }

  Widget _buildNumberOfGuestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'NUMBER OF GUESTS (OPTIONAL)',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => controller.decrementGuests(),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: const Icon(Icons.remove, color: Color(0xFFFF8C42)),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      controller.numberOfGuests.value.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => controller.incrementGuests(),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: const Icon(Icons.add, color: Color(0xFFFF8C42)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckInOutDateSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CHECK-IN DATE *',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppInputTextField(
                    controller: controller.checkInDateController,
                    hintText: 'DD/MM/YY',
                    readOnly: true,
                    onTap: () =>
                        _selectDate(context, controller.checkInDateController),
                    validator: controller.validateCheckInDate,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CHECK-OUT DATE *',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppInputTextField(
                    controller: controller.checkOutDateController,
                    hintText: 'DD/MM/YY',
                    readOnly: true,
                    onTap: () =>
                        _selectDate(context, controller.checkOutDateController),
                    validator: controller.validateCheckOutDate,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrencyCostSection() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CURRENCY *',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.authFieldFill,
                    border: Border.all(color: AppColors.borderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: controller.selectedCurrency.value,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: controller.currencies.map((currency) {
                      return DropdownMenuItem(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.selectCurrency(value);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TOTAL COST *',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              AppInputTextField(
                controller: controller.totalCostController,
                hintText: '0.00',
                keyboardType: TextInputType.number,
                validator: controller.validateTotalCost,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PAYMENT STATUS *',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.authFieldFill,
              border: Border.all(color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: controller.selectedPaymentStatus.value,
              isExpanded: true,
              underline: const SizedBox(),
              items: controller.paymentStatuses.map((status) {
                return DropdownMenuItem(value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.selectPaymentStatus(value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountOwingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AMOUNT OWING *',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        AppInputTextField(
          controller: controller.amountOwingController,
          hintText: '0.0',
          keyboardType: TextInputType.number,
          validator: controller.validateAmountOwing,
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'NOTES (OPTIONAL)',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        AppInputTextField(
          controller: controller.notesController,
          hintText: 'Note..',
          maxLines: 3,
          minLines: 3,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: appButton(
            bgColor: Colors.transparent,
            onTap: () {
              controller.clearForm();
              Get.back();
            },
            name: "Cancel",
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Obx(() {
            return appButton(
              loading: controller.isAddAccommodationLoading.value,
              textColor: Colors.white,
              onTap: () async {
                if (isEdit && accommodationId != null) {
                await controller.updateAccommodation(accommodationId!, id); // ✅
              } else {
                await controller.createNewAccommodation(id);
              }
              },
              name: isEdit ? "Update" : "Save", 
            );
          }),
        ),
      ],
    );
  }

  // void _selectDate(
  //   BuildContext context,
  //   TextEditingController textController,
  // ) async {
  //   DateTime now = DateTime.now();

  //   DateTime firstDate = DateTime(
  //     now.year,
  //     now.month,
  //     now.day,
  //   );

  //   DateTime initialDate = firstDate;

  //   // Check-out date হলে check-in এর পরে start করবে
  //   if (textController == controller.checkOutDateController &&
  //       controller.checkInDateController.text.isNotEmpty) {
  //     final checkInDate = DateFormat(
  //       'dd/MM/yy',
  //     ).parse(controller.checkInDateController.text);

  //     firstDate = checkInDate.add(
  //       const Duration(days: 1),
  //     );

  //     initialDate = firstDate;
  //   }

  //   final selectedDate = await showDatePicker(
  //     context: context,
  //     initialDate: initialDate,
  //     firstDate: firstDate,
  //     lastDate: DateTime(2030),
  //   );

  //   if (selectedDate != null) {
  //     textController.text = '${selectedDate.day.toString().padLeft(2, '0')}/'
  //         '${selectedDate.month.toString().padLeft(2, '0')}/'
  //         '${selectedDate.year.toString().substring(2)}';
  //   }
  // }
  void _selectDate(
    BuildContext context,
    TextEditingController textController,
  ) async {
    // ✅ Trip range অনুযায়ী firstDate এবং lastDate
    DateTime firstDate = DateTime(
      tripStartDate.year,
      tripStartDate.month,
      tripStartDate.day,
    );
    DateTime lastDate = DateTime(
      tripEndDate.year,
      tripEndDate.month,
      tripEndDate.day,
    );

    DateTime initialDate = firstDate;

    // ✅ Check-out date হলে check-in এর পরের দিন থেকে শুরু
    if (textController == controller.checkOutDateController &&
        controller.checkInDateController.text.isNotEmpty) {
      final checkInDate =
          DateFormat('dd/MM/yy').parse(controller.checkInDateController.text);
      final nextDay = checkInDate.add(const Duration(days: 1));
      firstDate = nextDay.isAfter(lastDate) ? lastDate : nextDay;
      initialDate = firstDate;
    }

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate, // ✅ trip end date এর পরে যাবে না
    );

    if (selectedDate != null) {
      textController.text = '${selectedDate.day.toString().padLeft(2, '0')}/'
          '${selectedDate.month.toString().padLeft(2, '0')}/'
          '${selectedDate.year.toString().substring(2)}';

      // ✅ Check-in পরিবর্তন হলে checkout clear
      if (textController == controller.checkInDateController &&
          controller.checkOutDateController.text.isNotEmpty) {
        try {
          final checkOut = DateFormat('dd/MM/yy')
              .parse(controller.checkOutDateController.text);
          if (selectedDate.isAfter(checkOut)) {
            controller.checkOutDateController.clear();
          }
        } catch (_) {}
      }
    }
  }
}
