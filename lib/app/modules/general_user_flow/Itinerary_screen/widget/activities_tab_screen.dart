import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_button.dart';
import 'package:hamishphipps/app/core/constants/app_icons.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/controller/tripltinerary_overview_controller.dart';

import 'package:hamishphipps/app/routes/app_routes.dart';
import 'package:intl/intl.dart';

class ActivitiesTabScreen extends StatelessWidget {
  final ItineraryDetailsController controller;
  const ActivitiesTabScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
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
                      onTap: () => Get.toNamed(AppRoutes.addActivity),
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
                      onTap: () {},
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
                            Text(
                              activity.name ?? "Activity Name",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Image.asset(
                                    AppIcons.editButton,
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                                SizedBox(width: 10),
                                InkWell(
                                  onTap: () {},
                                  child: Image.asset(
                                    AppIcons.deleteButton,
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
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
                          '${activity.expense}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: appButton(
                                height: 45,
                                onTap: () {},
                                name: "Missed",
                                bgColor: Colors.transparent,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: appButton(
                                height: 45,
                                onTap: () {},
                                name: activity.status == "Pending"
                                    ? "Mark as Complete"
                                    : "Complete",
                                textColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 16),
        // appButton(
        //   width: double.infinity,
        //   bgColor: Colors.transparent,
        //   borderColor: Colors.black,
        //   textColor: Colors.black,
        //   onTap: () {},
        //   name: "Add New",
        // ),
        SizedBox(height: 30),
      ],
    );
  }
}
