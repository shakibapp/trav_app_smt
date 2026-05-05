import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_button.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/controller/tripltinerary_overview_controller.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/widget/build_card_widget.dart';
import 'package:hamishphipps/app/modules/general_user_flow/add_transportation_screen/view/add_transportation_screen.dart';

class TravelTabScreen extends StatelessWidget {
  final ItineraryDetailsController controller;
  const TravelTabScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Plan Your Transport',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Find the best way to travel between your destinations — flights, trains, or buses.',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 16),
        appButton(
          width: double.infinity,
          height: 45,
          bgColor: Colors.transparent,
          textColor: AppColors.blackColor,
          borderColor: Colors.grey.shade300,
          onTap: () => Get.to(() => AddTransportationView()),
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
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: controller.itineraryOverview.value?.transportations?.length ?? 0,
          itemBuilder: (context,index){
            final transport = controller.itineraryOverview.value!.transportations![index];

          return buildBookingOption(
            icon: Icons.flight_takeoff,
            title: '${transport.type}',
            description: '${transport.dpeartureLocation}',
            onExplore: () {},
          );
        },)
        
      ],
    );
  }
}
