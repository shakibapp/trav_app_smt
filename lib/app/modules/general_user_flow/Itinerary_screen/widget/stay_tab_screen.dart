

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hamishphipps/app/core/constants/app_button.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/widget/build_card_widget.dart';
import 'package:hamishphipps/app/modules/general_user_flow/add_accommodation_screen/view/add_accommodation_screen.dart';

class StayTabScreen extends StatelessWidget {
  const StayTabScreen({super.key});

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
          onTap: ()=>Get.to(()=>AddAccommodationView()),
          name: "Add Booking Details",
        ),

        const SizedBox(height: 24),
        const Text(
          'Book With',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        buildBookingOption(
          icon: Icons.apartment,
          title: 'Hostelworld',
          description: 'Budget-friendly hostels and apartments',
          onExplore: () {},
        ),
        const SizedBox(height: 12),
        buildBookingOption(
          icon: Icons.favorite_border,
          title: 'Airbnb',
          description: 'Perfect for unique stays and local experiences',
          onExplore: () {},
        ),
        const SizedBox(height: 12),
        buildBookingOption(
          icon: Icons.business,
          title: 'Booking.com',
          description: 'Hotels, rooms, and budget options',
          onExplore: () {},
        ),
      ],
    );
  }
}