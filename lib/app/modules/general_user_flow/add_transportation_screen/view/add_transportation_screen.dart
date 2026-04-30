import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_button.dart';
import 'package:hamishphipps/app/core/widgets/app_input_textfield.dart';
import 'package:hamishphipps/app/modules/general_user_flow/add_transportation_screen/controller/add_transportation_controller.dart';
import 'package:hamishphipps/app/modules/general_user_flow/create_plan/widget/back_button_widget.dart';

class AddTransportationView extends StatelessWidget {
  AddTransportationView({super.key});

  final TransportationController controller = Get.put(
    TransportationController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: backButton(),
        ),
        title: const Text(
          'Add Transportation',
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
              // Transportation Type Selection
              _buildTransportationTypeSection(),
              const SizedBox(height: 24),

              // Departure and Arrival Location
              _buildLocationSection(),
              const SizedBox(height: 24),

              // Departure and Arrival Date & Time
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DEPARTURE DATE *',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        AppInputTextField(
                          controller: controller.departureDateController,
                          hintText: 'DD/MM/YY',
                          readOnly: true,
                          onTap: () => _selectDate(
                            context,
                            controller.departureDateController,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
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
                          'DEPARTURE TIME *',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        AppInputTextField(
                          controller: controller.departureTimeController,
                          hintText: 'time',
                          readOnly: true,
                          onTap: () => _selectTime(
                            context,
                            controller.departureTimeController,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ARRIVAL DATE *',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        AppInputTextField(
                          controller: controller.arrivalDateController,
                          hintText: 'DD/MM/YY',
                          readOnly: true,
                          onTap: () => _selectDate(
                            context,
                            controller.arrivalDateController,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
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
                          'ARRIVAL TIME *',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        AppInputTextField(
                          controller: controller.arrivalTimeController,
                          hintText: 'time',
                          readOnly: true,
                          onTap: () => _selectTime(
                            context,
                            controller.arrivalTimeController,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Booking Platform
              _buildBookingPlatformSection(),
              const SizedBox(height: 24),

              // Booking Reference
              _buildBookingReferenceSection(),
              const SizedBox(height: 24),

              // Airline & Flight Number
              _buildAirlineFlightSection(),
              const SizedBox(height: 24),

              // Terminal & Gate
              _buildTerminalGateSection(),
              const SizedBox(height: 24),

              // Seat
              _buildSeatSection(),
              const SizedBox(height: 24),

              // Currency & Total Cost
              _buildCurrencyCostSection(),
              const SizedBox(height: 24),

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

  Widget _buildTransportationTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transportation Type',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              children: [
                _buildTransportationButton(
                  'Flight',
                  Icons.flight,
                  'Flight',
                  controller.selectedTransportationType.value == 'Flight',
                ),
                const SizedBox(width: 12),
                _buildTransportationButton(
                  'Bus',
                  Icons.directions_bus,
                  'Bus',
                  controller.selectedTransportationType.value == 'Bus',
                ),
                const SizedBox(width: 12),
                _buildTransportationButton(
                  'Train',
                  Icons.train,
                  'Train',
                  controller.selectedTransportationType.value == 'Train',
                ),
                const SizedBox(width: 12),
                _buildTransportationButton(
                  'Car',
                  Icons.directions_car,
                  'Car',
                  controller.selectedTransportationType.value == 'Car',
                ),
                const SizedBox(width: 12),
                _buildTransportationButton(
                  'Ferry',
                  Icons.directions_boat,
                  'Ferry',
                  controller.selectedTransportationType.value == 'Ferry',
                ),
                const SizedBox(width: 12),
                _buildTransportationButton(
                  'Other',
                  Icons.more_horiz,
                  'Other',
                  controller.selectedTransportationType.value == 'Other',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransportationButton(
    String label,
    IconData icon,
    String value,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () => controller.selectTransportationType(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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

  Widget _buildLocationSection() {
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
                    'DEPARTURE LOCATION *',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppInputTextField(
                    controller: controller.departureLocationController,
                    hintText: 'e.g. Melbourne Airport T?',

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
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
                    'ARRIVAL LOCATION *',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppInputTextField(
                    controller: controller.arrivalLocationController,
                    hintText: 'e.g. Rome Airport',

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
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
              color: Color(0xFFF6F6F6),
              border: Border.all(color: Color(0xFFC5D3E2)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: controller.selectedBookingPlatform.value,
              isExpanded: true,
              underline: const SizedBox(),
              items: ['Skyscanner', 'Expedia', 'Booking.com', 'Kayak'].map((
                platform,
              ) {
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
          hintText: 'e.g. QR-28473',
        ),
      ],
    );
  }

  Widget _buildAirlineFlightSection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AIRLINE (OPTIONAL)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              AppInputTextField(
                controller: controller.airlineController,
                hintText: 'e.g. Qatar Airways',
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
                'FLIGHT NUMBER (OPTIONAL)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              AppInputTextField(
                controller: controller.flightNumberController,
                hintText: 'e.g. QR728',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTerminalGateSection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TERMINAL (OPTIONAL)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              AppInputTextField(
                controller: controller.terminalController,
                hintText: 'e.g. T1',
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
                'GATE (OPTIONAL)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              AppInputTextField(
                controller: controller.gateController,
                hintText: 'e.g. B42',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSeatSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SEAT (OPTIONAL)',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        AppInputTextField(
          controller: controller.seatController,
          hintText: 'e.g. 24A',
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
                    color: Color(0xFFF6F6F6),
                    border: Border.all(color: Color(0xFFC5D3E2)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: controller.selectedCurrency.value,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: ['EUR', 'USD', 'GBP', 'INR', 'BDT'].map((currency) {
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Invalid';
                  }
                  return null;
                },
              ),
            ],
          ),
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
          hintText: 'describe',
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
          child: appButton(
            textColor: Colors.white,

            onTap: () => controller.saveForm(),
            name: "Save",
          ),
        ),
      ],
    );
  }

  void _selectDate(BuildContext context, TextEditingController controller) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    ).then((selectedDate) {
      if (selectedDate != null) {
        controller.text =
            '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year.toString().substring(2)}';
      }
    });
  }

  void _selectTime(BuildContext context, TextEditingController controller) {
    showTimePicker(context: context, initialTime: TimeOfDay.now()).then((
      selectedTime,
    ) {
      if (selectedTime != null) {
        controller.text =
            '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
      }
    });
  }
}
