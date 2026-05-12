// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hamishphipps/app/core/constants/app_button.dart';
// import 'package:hamishphipps/app/core/constants/app_colors.dart';
// import 'package:hamishphipps/app/core/constants/app_icons.dart';
// import 'package:hamishphipps/app/modules/general_user_flow/create_plan/widget/back_button_widget.dart';

// import '../controller/itinerary_controller.dart';

// class ItineraryView extends StatelessWidget {
//   final ItineraryController controller = Get.put(ItineraryController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         leading: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: backButton(),
//         ),
//         title: Text(
//           "Your Itinerary",
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.symmetric(horizontal: 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildHeroImage(),
//             SizedBox(height: 20),
//             _buildRemindersSection(),
//             SizedBox(height: 15),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Color(0xFFffe7d9),
//                     Color(0xFFfefef8),
//                     Color(0xFFf3f5c4),
//                   ],
//                   begin: Alignment.centerLeft,
//                   end: Alignment.centerRight,
//                 ),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(5),
//                     height: 40,
//                     width: 40,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: Image.asset(
//                       AppIcons.alertCircle,
//                       height: 30,
//                       width: 30,
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   Text(
//                     "Priority Reminders (Need Attention)",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 15),
//             _buildOptimizationCard(),
//             SizedBox(height: 20),
//             Text(
//               "Itinerary",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             _buildTimelineList(),
//           ],
//         ),
//       ),
//     );
//   }

//   // Header Image with Badges
//   Widget _buildHeroImage() {
//     return Container(
//       height: 200,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         image: DecorationImage(
//           image: AssetImage('assets/images/italy.png'),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Stack(
//         children: [
//           Positioned(
//             bottom: 20,
//             left: 20,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Italy",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     _smallBadge(Icons.calendar_today, "Mar 18 - Mar 28, 2026"),
//                     SizedBox(width: 5),
//                     _smallBadge(Icons.flag, "5 Days"),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Horizontal Reminder Cards
//   Widget _buildRemindersSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Reminders",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 10),
//         SizedBox(
//           height: 150,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,

//             itemBuilder: (context, index) {
//               return Container(
//                 width: 300,
//                 margin: EdgeInsets.only(right: 10),
//                 padding: EdgeInsets.all(15),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.all(4),
//                           decoration: BoxDecoration(
//                             color: AppColors.orangeLight,
//                             borderRadius: BorderRadius.circular(100),
//                             border: Border.all(color: AppColors.authOrange),
//                           ),
//                           child: Image.asset(
//                             AppIcons.airplaneColor,
//                             height: 20,
//                             width: 20,
//                           ),
//                         ),
//                         SizedBox(width: 10),
//                         appButton(
//                           height: 30,
//                           width: 100,

//                           onTap: () {},
//                           name: '5 Days Left',
//                           textColor: Colors.white,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       "Book flight to Rome",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       "Arriving 20 Mar, 2026",
//                       style: TextStyle(fontSize: 12, color: Colors.grey),
//                     ),
//                     SizedBox(height: 10),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: appButton(
//                             height: 30,
//                             onTap: () {},
//                             name: "Dismiss",
//                             bgColor: Color(0xFFf7ebe4),
//                           ),
//                         ),
//                         SizedBox(width: 10),
//                         Expanded(
//                           child: appButton(
//                             height: 30,
//                             onTap: () {},
//                             name: "Done",
//                             bgColor: AppColors.authOrange,
//                             textColor: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   // Optimization Suggestion Card
//   Widget _buildOptimizationCard() {
//     return Container(
//       padding: EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFFffe7d9), Color(0xFFfefef8), Color(0xFFf3f5c4)],
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ),
//         // color: Colors.lightGreen.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: Colors.green.shade100),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(4),
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(100),
//                   color: Color(0xFFFFBB91),
//                   border: Border.all(color: AppColors.authOrange),
//                 ),
//                 child: Image.asset(AppIcons.routeIcon, height: 20, width: 20),
//               ),

//               SizedBox(width: 10),
//               Text(
//                 "Optimise your route",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               Spacer(),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: Colors.green.shade100,
//                   borderRadius: BorderRadius.circular(100),
//                 ),

//                 child: Text(
//                   "Save 3h",
//                   style: TextStyle(
//                     fontSize: 10,
//                     color: Colors.green,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
//           Text(
//             "Consider visiting Berlin before Amsterdam to reduce travel time.",
//             style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
//           ),
//           SizedBox(height: 15),
//           ElevatedButton(
//             onPressed: () => controller.applyOptimization(),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.authOrange,
//               minimumSize: Size(double.infinity, 45),
//               shape: StadiumBorder(),
//             ),
//             child: Text("Apply", style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }

//   // Timeline List
//   Widget _buildTimelineList() {
//     return Obx(
//       () => ListView.builder(
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         itemCount: controller.itineraryList.length,
//         itemBuilder: (context, index) {
//           final item = controller.itineraryList[index];
//           return Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Column(
//                 children: [
//                   CircleAvatar(
//                     radius: 12,
//                     backgroundColor: Colors.black87,
//                     child: Text(
//                       "${index + 1}",
//                       style: TextStyle(color: Colors.white, fontSize: 10),
//                     ),
//                   ),
//                   Container(width: 2, height: 100, color: Colors.grey.shade300),
//                 ],
//               ),
//               SizedBox(width: 15),
//               Expanded(
//                 child: Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Padding(
//                           padding: EdgeInsets.all(10),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 item.cityName,
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               Text(
//                                 item.duration,
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               SizedBox(height: 10),
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.check_circle,
//                                     size: 16,
//                                     color: AppColors.authOrange,
//                                   ),
//                                   SizedBox(width: 5),
//                                   Icon(
//                                     Icons.error,
//                                     size: 16,
//                                     color: AppColors.authOrange,
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       ClipRRect(
//                         borderRadius: BorderRadius.horizontal(
//                           right: Radius.circular(15),
//                         ),
//                         child: Image.asset(
//                           item.imageUrl,
//                           width: 100,
//                           height: 100,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   // Helper Widgets
//   Widget _smallBadge(IconData icon, String text) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.black54,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.white, size: 12),
//           SizedBox(width: 4),
//           Text(text, style: TextStyle(color: Colors.white, fontSize: 10)),
//         ],
//       ),
//     );
//   }

//   Widget _reminderCard(String title, String subtitle) {
//     return Container(
//       width: 250,
//       margin: EdgeInsets.only(right: 10),
//       padding: EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
//           Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey)),
//           SizedBox(height: 10),
//           Row(
//             children: [
//               Expanded(
//                 child: appButton(
//                   height: 30,
//                   onTap: () {},
//                   name: "Dismiss",
//                   bgColor: Color(0xFFf7ebe4),
//                 ),
//               ),
//               SizedBox(width: 10),
//               Expanded(
//                 child: appButton(
//                   height: 30,
//                   onTap: () {},
//                   name: "Done",
//                   bgColor: AppColors.authOrange,
//                   textColor: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_button.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/core/constants/app_icons.dart';
import 'package:hamishphipps/app/modules/general_user_flow/create_plan/model/itinerary_details_model.dart';
import 'package:hamishphipps/app/modules/general_user_flow/create_plan/widget/back_button_widget.dart';

import '../controller/itinerary_controller.dart';

class ItineraryView extends StatelessWidget {
  final String itineraryId;
  final ItineraryController controller = Get.put(ItineraryController());

  ItineraryView({super.key, required this.itineraryId});

  @override
  Widget build(BuildContext context) {
    // Fetch data on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchItineraryDetails(itineraryId);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: backButton(),
        ),
        title: Text(
          "Your Itinerary",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoadingItineraryDetails.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final details = controller.itineraryDetails.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroImage(details),
              const SizedBox(height: 20),

              // --- Reminders Section (horizontal) ---
              if ((details.remainders ?? []).isNotEmpty) ...[
                _buildRemindersSection(details.remainders!),
                const SizedBox(height: 15),
              ],

              // --- Priority Reminders Section ---
              if ((details.priorityRemainders ?? []).isNotEmpty) ...[
                _buildPriorityRemindersHeader(),
                const SizedBox(height: 15),
                _buildPriorityRemindersList(details.priorityRemainders!),
                const SizedBox(height: 15),
              ],

              // --- Optimization Card ---
              _buildOptimizationCard(),
              const SizedBox(height: 20),

              // --- Accommodations Timeline ---
              const Text(
                "Itinerary",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              _buildAccommodationTimeline(details.accommodations ?? []),
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  // ── Hero Image ──────────────────────────────────────────────────────────────
  Widget _buildHeroImage(ItineraryDetailsModel details) {
    final imageUrl = details.image;
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.shade300,
        image: imageUrl != null && imageUrl.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              )
            : const DecorationImage(
                image: AssetImage('assets/images/italy.png'),
                fit: BoxFit.cover,
              ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  details.name ?? "Your Trip",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    _smallBadge(Icons.flag, "${details.days ?? 0} Days"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Reminders (horizontal scroll) ──────────────────────────────────────────
  Widget _buildRemindersSection(List<Remainder> remainders) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Reminders",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 155,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: remainders.length,
            itemBuilder: (context, index) {
              final reminder = remainders[index];
              return Container(
                width: 300,
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(15),
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
                          padding: const EdgeInsets.all(4),
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
                        const SizedBox(width: 10),
                        if (reminder.daysLeft != null)
                          appButton(
                            height: 30,
                            width: 110,
                            onTap: () {},
                            name: '${reminder.daysLeft} Days Left',
                            textColor: Colors.white,
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      reminder.title ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      reminder.description ?? '',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: appButton(
                            height: 30,
                            onTap: () {},
                            name: "Dismiss",
                            bgColor: const Color(0xFFf7ebe4),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: appButton(
                            height: 30,
                            onTap: () {},
                            name: "Done",
                            bgColor: AppColors.authOrange,
                            textColor: Colors.white,
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

  // ── Priority Reminders Header ───────────────────────────────────────────────
  Widget _buildPriorityRemindersHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFffe7d9), Color(0xFFfefef8), Color(0xFFf3f5c4)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            height: 40,
            width: 40,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            child: Image.asset(AppIcons.alertCircle, height: 30, width: 30),
          ),
          const SizedBox(width: 10),
          const Text(
            "Priority Reminders (Need Attention)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // ── Priority Reminders List ─────────────────────────────────────────────────
  Widget _buildPriorityRemindersList(List<PriorityRemainder> list) {
    return Column(
      children: list
          .map((pr) => _buildPriorityReminderCards(pr))
          .expand((widgets) => widgets)
          .toList(),
    );
  }

  /// Builds 3 rows per PriorityRemainder: Passport / Visa / Travel Insurance
  List<Widget> _buildPriorityReminderCards(PriorityRemainder pr) {
    // --- Passport ---
    // "Update" if passportCountry is set but passportExpiry is null
    // "Add"    if passportCountry is also null
    // ✓ green  if both are present
    final bool passportComplete =
        pr.passportCountry != null && pr.passportExpiry != null;
    final bool passportNeedsUpdate =
        pr.passportCountry != null && pr.passportExpiry == null;

    // --- Visa ---
    final bool visaComplete =
        pr.isVisaConfirmed == true || pr.noVisaRequired == true;

    // --- Insurance ---
    final bool insuranceComplete = pr.haveInsurance == true;

    return [
      _priorityRow(
        icon: AppIcons.passport, // replace with your icon path
        label: "Passport",
        isComplete: passportComplete,
        actionLabel:
            passportNeedsUpdate ? "Update" : (!passportComplete ? "Add" : null),
        onTap: () {
          // Navigate to passport update/add page
        },
      ),
      const SizedBox(height: 10),
      _priorityRow(
        icon: AppIcons.visa, // replace with your icon path
        label: "Visa",
        isComplete: visaComplete,
        actionLabel: !visaComplete ? "Add" : null,
        onTap: () {},
      ),
      const SizedBox(height: 10),
      _priorityRow(
        icon: AppIcons.hotel, // replace with your icon path
        label: "Travel Insurance",
        isComplete: insuranceComplete,
        actionLabel: !insuranceComplete ? "Add" : null,
        onTap: () {},
      ),
      const SizedBox(height: 10),
    ];
  }

  Widget _priorityRow({
    required String icon,
    required String label,
    required bool isComplete,
    String? actionLabel,
    VoidCallback? onTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.orangeLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(icon, height: 22, width: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          // Action button OR green tick
          if (isComplete)
            const Icon(Icons.check_circle, color: Colors.green, size: 26)
          else if (actionLabel != null)
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.authOrange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  actionLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Optimization Card ───────────────────────────────────────────────────────
  Widget _buildOptimizationCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFffe7d9), Color(0xFFfefef8), Color(0xFFf3f5c4)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color(0xFFFFBB91),
                  border: Border.all(color: AppColors.authOrange),
                ),
                child: Image.asset(AppIcons.routeIcon, height: 20, width: 20),
              ),
              const SizedBox(width: 10),
              const Text(
                "Optimise your route",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  "Save 3h",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Consider visiting Berlin before Amsterdam to reduce travel time.",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () => controller.applyOptimization(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.authOrange,
              minimumSize: const Size(double.infinity, 45),
              shape: const StadiumBorder(),
            ),
            child: const Text("Apply", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── Accommodations Timeline ─────────────────────────────────────────────────
  Widget _buildAccommodationTimeline(List<Accommodation> accommodations) {
    if (accommodations.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            "No accommodations added yet.",
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: accommodations.length,
      itemBuilder: (context, index) {
        final item = accommodations[index];
        final isLast = index == accommodations.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline indicator
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
                if (!isLast)
                  Container(
                    width: 2,
                    height: 110,
                    color: Colors.grey.shade300,
                  ),
              ],
            ),
            const SizedBox(width: 15),
            // Card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 1,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name ?? "Accommodation",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              if (item.type != null)
                                Text(
                                  item.type!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              if (item.checkInDate != null &&
                                  item.checkOutDate != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    "${_formatDate(item.checkInDate!)} → ${_formatDate(item.checkOutDate!)}",
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  // Payment status indicator
                                  if (item.paymentStatus != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: item.paymentStatus == 'paid'
                                            ? Colors.green.shade50
                                            : Colors.orange.shade50,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        item.paymentStatus!.capitalizeFirst ??
                                            item.paymentStatus!,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: item.paymentStatus == 'paid'
                                              ? Colors.green
                                              : AppColors.authOrange,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(width: 8),
                                  if (item.totalNights != null)
                                    Text(
                                      "${item.totalNights} nights",
                                      style: const TextStyle(
                                          fontSize: 11, color: Colors.grey),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Right image placeholder (use network image if available)
                      ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(15),
                        ),
                        child: Container(
                          width: 100,
                          height: 110,
                          color: Colors.grey.shade200,
                          child: item.address != null
                              ? Icon(Icons.hotel,
                                  size: 40, color: Colors.grey.shade400)
                              : Icon(Icons.hotel,
                                  size: 40, color: Colors.grey.shade400),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────
  Widget _smallBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 10)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return "${date.day} ${months[date.month - 1]}";
  }
}
