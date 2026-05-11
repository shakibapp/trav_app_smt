import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_button.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/core/constants/app_icons.dart';
import 'package:hamishphipps/app/core/widgets/network_image.dart';
import 'package:hamishphipps/app/modules/general_user_flow/create_plan/widget/back_button_widget.dart';
import 'package:hamishphipps/app/modules/general_user_flow/trip_details_screen/controller/trip_details_controller.dart';
import 'package:hamishphipps/app/modules/general_user_flow/trip_details_screen/model/trip_details_model.dart';
import 'package:intl/intl.dart';

import '../widget/trip_details_widget.dart';

class TripDetailsScreen extends StatelessWidget {
  TripDetailsScreen({super.key});
  final controller = Get.put(TripDetailsController());

  @override
  Widget build(BuildContext context) {
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
                  _buildPriorityRemindersSection(controller),
                  _buildItinerarySection(controller),
                  SizedBox(height: 20),
                  _buildOptimizeRouteSection(controller),
                  const SizedBox(height: 30),
                ],
              );
            }
          }),
        ),
      ),
    );
  }

  Widget _buildHeader(TripDetailsController controller) {
    final data = controller.singleTripData.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            backButton(),
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
                AppNetworkImage(imageUrl: data.images![0]),
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
                        data.region!.join(","),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      // const SizedBox(height: 8),
                      Wrap(
                        children: [
                          _buildInfoChip(
                            formatDateRange(data.startDate.toString(),
                                data.endDate.toString()),
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

  String formatDateRange(String startDate, String endDate) {
    final start = DateTime.parse(startDate);
    final end = DateTime.parse(endDate);

    if (start.year == end.year) {
      return '${DateFormat('MMM d').format(start)} – '
          '${DateFormat('MMM d, y').format(end)}';
    } else {
      return '${DateFormat('MMM d, y').format(start)} – '
          '${DateFormat('MMM d, y').format(end)}';
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

  Widget _buildLoadingSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const ShimmerBox(
            width: 180,
            height: 24,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        const SizedBox(height: 20),
        SizedBox(
          height: 150,
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

  Widget _buildRemindersSection(TripDetailsController controller) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.singleTripData.value.remainders!.length,
        itemBuilder: (context, index) {
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
                      child: appButton(
                        height: 30,
                        onTap: () {},
                        name: "Dismiss",
                        bgColor: Color(0xFFf7ebe4),
                      ),
                    ),
                    SizedBox(width: 10),
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
    );
  }

  Widget _buildPriorityRemindersSection(TripDetailsController controller) {
    final reminders = controller.singleTripData.value.priorityRemainders ?? [];
    final passportReminder =
        reminders.isNotEmpty ? reminders[0] : PriorityRemainder();
    final visaReminder =
        reminders.length > 1 ? reminders[1] : PriorityRemainder();
    final insuranceReminder =
        reminders.length > 2 ? reminders[2] : PriorityRemainder();

    String _buttonLabel(String type, PriorityRemainder reminder) {
      bool isChecked = false;
      if (type == 'Passport') {
        isChecked = reminder.passportCountry != null &&
            reminder.passportCountry!.isNotEmpty &&
            reminder.passportCountry != 'null' &&
            reminder.passportExpiry != null &&
            reminder.passportExpiry!.year > 1900 &&
            !reminder.passportExpiry!.isBefore(DateTime.now());
      } else if (type == 'Visa') {
        isChecked = reminder.isVisaConfirmed == true ||
            reminder.noVisaRequired == true;
      } else if (type == 'Travel Insurance') {
        isChecked = reminder.haveInsurance == true;
      }
      return isChecked ? 'Checked' : 'Add';
    }

    final passportChecked = passportReminder.passportCountry != null &&
        passportReminder.passportCountry!.isNotEmpty &&
        passportReminder.passportCountry != 'null' &&
        passportReminder.passportExpiry != null &&
        passportReminder.passportExpiry!.year > 1900 &&
        !passportReminder.passportExpiry!.isBefore(DateTime.now());

    final visaChecked = visaReminder.isVisaConfirmed == true ||
        visaReminder.noVisaRequired == true;
    final insuranceChecked = insuranceReminder.haveInsurance == true;
    final allChecked = passportChecked && visaChecked && insuranceChecked;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        priorityRemindersStatusBanner(completed: allChecked),
        const SizedBox(height: 15),
        tripPriority(
          name: 'Passport',
          image: AppIcons.passport,
          onTap: () => controller.showPriorityReminderBottomSheet(
            passportReminder,
            'Passport',
          ),
          buttonName: _buttonLabel('Passport', passportReminder),
          isChecked: passportChecked,
        ),
        const SizedBox(height: 6),
        tripPriority(
          name: 'Visa',
          image: AppIcons.visa,
          onTap: () => controller.showPriorityReminderBottomSheet(
            visaReminder,
            'Visa',
          ),
          buttonName: _buttonLabel('Visa', visaReminder),
          isChecked: visaChecked,
        ),
        const SizedBox(height: 6),
        tripPriority(
          name: 'Travel Insurance',
          image: AppIcons.agreement,
          onTap: () => controller.showPriorityReminderBottomSheet(
            insuranceReminder,
            'Travel Insurance',
          ),
          buttonName: _buttonLabel('Travel Insurance', insuranceReminder),
          isChecked: insuranceChecked,
        ),
      ],
    );
  }

  Widget _buildItinerarySection(TripDetailsController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Itinerary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.singleTripData.value.itineraries!.length,
            itemBuilder: (context, index) {
              final itinerary =
                  controller.singleTripData.value.itineraries![index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.black87,
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 80,
                        color: Colors.grey.shade300,
                      ),
                    ],
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Card(
                        color: Colors.grey.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${itinerary.name}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      "${itinerary.days} Days",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Image.asset(
                                          AppIcons.activity,
                                          color: Colors.black,
                                          height: 20,
                                          width: 20,
                                        ),
                                        SizedBox(width: 6),
                                        Image.asset(
                                          AppIcons.airplaneColor,
                                          color: Colors.black,
                                          height: 20,
                                          width: 20,
                                        ),
                                        SizedBox(width: 6),
                                        Image.asset(
                                          AppIcons.hotelBell,
                                          color: Colors.black,
                                          height: 20,
                                          width: 20,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(15),
                              ),
                              child: AppNetworkImage(
                                imageUrl: itinerary.image.toString(),
                                fit: BoxFit.cover,
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
          ),
        ],
      ),
    );
  }

  // Helper Widgets

  Widget _buildOptimizeRouteSection(TripDetailsController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.authOrange),
                    color: AppColors.authOrange.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(AppIcons.routeIcon, height: 20, width: 20),
                ),
                SizedBox(height: 6),
                const Text(
                  'Optimize your route',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: appButton(
                        bgColor: Colors.transparent,
                        borderColor: Colors.grey.shade400,
                        textColor: Colors.black,
                        onTap: () {},
                        name: "Dismiss",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: appButton(
                        textColor: Colors.white,
                        onTap: (){},
                        name: "Assign",
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
  }
}
