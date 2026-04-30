import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_icons.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/controller/tripltinerary_overview_controller.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/widget/build_card_widget.dart';

class TripITineraryOverviewScreen extends StatelessWidget {

   TripITineraryOverviewScreen({super.key});
  final controller = Get.put(TripController());

  @override
  Widget build(BuildContext context) {
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BuildStatCard(
              icon: AppIcons.moon,
              value: '${controller.currentTrip.value.duration}',
              label: 'Night',
            ),
            SizedBox(width: 10),
            BuildStatCard(
              icon: AppIcons.activity,
              value: '7',
              label: 'Total Activity',
            ),
            SizedBox(width: 10),
            BuildStatCard(
              icon: AppIcons.appointment,
              value: '8',
              label: 'Total Bookings',
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Quick Info',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        buildQuickInfoItem(
          icon: Icons.flight,
          title: 'Book flight to Rome',
          date: 'Arriving 20 Mar, 2025',
          onTap: () => controller.changeTab(2),
        ),
        const SizedBox(height: 12),
        buildQuickInfoItem(
          icon: Icons.hotel,
          title: 'Book accommodation in Rome',
          date: 'Arriving 20 Mar, 2025',
          onTap: () => controller.changeTab(1),
        ),
      ],
    );
  }
}