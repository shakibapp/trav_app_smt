

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hamishphipps/app/core/constants/app_button.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/controller/tripltinerary_overview_controller.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/widget/build_card_widget.dart';
import 'package:hamishphipps/app/modules/general_user_flow/add_accommodation_screen/view/add_accommodation_screen.dart';

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
          onTap: ()=>Get.to(()=>AddAccommodationView()),
          name: "Add Booking Details",
        ),

        const SizedBox(height: 24),
        const Text(
          'Book With',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: controller.itineraryOverview.value?.accommodations?.length ?? 0,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index){
            final accommodation = controller.itineraryOverview.value!.accommodations![index];
          return buildBookingOption(
            icon: Icons.hotel,
            title: '${accommodation.name}',
            description: '${accommodation.address}',
            onExplore: () {},
          );
        }
        ),
      
      ],
    );
  }
}