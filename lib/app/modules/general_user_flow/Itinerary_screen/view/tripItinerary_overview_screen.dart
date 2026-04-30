import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/controller/tripltinerary_overview_controller.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/widget/activities_tab_screen.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/widget/build_card_widget.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/widget/stay_tab_screen.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/widget/travel_tab_screen.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/widget/trip_ltinerary_overview_screen.dart';

class TripItineraryView extends StatelessWidget {
  const TripItineraryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TripController());

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Obx(
        () => Stack(
          children: [
            // Background image with gradient overlay
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/italy.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.4),
                    ],
                  ),
                ),
              ),
            ),
            // Main content
            SingleChildScrollView(
              child: Column(
                children: [
                  // Header with trip info
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back button and title
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: AppColors.orangeLight.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: AppColors.authOrange,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Itinerary details',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Destination info
                        Text(
                          controller.currentTrip.value.destination,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.currentTrip.value.country,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Trip details chips
                        Row(
                          children: [
                            buildChip(
                              icon: Icons.calendar_today,
                              label:
                                  controller.formatDate(
                                    controller.currentTrip.value.startDate,
                                  ) +
                                  ' - ' +
                                  controller.formatDate(
                                    controller.currentTrip.value.endDate,
                                  ),
                            ),
                            const SizedBox(width: 8),
                            buildChip(
                              icon: Icons.hourglass_empty,
                              label:
                                  '${controller.currentTrip.value.duration} Days',
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            buildChip(
                              icon: Icons.attach_money,
                              label:
                                  '\$${controller.currentTrip.value.budget.toStringAsFixed(2)}',
                            ),
                            const SizedBox(width: 8),
                            buildChip(
                              icon: Icons.hotel,
                              label: 'Accommodation',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ----------------------Tab bar and content---------------
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Custom Tab Bar
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 5,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              children: [
                                buildTab(
                                  label: 'Overview',
                                  icon: Icons.apps_rounded,
                                  index: 0,
                                  controller: controller,
                                ),
                                buildTab(
                                  label: 'Stay',
                                  icon: Icons.bed_rounded,
                                  index: 1,
                                  controller: controller,
                                ),
                                buildTab(
                                  label: 'Travel',
                                  icon: Icons.directions_car_rounded,
                                  index: 2,
                                  controller: controller,
                                ),
                                buildTab(
                                  label: 'Activities',
                                  icon: Icons.local_activity,
                                  index: 3,
                                  controller: controller,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Tab content
                        _buildTabContent(controller),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(TripController controller) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        key: ValueKey(controller.selectedTabIndex.value),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.selectedTabIndex.value == 0)
              TripITineraryOverviewScreen()
            else if (controller.selectedTabIndex.value == 1)
              StayTabScreen()
            else if (controller.selectedTabIndex.value == 2)
              TravelTabScreen()
            else
              ActivitiesTabScreen(),
          ],
        ),
      ),
    );
  }
}
