import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hamishphipps/app/core/constants/app_button.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/core/constants/app_icons.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/controller/tripltinerary_overview_controller.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/widget/build_card_widget.dart';
import 'package:hamishphipps/app/modules/general_user_flow/add_accommodation_screen/view/add_accommodation_screen.dart';
import 'package:intl/intl.dart';

import '../../add_accommodation_screen/booking_with_card.dart';

class StayTabScreen extends StatelessWidget {
  final ItineraryDetailsController controller;
  const StayTabScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Find Your Stay',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Choose where you\'ll stay during your trip. Explore trusted platforms and book your accommodation.',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 16),
        appButton(
          width: double.infinity,
          height: 45,
          bgColor: Colors.transparent,
          textColor: AppColors.blackColor,
          borderColor: Colors.grey.shade300,
          onTap: () => Get.to(() => AddAccommodationView(
              id: controller.itineraryOverview.value.id?.toString() ?? "")),
          name: "Add Booking Details",
        ),
        const SizedBox(height: 14),
        ListView.builder(
            padding: EdgeInsets.zero,
            itemCount:
                controller.itineraryOverview.value.accommodations?.length ?? 0,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final accommodation =
                  controller.itineraryOverview.value.accommodations![index];
              return Obx(
                () => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () {
                      controller.selectedAccommodationIndex.value = index;
                    },
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: controller.selectedAccommodationIndex.value ==
                                  index
                              ? AppColors.authOrange
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: buildBookingOption(
                        icon: getAccommodationIcon(accommodation.type),
                        title: accommodation.name ?? "No Name",
                        description: accommodation.checkInDate != null
                            ? "Arriving ${DateFormat('dd MMM, yyyy').format(
                                DateTime.parse(
                                    accommodation.checkInDate.toString()),
                              )}"
                            : "Check-in date not set",
                        onExplore: () {},
                      ),
                    ),
                  ),
                ),
              );
            }),
        Obx(() {
          final accommodations =
              controller.itineraryOverview.value.accommodations;
          if (accommodations == null || accommodations.isEmpty) {
            return const SizedBox.shrink();
          }

          final index = controller.selectedAccommodationIndex.value;
          if (index < 0 || index >= accommodations.length) {
            return const SizedBox.shrink();
          }

          final selectedAccommodation = accommodations[index];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Book With',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: buildBookingPlatform(selectedAccommodation.type),
              ),
            ],
          );
        }),
      ],
    );
  }

  IconData getAccommodationIcon(String? type) {
    switch (type) {
      case "Hotel":
        return Icons.hotel;

      case "Hostel":
        return Icons.bed;

      case "Airbnb":
        return Icons.airplane_ticket_outlined;

      case "Guesthouse":
        return Icons.house;

      case "Resort":
        return Icons.beach_access;

      case "Camping":
        return Icons.forest;

      case "Other":
        return Icons.apartment;

      case "Not_Sure_Yet":
        return Icons.help_outline;

      default:
        return Icons.location_city;
    }
  }

  Widget buildBookingPlatform(String? type) {
    switch (type) {
      case "Hotel":
      case "Hostel":
        return BookingCard(
          title: "Hostelworld",
          subtitle: "Best for budget-friendly hostels and solo travelers",
          logoPath: AppIcons.hostelWorld,
          onTap: () {
            log("https://www.hostelworld.com/");
          },
        );

      case "Airbnb":
        return BookingCard(
          title: "Airbnb",
          subtitle: "Perfect for unique stays and local experiences",
          logoPath: AppIcons.airb,
          onTap: () {
            log("https://www.airbnb.com/");
          },
        );

      default:
        return BookingCard(
          title: "Booking.com",
          subtitle: "Great for hotels, resorts, and flexible options",
          logoPath: AppIcons.booking,
          onTap: () {
            log("https://www.booking.com/");
          },
        );
    }
  }
}
