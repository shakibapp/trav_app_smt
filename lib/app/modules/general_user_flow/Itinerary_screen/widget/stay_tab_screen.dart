import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hamishphipps/app/core/constants/app_button.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/core/constants/app_icons.dart';
import 'package:hamishphipps/app/core/constants/url_luncher.dart';
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
              return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () {
                     
                    },
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color:  Colors.transparent,
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
                );
            }),
             Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                'Book With',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: buildBookingPlatform(controller.itineraryOverview.value.accommodation),
              ),
            ],
          ),
       
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
    case "Resort":
      return BookingCard(
        title: "Booking.com",
        subtitle: "Great for hotels, resorts, and flexible options",
        logoPath: AppIcons.booking,
        onTap: () => launchBookingUrl("https://www.booking.com/"),
      );

    case "Airbnb":
      return BookingCard(
        title: "Airbnb",
        subtitle: "Perfect for unique stays and local experiences",
        logoPath: AppIcons.airb,
        onTap: () => launchBookingUrl("https://www.airbnb.com/"),
      );

    case "Hostel":
      return BookingCard(
        title: "Hostelworld",
        subtitle: "Best for budget-friendly hostels and solo travelers",
        logoPath: AppIcons.hostelWorld,
        onTap: () => launchBookingUrl("https://www.hostelworld.com/"),
      );

    case "Not_Sure_Yet":
      return Column(
        children: [
          BookingCard(
            title: "Booking.com",
            subtitle: "Great for hotels, resorts, and flexible options",
            logoPath: AppIcons.booking,
            onTap: () => launchBookingUrl("https://www.booking.com/"),
          ),
          const SizedBox(height: 12),
          BookingCard(
            title: "Airbnb",
            subtitle: "Perfect for unique stays and local experiences",
            logoPath: AppIcons.airb,
            onTap: () => launchBookingUrl("https://www.airbnb.com/"),
          ),
          const SizedBox(height: 12),
          BookingCard(
            title: "Hostelworld",
            subtitle: "Best for budget-friendly hostels and solo travelers",
            logoPath: AppIcons.hostelWorld,
            onTap: () => launchBookingUrl("https://www.hostelworld.com/"),
          ),
        ],
      );

    default:
      return BookingCard(
        title: "Booking.com",
        subtitle: "Great for hotels, resorts, and flexible options",
        logoPath: AppIcons.booking,
        onTap: () => launchBookingUrl("https://www.booking.com/"),
      );
  }
}
}
