import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/controller/tripltinerary_overview_controller.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/widget/activities_tab_screen.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/widget/build_card_widget.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/widget/itinerary_simmer.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/widget/stay_tab_screen.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/widget/travel_tab_screen.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/widget/trip_ltinerary_overview_screen.dart';
import 'package:intl/intl.dart';

class TripItineraryView extends StatelessWidget {
  final String itineraryId;
  TripItineraryView({super.key, required this.itineraryId});
  final controller = Get.put(ItineraryDetailsController());

  @override
  Widget build(BuildContext context) {
    controller.getItineraryOverview(itineraryId.toString());

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Obx(() {
        if (controller.isLoadingOverview.value) {
          return ItineraryShimmer();
        } else if (controller.itineraryOverview.value == null) {
          return Center(child: Text("No data found"));
        } else {
          final itinerary = controller.itineraryOverview.value;
          return Stack(
            children: [
              // Background image with gradient overlay
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.4),
                    ],
                  ),
                  image: DecorationImage(
                    image: NetworkImage(itinerary.image ?? ""),
                    fit: BoxFit.cover,
                  ),
                ),
                // child: Container(
                //   decoration: BoxDecoration(
                //     gradient: LinearGradient(
                //       begin: Alignment.topCenter,
                //       end: Alignment.bottomCenter,
                //       colors: [
                //         Colors.black.withOpacity(0.2),
                //         Colors.black.withOpacity(0.4),
                //       ],
                //     ),
                //   ),
                // ),
              ),
              // Main content
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top + 10),
                    // Header with trip info
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                    color:
                                        AppColors.orangeLight.withOpacity(0.3),
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
                          const SizedBox(height: 60),
                          // Destination info
                          Text(
                            itinerary.name ?? "Untitled Trip",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 3.0,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Trip details chips
                          if (itinerary.summary != null) ...[
                            Row(
                              children: [
                                buildChip(
                                  icon: Icons.hourglass_empty,
                                  label: '${itinerary.days ?? 0} Days',
                                ),
                                const SizedBox(width: 8),
                                if (itinerary.summary?.startDate != null &&
                                    itinerary.summary?.endDate != null)
                                  buildChip(
                                    icon: Icons.calendar_today,
                                    label:
                                        '${DateFormat('MMM dd').format(DateTime.parse(itinerary.summary!.startDate.toString()))} - ${DateFormat('MMM dd').format(DateTime.parse(itinerary.summary!.endDate.toString()))}',
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                buildChip(
                                  icon: Icons.attach_money,
                                  label:
                                      'Budget: ${itinerary.summary?.tripBudget ?? 0}',
                                ),
                                const SizedBox(width: 8),
                                buildChip(
                                  icon: Icons.hotel,
                                  label:
                                      '${itinerary.summary?.accommodation ?? 0}',
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(
                              height: 30), // Space before white container
                        ],
                      ),
                    ),

                    // ----------------------Tab bar and content---------------
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.7,
                      ),
                      child: Container(
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Custom Tab Bar
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 3,
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
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  Widget _buildTabContent(ItineraryDetailsController controller) {
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
              TripITineraryOverviewScreen(controller: controller)
            else if (controller.selectedTabIndex.value == 1)
              StayTabScreen(controller: controller)
            else if (controller.selectedTabIndex.value == 2)
              TravelTabScreen(controller: controller)
            else
              ActivitiesTabScreen(controller: controller),
          ],
        ),
      ),
    );
  }
}
