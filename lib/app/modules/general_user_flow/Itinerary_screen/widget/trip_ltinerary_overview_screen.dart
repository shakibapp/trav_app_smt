import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_icons.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/controller/tripltinerary_overview_controller.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/widget/build_card_widget.dart';

class TripITineraryOverviewScreen extends StatelessWidget {
  final ItineraryDetailsController controller;
  const TripITineraryOverviewScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final itinerary = controller.itineraryOverview.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BuildStatCard(
                icon: AppIcons.moon,
                value: '${itinerary.days}',
                label: 'Night',
              ),
              SizedBox(width: 10),
              BuildStatCard(
                icon: AppIcons.activity,
                value: '${itinerary.activities?.length ?? 0}',
                label: 'Total Activity',
              ),
              SizedBox(width: 10),
              BuildStatCard(
                icon: AppIcons.appointment,
                value: '${itinerary.accommodations?.length ?? 0}',
                label: 'Total Bookings',
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Quick Info',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: itinerary.remainders?.length ?? 0,
              itemBuilder: (context, index) {
                final remainder = itinerary.remainders![index];
                return Padding(
                    padding: EdgeInsets.only(
                      bottom: 12.0,
                    ),
                    child: buildQuickInfoItem(
                      icon: index == 0 ? Icons.flight : Icons.home,
                      title: remainder.title ?? "No Title",
                      date: remainder.description?.toString() ?? "",
                      onTap: () {
                        if (index == 0) {
                          controller.selectedTabIndex.value = 2;
                        } else if (index == 1) {
                          controller.selectedTabIndex.value = 1;
                        }
                      },
                    ));
              })
        ],
      );
    });
  }
}
