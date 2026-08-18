import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_button.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/core/constants/app_icons.dart';
import 'package:hamishphipps/app/core/widgets/network_image.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/view/tripItinerary_overview_screen.dart';
import 'package:hamishphipps/app/modules/general_user_flow/create_plan/widget/back_button_widget.dart';
import 'package:hamishphipps/app/modules/general_user_flow/nav_bar/controller/nav_bar_controller.dart';
import 'package:hamishphipps/app/modules/general_user_flow/trip_details_screen/controller/trip_details_controller.dart';
import 'package:hamishphipps/app/modules/general_user_flow/trip_details_screen/model/trip_details_model.dart';
import 'package:intl/intl.dart';

import '../widget/trip_details_widget.dart';

class TripDetailsScreen extends StatelessWidget {
  final String tripId;
  final bool isFromCreatePlan;

  TripDetailsScreen(
      {super.key, required this.tripId, this.isFromCreatePlan = false});

  final controller = Get.put(TripDetailsController());

  @override
  Widget build(BuildContext context) {
    controller.getSingleTripData(tripId);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Obx(() {
            if (controller.isTripDetailsLoading.value) {
              return _buildLoadingSkeleton();
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(controller),
                  _buildRemindersSection(controller),
                  SizedBox(height: 15),
                  _buildPriorityRemindersSection(controller),
                  SizedBox(height: 20),
                  Obx(() => controller.showOptimizeCard.value
                      ? _buildOptimizeRouteSection(controller)
                      : const SizedBox()),
                  _buildItinerarySection(controller),
                  const SizedBox(height: 30),
                ],
              );
            }
          }),
        ),
      ),
    );
  }

  // ─── Header ──────────
  Widget _buildHeader(TripDetailsController controller) {
    final data = controller.singleTripData.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            backButton(onTap: () {
              if (isFromCreatePlan == true) {
                final navController = Get.find<NavBarController>();
                navController.setIndex(0);
                Get.offAllNamed('/navbar');
              } else {
                Get.back();
              }
            }),
            const SizedBox(width: 12),
            Text(
              'Your Itinerary',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: Colors.grey[300],
            height: 220.h,
            child: Stack(
              children: [
                AppNetworkImage(
                  imageUrl: data.images?.isNotEmpty ?? false
                      ? data.images![0]
                      : 'https://media.istockphoto.com/id/904172104/photo/weve-made-it-all-this-way-i-am-proud.jpg?b=1&s=612x612&w=0&k=20&c=JRmndTMyz627jxKiUjgXSJXrxwuAiHkHjefiRsyY2jc=',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 15,
                  left: 15,
                  right: 15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (data.region != null && data.region!.isNotEmpty)
                            ? data.region!.join(",")
                            : 'Unknown Region',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Wrap(
                        children: [
                          _buildInfoChip(
                            formatDateRange(data.startDate?.toString(),
                                data.endDate?.toString()),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  String formatDateRange(String? startDate, String? endDate) {
    if (startDate == null ||
        startDate == 'null' ||
        endDate == null ||
        endDate == 'null') {
      return 'Dates unknown';
    }
    try {
      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);
      if (start.year == end.year) {
        return '${DateFormat('MMM d').format(start)} – '
            '${DateFormat('MMM d, y').format(end)}';
      } else {
        return '${DateFormat('MMM d, y').format(start)} – '
            '${DateFormat('MMM d, y').format(end)}';
      }
    } catch (e) {
      return 'Dates unknown';
    }
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Loading Skeleton ──────
  Widget _buildLoadingSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const ShimmerBox(
            width: 180,
            height: 24,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        const SizedBox(height: 10),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 2,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return Container(
                width: 300,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ShimmerBox(
                        width: 40,
                        height: 40,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    SizedBox(height: 14),
                    ShimmerBox(width: 120, height: 18),
                    SizedBox(height: 8),
                    ShimmerBox(width: 180, height: 14),
                    SizedBox(height: 14),
                    ShimmerBox(
                        width: 100,
                        height: 32,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        const ShimmerBox(
            width: double.infinity,
            height: 20,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        const SizedBox(height: 12),
        const ShimmerBox(
            width: double.infinity,
            height: 90,
            borderRadius: BorderRadius.all(Radius.circular(16))),
        const SizedBox(height: 12),
        const ShimmerBox(
            width: double.infinity,
            height: 90,
            borderRadius: BorderRadius.all(Radius.circular(16))),
        const SizedBox(height: 12),
        const ShimmerBox(
            width: double.infinity,
            height: 90,
            borderRadius: BorderRadius.all(Radius.circular(16))),
      ],
    );
  }

  // ─── Reminders ────────────
  Widget _buildRemindersSection(TripDetailsController controller) {
    final reminders = (controller.singleTripData.value.remainders ?? [])
        .where((r) => (r.daysLeft ?? 0) > 0)
        .toList();

    if (reminders.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Reminders",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.singleTripData.value.remainders?.length ?? 0,
            itemBuilder: (context, index) {
              final filteredReminders =
                  (controller.singleTripData.value.remainders ?? [])
                      .where((r) => (r.daysLeft ?? 0) > 0)
                      .toList();

              if (filteredReminders.isEmpty) return SizedBox.shrink();

              final data = controller.singleTripData.value.remainders![index];

              return Container(
                width: 300,
                margin: EdgeInsets.only(right: 10),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.orangeLight,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: AppColors.authOrange),
                          ),
                          child: Image.asset(
                            AppIcons.airplaneColor,
                            height: 20,
                            width: 20,
                          ),
                        ),
                        SizedBox(width: 10),
                        appButton(
                          height: 30,
                          width: 100,
                          onTap: () {},
                          name: '${data.daysLeft} day left',
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      "${data.title}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${data.description}",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => appButton(
                              loading: controller.isReminderLoading.value,
                              height: 30,
                              onTap: () async {
                                await controller
                                    .reminderStatus(data.id.toString());
                              },
                              name: "Dismiss",
                              bgColor: Color(0xFFf7ebe4),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Obx(
                            () => appButton(
                              loading: controller.isReminderLoading.value,
                              height: 30,
                              onTap: () async {
                                await controller
                                    .reminderStatus(data.id.toString());
                              },
                              name: "Done",
                              bgColor: AppColors.authOrange,
                              textColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ─── Priority Reminders ───────────────────────────────────────────────────────
  Widget _buildPriorityRemindersSection(TripDetailsController controller) {
    final reminders = controller.singleTripData.value.priorityRemainders ?? [];
    final reminder = reminders.isNotEmpty ? reminders[0] : PriorityRemainder();

    final passportChecked = reminder.passportCountry != null &&
        reminder.passportCountry!.isNotEmpty &&
        reminder.passportCountry != 'null' &&
        reminder.passportExpiry != null &&
        reminder.passportExpiry!.year > 1900 &&
        !reminder.passportExpiry!.isBefore(DateTime.now());

    final visaChecked = reminder.isVisaConfirmed == true ||
        reminder.noVisaRequired == true ||
        reminder.needsAttention == true;

    final insuranceChecked = reminder.haveInsurance == true;

    final allChecked = passportChecked && visaChecked && insuranceChecked;

    String buttonLabel(String type) {
      if (type == 'Passport') return passportChecked ? 'Checked' : 'Add';
      if (type == 'Visa') return visaChecked ? 'Checked' : 'Add';
      if (type == 'Travel Insurance')
        return insuranceChecked ? 'Checked' : 'Add';
      return 'Add';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        priorityRemindersStatusBanner(completed: allChecked),
        const SizedBox(height: 15),
        tripPriority(
          name: 'Passport',
          image: AppIcons.passport,
          onTap: () => controller.showPriorityReminderBottomSheet(
            reminder,
            'Passport',
          ),
          buttonName: buttonLabel('Passport'),
          isChecked: passportChecked,
        ),
        const SizedBox(height: 6),
        tripPriority(
          name: 'Visa',
          image: AppIcons.visa,
          onTap: () => controller.showPriorityReminderBottomSheet(
            reminder,
            'Visa',
          ),
          buttonName: buttonLabel('Visa'),
          isChecked: visaChecked,
        ),
        const SizedBox(height: 6),
        tripPriority(
          name: 'Travel Insurance',
          image: AppIcons.agreement,
          onTap: () => controller.showPriorityReminderBottomSheet(
            reminder,
            'Travel Insurance',
          ),
          buttonName: buttonLabel('Travel Insurance'),
          isChecked: insuranceChecked,
        ),
      ],
    );
  }

  // ─── Optimize Route Section ───────────────────────────────────────────────────
  Widget _buildOptimizeRouteSection(TripDetailsController controller) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFffe7d9),
                Color(0xFFfefef8),
                Color(0xFFf3f5c4),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title Row (static)
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.authOrange),
                      color: AppColors.authOrange.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child:
                        Image.asset(AppIcons.routeIcon, height: 20, width: 20),
                  ),
                  SizedBox(width: 6),
                  const Text(
                    'Optimize your route',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

              // ── Reason Text — controller.optimizeReason observe করবে
              Obx(() {
                final reason = controller.optimizeReason.value;
                final displayText = reason.isNotEmpty
                    ? reason
                    : 'Optimize your destinations to reduce unnecessary travel time between stops.';
                return Text(
                  displayText,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                );
              }),

              // ── Time Saved Badge
              Obx(() {
                final timeSaved = controller.optimizeTimeSaved.value;
                if (timeSaved.isEmpty || timeSaved == "0 hours") {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.timer_outlined,
                            size: 14, color: Colors.green.shade700),
                        const SizedBox(width: 4),
                        Text(
                          'Save ~$timeSaved',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              // ── Optimized Order Chips
              Obx(() {
                final optimizedOrder = controller.optimizeOptimizedOrder;
                if (optimizedOrder.isEmpty) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Suggested Order:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: List.generate(optimizedOrder.length, (i) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.authOrange.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: AppColors.authOrange.withOpacity(0.4)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 8,
                                  backgroundColor: AppColors.authOrange,
                                  child: Text(
                                    '${i + 1}',
                                    style: const TextStyle(
                                        fontSize: 9, color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  optimizedOrder[i],
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.black87),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                );
              }),

              // ── Tips
              Obx(() {
                final tips = controller.optimizeTips;
                if (tips.isEmpty) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tips:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ...tips.map(
                        (tip) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '• ',
                                style: TextStyle(
                                  color: AppColors.authOrange,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  tip,
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.black87),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              // ── Assign Button
              const SizedBox(height: 15),
              Obx(() {
                final isAlreadyOptimal =
                    controller.optimizeIsAlreadyOptimal.value;
                if (isAlreadyOptimal) {
                  return Container(
                    height: 46,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.green.shade500,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline,
                            color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Already Optimal ✓',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return appButton(
                  height: 46,
                  width: double.infinity,
                  loading: controller.isOptimizeLoading.value,
                  textColor: Colors.white,
                  onTap: () {
                    controller.getOptimize(tripId);
                    log("Assign optimize route");
                  },
                  name: "Assign Optimized Route",
                );
              }),
            ],
          ),
        ));
  }

  // ─── Itinerary Section with Drag & Drop ────────────────
  Widget _buildItinerarySection(TripDetailsController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + drag hint
          Row(
            children: [
              const Text(
                'Itinerary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.drag_indicator,
                        size: 12, color: Colors.grey.shade600),
                    SizedBox(width: 3),
                    Text(
                      'Hold to reorder',
                      style:
                          TextStyle(fontSize: 10, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ✅ ReorderableListView — drag & drop
          Obx(() {
            final itineraries = controller.reorderedItineraries;

            if (itineraries.isEmpty) {
              return const SizedBox.shrink();
            }

            return ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: itineraries.length,
              onReorder: (oldIndex, newIndex) {
                controller.reorderItinerary(oldIndex, newIndex);
              },
              // Custom drag handle — only the handle icon triggers drag
              buildDefaultDragHandles: false,
              // Dragged item appearance
              proxyDecorator: (child, index, animation) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(15),
                      shadowColor: Colors.black26,
                      child: child,
                    );
                  },
                  child: child,
                );
              },
              itemBuilder: (context, index) {
                final itinerary = itineraries[index];
                return _buildItineraryItem(
                  key: ValueKey(itinerary.id ?? index),
                  itinerary: itinerary,
                  index: index,
                  totalCount: itineraries.length,
                );
              },
            );
          }),
        ],
      ),
    );
  }

  /// Single itinerary row — timeline dot + card + drag handle
  Widget _buildItineraryItem({
    required Key key,
    required dynamic itinerary,
    required int index,
    required int totalCount,
  }) {
    return Padding(
      key: key,
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Timeline Column
          Column(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.black87,
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
              // Don't draw line after last item
              if (index < totalCount - 1)
                Container(
                  width: 2,
                  height: 95,
                  color: Colors.grey.shade300,
                ),
            ],
          ),
          const SizedBox(width: 15),

          // ── Card
          Expanded(
            child: GestureDetector(
              onTap: () => Get.to(TripItineraryView(
                itineraryId: itinerary.id.toString(),
              )),
              child: Card(
                color: Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    // Left: text info
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${itinerary.name}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "${itinerary.days} Days",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Image.asset(AppIcons.activity,
                                    color: Colors.black, height: 20, width: 20),
                                const SizedBox(width: 6),
                                Image.asset(AppIcons.airplaneColor,
                                    color: Colors.black, height: 20, width: 20),
                                const SizedBox(width: 6),
                                Image.asset(AppIcons.hotelBell,
                                    color: Colors.black, height: 20, width: 20),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Center-right: thumbnail image
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      ),
                      child: AppNetworkImage(
                        height: 95,
                        width: 90,
                        borderRadius: BorderRadius.circular(0),
                        imageUrl: itinerary.image.toString(),
                        fit: BoxFit.cover,
                      ),
                    ),

                    // ✅ Drag Handle — only this triggers drag
                    ReorderableDragStartListener(
                      index: index,
                      child: Container(
                        height: 95,
                        width: 32,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Icon(
                          Icons.drag_indicator,
                          color: Colors.grey.shade500,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
