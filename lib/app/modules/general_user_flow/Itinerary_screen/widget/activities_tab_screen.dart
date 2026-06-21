import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_button.dart';
import 'package:hamishphipps/app/core/constants/app_icons.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/controller/tripltinerary_overview_controller.dart';

import 'package:intl/intl.dart';

import '../../add_activity/controller/add_activity_controller.dart';
import '../../add_activity/view/add_activity_screen.dart';

class ActivitiesTabScreen extends StatelessWidget {
  final ItineraryDetailsController controller;
  ActivitiesTabScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // Initialize AddActivityController and pass the ItineraryDetailsController reference
    final activityController = Get.put(AddActivityController());
    activityController.itineraryDetailsController = controller;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Plan Your Activities',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Decide what you want to do at each destination — explore, relax, or adventure.',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    SizedBox(height: 17),
                    appButton(
                      width: double.infinity,
                      textColor: Colors.black,
                      borderColor: Colors.grey,
                      bgColor: Colors.transparent,
                      onTap: () => Get.to(() => AddActivityView(
                          id: controller.itineraryOverview.value.id
                              .toString())),
                      name: "Add Activity",
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Not sure what to do? Let Trav suggest activities for you.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    appButton(
                      width: double.infinity,
                      textColor: Colors.white,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Ask Trav (AI)',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text('Your Preferences'),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: controller.preferance,
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                      hintText:
                                          'e.g. I love outdoor adventures, local food...',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Obx(
                                    () => appButton(
                                        onTap: () async {
                                          await controller.createActivityWithAI(
                                            controller
                                                .itineraryOverview.value.id
                                                .toString(),
                                          );
                                          Get.back();
                                        },
                                        loading: controller
                                            .isAlCreateActivityLoading.value,
                                        width: double.infinity,
                                        textColor: Colors.white,
                                        name: "Generate Activities"),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      name: "Ask Trav (AI)",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount:
              controller.itineraryOverview.value?.activities?.length ?? 0,
          itemBuilder: (context, index) {
            final activity =
                controller.itineraryOverview.value!.activities![index];
            return Card(
              elevation: 2,
              color: Colors.grey.shade50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    width: double.infinity,
                    alignment: Alignment.bottomLeft,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: Colors.grey.shade300,
                    ),
                    child: Text(
                      "Day ${activity.dayNumber}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 260.w,
                              child: Text(
                                activity.name ?? "Activity Name",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.to(() => AddActivityView(
                                          id: controller
                                              .itineraryOverview.value.id
                                              .toString(),
                                          activity: activity,
                                        ));
                                  },
                                  child: Image.asset(
                                    AppIcons.editButton,
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Obx(() {
                                  return activityController
                                          .isDeleteActivity.value
                                      ? SizedBox(
                                          height: 15,
                                          width: 15,
                                          child: CircularProgressIndicator
                                              .adaptive())
                                      : InkWell(
                                          onTap: () {
                                            activityController.deleteActivity(
                                                activity.id.toString());
                                          },
                                          child: Image.asset(
                                            AppIcons.deleteButton,
                                            height: 20,
                                            width: 20,
                                          ),
                                        );
                                }),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Start Date',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                ),
                                Text(
                                  DateFormat('MMM dd, yyyy').format(
                                      DateTime.parse(
                                          activity.startDate.toString())),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  activity.startTime.toString(),
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'End Date',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                ),
                                Text(
                                  DateFormat('MMM dd, yyyy').format(
                                      DateTime.parse(
                                          activity.endDate.toString())),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  activity.endTime.toString(),
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.beach_access,
                                  size: 16,
                                  color: Colors.orange,
                                ),
                                SizedBox(width: 4),
                                Text(activity.type!.join(", ") ?? "",
                                    style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          '\$${activity.expense}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16),
                        Obx(() => activity.status == "Completed"
                            ? SizedBox()
                            : Row(
                                children: [
                                  Expanded(
                                    child: appButton(
                                      height: 45,
                                      loading: activityController
                                          .isMissedLoading
                                          .value, // শুধু Missed button loading
                                      onTap: () => activityController
                                          .statusUpdateActivity(
                                              activity.id.toString(), "Missed"),
                                      name: "Missed",
                                      bgColor: Colors.transparent,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: appButton(
                                      height: 45,
                                      loading: activityController
                                          .isCompletedLoading
                                          .value, // শুধু Complete button loading
                                      onTap: () => activityController
                                          .statusUpdateActivity(
                                              activity.id.toString(),
                                              "Completed"),
                                      name: activity.status == "Pending"
                                          ? "Mark as Complete"
                                          : "Complete",
                                      textColor: Colors.white,
                                    ),
                                  ),
                                ],
                              )),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
