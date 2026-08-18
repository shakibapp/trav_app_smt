import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/modules/general_user_flow/create_plan/controller/create_plan_controller.dart';

import 'package:hamishphipps/app/modules/general_user_flow/create_plan/widget/back_button_widget.dart';

import '../city/controller/city_controller.dart';
import '../controller/create_plan_calender_controller.dart';
import '../controller/stay_controller.dart';

class StayView extends StatelessWidget {
  final StayController controller = Get.put(StayController());
  final CityController cityController = Get.find<CityController>();
  final CreatePlanController createPlanController =
      Get.find<CreatePlanController>(tag: 'create_plan');

  StayView({super.key});

  @override
  Widget build(BuildContext context) {
    final tripResponse = createPlanController.tripResponse.value;
    if (tripResponse != null &&
        tripResponse['itineraries'] != null &&
        tripResponse['itineraries'] is List) {
      controller.loadFromTripResponse(tripResponse);
    } else {
      final selectedCityNames =
          cityController.selectedCities.map((e) => e.name).toList();
      final currentCityNames =
          controller.locations.map((e) => e.cityName).toList();

      if (selectedCityNames.isNotEmpty &&
          (selectedCityNames.length != currentCityNames.length ||
              selectedCityNames
                  .any((name) => !currentCityNames.contains(name)))) {
        controller.locations.assignAll(
          selectedCityNames
              .map((name) => StayLocation(cityName: name))
              .toList(),
        );

        // Distribute total days among cities
        try {
          final dateCtrl = Get.find<DatePickerController>();
          final totalDays = dateCtrl.getTotalDays();
          if (totalDays > 0) {
            controller.distributeDaysToCities(totalDays);
          }
        } catch (e) {
          // Date controller not found, skip distribution
        }
      }
    }

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              backButton(onTap: () {
                Get.back();
              }),
              SizedBox(height: 10),

              Text(
                "Where do you like to stay?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                "We'll include this in your itinerary",
                style: TextStyle(color: Colors.grey),
              ),

              SizedBox(height: 14),

              // Summary Card (6 Days)
              Obx(
                () => Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFffe7d8),
                        Color(0xFFFFFFFF),
                        Color(0xFFf3f5c3),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Based on your Stops",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        "${controller.totalDays} Days",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Calculated from your ${controller.locations.length} stops.",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 14),

              // List of Stay Cards
              Obx(
                () => ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.locations.length,
                  separatorBuilder: (context, index) => SizedBox(height: 15),
                  itemBuilder: (context, index) => _buildStayCard(index),
                ),
              ),

              SizedBox(height: 14),

            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(() {
        if (!controller.isReadyToProceed) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40, top: 10),
          child: SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: createPlanController.isSubmitting.value ||
                      createPlanController.isManualSubmitting.value
                  ? null
                  : controller.goTripDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.authOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: createPlanController.isSubmitting.value ||
                      createPlanController.isManualSubmitting.value
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text(
                      "Next",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStayCard(int index) {
    final location = controller.locations[index];
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.black54,
                child: Text(
                  "${index + 1}",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              SizedBox(width: 10),
              Text(
                location.cityName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            "Number of Stays",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Obx(
                    () => Text(
                      "${location.stayDays.value}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              _qtyBtn(Icons.remove, () => controller.decrementDays(index)),
              SizedBox(width: 5),
              _qtyBtn(Icons.add, () => controller.incrementDays(index)),
            ],
          ),
          SizedBox(height: 15),
          _sectionTitle("Accommodation"),
          Wrap(
            spacing: 8,
            children: [
              _choiceChip("Hotel", location.selectedAccommodation, index, true),
              _choiceChip(
                "Hostel",
                location.selectedAccommodation,
                index,
                true,
              ),
              _choiceChip(
                "Airbnb",
                location.selectedAccommodation,
                index,
                true,
              ),
              _choiceChip(
                "Resort",
                location.selectedAccommodation,
                index,
                true,
              ),
              _choiceChip(
                "Not Sure Yet",
                location.selectedAccommodation,
                index,
                true,
              ),
            ],
          ),
          SizedBox(height: 15),
          _sectionTitle("Getting There"),
          Wrap(
            spacing: 8,
            children: [
              _choiceChip("Flight", location.selectedTransport, index, false),
              _choiceChip("Bus", location.selectedTransport, index, false),
              _choiceChip("Train", location.selectedTransport, index, false),
              _choiceChip(
                "Car Rental",
                location.selectedTransport,
                index,
                false,
              ),
              _choiceChip(
                "Not Sure Yet",
                location.selectedTransport,
                index,
                false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      );

  Widget _qtyBtn(IconData icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.authOrange,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      );

  // Widget _choiceChip(
  //   String label,
  //   RxString selectedValue,
  //   int index,
  //   bool isAccommodation,
  // ) {
  //   return Obx(() {
  //     bool isSelected = selectedValue.value == label;
  //     return FilterChip(
  //       label: Text(
  //         label,
  //         style: TextStyle(
  //           fontSize: 12,
  //           color: isSelected ? Colors.orange : Colors.black,
  //         ),
  //       ),
  //       selected: isSelected,
  //       onSelected: (v) => isAccommodation
  //           ? controller.selectAccommodation(index, label)
  //           : controller.selectTransport(index, label),
  //       backgroundColor: Colors.white,
  //       selectedColor: Colors.orange.withOpacity(0.1),
  //       shape: StadiumBorder(
  //         side: BorderSide(
  //           color: isSelected ? Colors.orange : Colors.grey.shade200,
  //         ),
  //       ),
  //       showCheckmark: false,
  //     );
  //   });
  // }
  Widget _choiceChip(
    String label,
    RxString selectedValue,
    int index,
    bool isAccommodation,
  ) {
    final location = controller.locations[index];
    final backendValue = label.replaceAll(' ', '_');

    return Obx(() {
      final isSelected = selectedValue.value == backendValue;
      // ✅ Show spinner only on the chip being updated
      final isThisLoading = location.isUpdating.value &&
          ((isAccommodation &&
                  location.updatingField.value == 'accommodation') ||
              (!isAccommodation &&
                  location.updatingField.value == 'transport')) &&
          isSelected;
      // ✅ Disable all chips in this group while updating
      final isDisabled = location.isUpdating.value;

      return FilterChip(
        label: isThisLoading
            ? SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: Colors.orange,
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDisabled
                      ? Colors.grey.shade400
                      : isSelected
                          ? Colors.orange
                          : Colors.black,
                ),
              ),
        selected: isSelected,
        onSelected: isDisabled
            ? null // ✅ Disable tap while loading
            : (v) => isAccommodation
                ? controller.selectAccommodation(index, backendValue)
                : controller.selectTransport(index, backendValue),
        backgroundColor: Colors.white,
        selectedColor: Colors.orange.withOpacity(0.1),
        disabledColor: Colors.grey.shade100,
        shape: StadiumBorder(
          side: BorderSide(
            color: isDisabled
                ? Colors.grey.shade200
                : isSelected
                    ? Colors.orange
                    : Colors.grey.shade200,
          ),
        ),
        showCheckmark: false,
      );
    });
  }
}
