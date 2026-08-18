import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hamishphipps/app/core/constants/app_icons.dart';
import 'package:hamishphipps/app/modules/general_user_flow/profile/controller/profile_controller.dart';
import 'package:hamishphipps/app/modules/general_user_flow/trip_details_screen/widget/trip_details_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_images.dart';
import 'package:hamishphipps/app/core/widgets/custom_button_widget.dart';
import 'package:hamishphipps/app/core/widgets/network_image.dart';

import 'package:hamishphipps/app/modules/general_user_flow/home/ui/widgets/trip_reminders_section.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/style/global_text_style.dart';
import '../../../../routes/app_routes.dart';
import '../../Itinerary_screen/view/tripItinerary_overview_screen.dart';
import '../../create_plan/city/view/city_view.dart';
import '../controller/home_controller.dart';

class HomeScreen extends GetWidget<HomeController> {
  HomeScreen({super.key});
  final userController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          // Background Image with opacity
          Positioned(
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.1,
                child: Image.asset(
                  AppImages.tripBg,
                  width: double.infinity,
                  height: 200.h,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          // Main Content
          SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50.h),
                _buildGreetingSection(userController),
                Obx(() {
                  if (controller.upcomingTripsFromApi.isEmpty ||
                      controller.isLoadingTrips.value) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Upcoming Trips",
                        style: globaltextInterTight(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.blackColor,
                        ),
                      ),
                      SizedBox(height: 10.h),
                    ],
                  );
                }),
                Obx(() {
                  final bool isEmpty =
                      controller.upcomingTripsFromApi.isEmpty &&
                          !controller.isLoadingTrips.value;
                  return SizedBox(
                      height: isEmpty ? null : 200,
                      width: double.infinity,
                      child: controller.isLoadingTrips.value
                          ? _buildTripsLoadingShimmer()
                          : controller.upcomingTripsFromApi.isEmpty
                              ? _buildEmptyTripsState()
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      controller.upcomingTripsFromApi.length,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (_, index) {
                                    final trip =
                                        controller.upcomingTripsFromApi[index];
                                    String dateInfo = '';
                                    if (trip.startDate != null &&
                                        trip.endDate != null) {
                                      try {
                                        final startStr = DateFormat('MMM d')
                                            .format(trip.startDate!);
                                        final endStr = DateFormat('MMM d')
                                            .format(trip.endDate!);
                                        final days = trip.endDate!
                                            .difference(trip.startDate!)
                                            .inDays;
                                        dateInfo =
                                            '$startStr – $endStr · $days days · \$${trip.budget ?? 0}';
                                      } catch (e) {
                                        dateInfo =
                                            'Dates unknown · \$${trip.budget ?? 0}';
                                      }
                                    } else {
                                      dateInfo =
                                          'Dates unknown · \$${trip.budget ?? 0}';
                                    }
                                    final String tripCity =
                                        (trip.city != null &&
                                                trip.city!.isNotEmpty)
                                            ? trip.city!.join(', ')
                                            : 'Unknown Destination';

                                    return Obx(() {
                                      return InkWell(
                                        key: ValueKey(trip.id),
                                        onTap: () =>
                                            controller.getTripDetailById(
                                                trip.id.toString()),
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                        child: Container(
                                          margin: EdgeInsets.only(right: 5.h),
                                          width: 220,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.r),
                                            border: Border.all(
                                              color: controller.selectedTripId
                                                          .value ==
                                                      trip.id
                                                  ? AppColors.authOrange
                                                  : Colors.transparent,
                                              width: 2,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.1,
                                                ),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20.r),
                                                child: trip.images != null &&
                                                        trip.images!.isNotEmpty
                                                    ? PageView.builder(
                                                        itemCount:
                                                            trip.images!.length,
                                                        itemBuilder:
                                                            (_, imgIndex) {
                                                          return AppNetworkImage(
                                                            imageUrl: trip
                                                                        .images![
                                                                    imgIndex] ??
                                                                "https://media.cntraveller.com/photos/66dab99cca79963e5f03ff9d/16:9/w_2560%2Cc_limit/GettyImages-1588291549.jpg",
                                                            width:
                                                                double.infinity,
                                                            height:
                                                                double.infinity,
                                                            fit: BoxFit.cover,
                                                          );
                                                        },
                                                      )
                                                    : AppNetworkImage(
                                                        imageUrl:
                                                            "https://media.cntraveller.com/photos/66dab99cca79963e5f03ff9d/16:9/w_2560%2Cc_limit/GettyImages-1588291549.jpg",
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                              // Status badge
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top: 12.h,
                                                    left: 12.w,
                                                  ),
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 12.w,
                                                      vertical: 6.h,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppColors.whiteColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.r),
                                                    ),
                                                    child: Text(
                                                      trip.status?.toString() ??
                                                          'Upcoming',
                                                      style:
                                                          globaltextInterTight(
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppColors
                                                            .authOrange,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // Info panel
                                              Positioned(
                                                left: 0,
                                                right: 0,
                                                bottom: 0,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(16.r),
                                                    topRight:
                                                        Radius.circular(16.r),
                                                    bottomLeft:
                                                        Radius.circular(20.r),
                                                    bottomRight:
                                                        Radius.circular(20.r),
                                                  ),
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 16.w,
                                                      vertical: 14.h,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black12,
                                                      border: Border.all(
                                                        color: Colors.white
                                                            .withValues(
                                                                alpha: 0.18),
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                tripCity,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    globaltextInterTight(
                                                                  fontSize:
                                                                      15.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  color: AppColors
                                                                      .whiteColor,
                                                                  lineHeight:
                                                                      1.1,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 4.h),
                                                              Text(
                                                                dateInfo,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    globaltextInterTight(
                                                                  fontSize:
                                                                      11.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: AppColors
                                                                      .whiteColor,
                                                                  lineHeight:
                                                                      1.2,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                ));
                }),

                SizedBox(height: 10.h),

                // ✅ Priority Reminders Section
                Obx(() {
                  if (controller.isLoadingTripDetail.value) {
                    return _buildItineraryDetailLoadingShimmer();
                  }

                  final tripData = controller.tripDetail.value;
                  if (tripData.id == null || tripData.id!.isEmpty) {
                    return SizedBox.shrink();
                  }

                  // ← access priorityRemainders here to register dependency
                  final _ = controller.tripDetail.value.priorityRemainders;

                  return _buildPriorityRemindersSection(context, controller);
                }),

                Obx(() {
                  if (controller.isLoadingTripDetail.value) {
                    return _buildDestinationsLoadingShimmer();
                  }
                  final itineraries =
                      controller.tripDetail.value.itineraries ?? [];
                  if (itineraries.isEmpty) return const SizedBox.shrink();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Destinations",
                        style: globaltextInterTight(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.blackColor,
                        ),
                      ),
                      Text("${itineraries.length} Stops(Total)"),
                      SizedBox(height: 10.h),
                      SizedBox(
                        height: 150.h,
                        width: double.infinity,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: itineraries.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (_, index) {
                            final itinerary = itineraries[index];
                            return GestureDetector(
                              onTap: () {
                                Get.to(() => TripItineraryView(
                                      itineraryId: itinerary.id.toString(),
                                    ));
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 180.h,
                                margin: EdgeInsets.only(right: 5.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 120,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: AppNetworkImage(
                                          fit: BoxFit.cover,
                                          height: 100,
                                          width: 120,
                                          imageUrl:
                                              itinerary.image?.isNotEmpty ??
                                                      false
                                                  ? itinerary.image
                                                  : '',
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(15),
                                            topLeft: Radius.circular(15),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${itinerary.name}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.blackColor,
                                              ),
                                            ),
                                            Text(
                                              "${itinerary.days} Day, ${itinerary.transportation}",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.blackColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10.h),
                    ],
                  );
                }),

                Obx(() {
                  if (controller.isLoadingTripDetail.value) {
                    return _buildItineraryDetailLoadingShimmer();
                  }
                  final remi = controller.tripDetail.value;
                  final remainders = remi.remainders ?? [];
                  if (remainders.isEmpty) return const SizedBox.shrink();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
                        child: Text(
                          'Reminders',
                          style: globaltextInterTight(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: remainders.length,
                        itemBuilder: (_, index) {
                          final remainder = remainders[index];
                          return TripRemindersSection(
                            title: remainder.title ?? 'Reminder',
                            arrivingDate: remainder.description ?? '',
                            onBook: () => Get.to(() => TripItineraryView(
                                  itineraryId: remainder.itineraryId.toString(),
                                )),
                          );
                        },
                      ),
                    ],
                  );
                }),

                SizedBox(height: 30.h),
                _shareTripWithParents(
                  onTap: () => _showShareTripConfirmDialog(controller),
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Priority Reminders Section — same logic as trip_details_screen

  Widget _buildPriorityRemindersSection(
      BuildContext context, HomeController controller) {
    final reminders = controller.tripDetail.value.priorityRemainders ?? [];

    if (reminders.isEmpty) return SizedBox.shrink();

    final reminder = reminders[0];

    final passportChecked = reminder.passportCountry != null &&
        reminder.passportCountry!.isNotEmpty &&
        reminder.passportCountry != 'null' &&
        reminder.passportExpiry != null &&
        reminder.passportExpiry!.year > 1900 &&
        !reminder.passportExpiry!.isBefore(DateTime.now());

    final visaChecked =
        reminder.isVisaConfirmed == true || reminder.noVisaRequired == true;

    final insuranceChecked = reminder.haveInsurance == true;

    // ✅ allChecked — তিনটাই checked কিনা
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
        Text(
          "Priority Reminders",
          style: globaltextInterTight(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.blackColor,
          ),
        ),
        SizedBox(height: 10.h),

        // ✅ এইটাই নতুন — trip details screen এর মতো same banner
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

  Widget _buildGreetingSection(ProfileController controller) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 14.h),
      child: Obx(() {
        if (controller.isUserProfileLoading.value) {
          return CircularProgressIndicator();
        } else {
          final user = controller.userProfile.value;
          if (user == null) return const SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.PROFILE_ACCOUNT),
                    child: Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE9E9EF),
                      ),
                      child: Center(
                        child: AppNetworkImage(
                          height: 40,
                          width: 40,
                          borderRadius: BorderRadius.circular(100),
                          imageUrl: user!.profileImage ?? "",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, ${user.fullName}',
                        style: globaltextInterTight(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      Text(
                        getGreeting(),
                        style: globaltextInterTight(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.blackColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        }
      }),
    );
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning!';
    if (hour < 17) return 'Good Afternoon!';
    return 'Good Evening!';
  }

  Widget _buildTripsLoadingShimmer() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      padding: EdgeInsets.zero,
      separatorBuilder: (_, index) => SizedBox(width: 10.w),
      itemBuilder: (_, index) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: 220,
          margin: EdgeInsets.only(right: 5.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 18.h, width: 100.w, color: Colors.white),
              SizedBox(height: 12.h),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDestinationsLoadingShimmer() {
    return SizedBox(
      height: 150.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        padding: EdgeInsets.zero,
        separatorBuilder: (_, index) => SizedBox(width: 10.w),
        itemBuilder: (_, index) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 120.h,
            width: 100.w,
            margin: EdgeInsets.only(right: 5.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            padding: EdgeInsets.all(10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 72.h,
                  width: double.infinity,
                  color: Colors.white,
                ),
                Container(
                  height: 12.h,
                  width: double.infinity,
                  color: Colors.white,
                ),
                Container(height: 12.h, width: 50.w, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItineraryDetailLoadingShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 20.h,
            width: 180.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 90.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
        ),
      ],
    );
  }

  Widget _shareTripWithParents({required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.authOrange.withValues(alpha: 0.08),
            border: Border.all(color: AppColors.authOrange, width: 1),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.authOrange.withValues(alpha: 0.1),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppImages.share,
                    width: 20.w,
                    height: 20.w,
                    colorFilter: const ColorFilter.mode(
                      AppColors.authOrange,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Want to share trip with your parents?',
                      style: globaltextInterTight(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Your parents will get notified and informed about you.',
                      style: globaltextInterTight(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackColor.withAlpha(150),
                        lineHeight: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.arrow_forward_ios,
                size: 18.sp,
                color: AppColors.blackColor.withAlpha(150),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showShareTripConfirmDialog(HomeController controller) async {
    await Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 18.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                    onPressed: Get.back,
                    icon: const Icon(Icons.close),
                    splashRadius: 18.r,
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                'Want to share trip with your parents?',
                textAlign: TextAlign.center,
                style: globaltextInterTight(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.blackColor,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Your parents will get notified and informed about you.',
                textAlign: TextAlign.center,
                style: globaltextInterTight(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.blackColor.withAlpha(150),
                  lineHeight: 1.3,
                ),
              ),
              SizedBox(height: 22.h),
              Row(
                children: [
                  Expanded(
                    child: CustomButtonWidget.outline(
                      label: 'Not Now',
                      onPressed: Get.back,
                      color: AppColors.authOrange,
                      fullWidth: true,
                      height: 48.h,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Obx(() {
                      return CustomButtonWidget(
                        loading: controller.isInvitingParent.value,
                        label: 'Yes, interested.',
                        onPressed: () async {
                          final tripId =
                              controller.tripDetail.value.id?.toString() ?? "";
                          if (tripId.isNotEmpty) {
                            await controller.inviteParentByEmail(tripId);
                            Get.back();
                          } else {
                            Get.snackbar("Failed", "No trip selected to share",
                                backgroundColor: Colors.red,
                                colorText: Colors.white);
                          }
                        },
                        bgColor: AppColors.authOrange,
                        fgColor: AppColors.whiteColor,
                        fullWidth: true,
                        height: 48.h,
                        radius: 999.r,
                        elevation: 3,
                        textStyle: globaltextInterTight(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.whiteColor,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildEmptyTripsState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Plan a New Trip",
            style: globaltextInterTight(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.blackColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Let AI create a personalized itinerary for your next adventure.",
            textAlign: TextAlign.center,
            style: globaltextInterTight(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade600,
              lineHeight: 1.4,
            ),
          ),
          SizedBox(height: 15.h),
          Container(
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: AppColors.authOrange.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              AppIcons.newTravel1,
              height: 80.h,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.card_travel_outlined,
                size: 60.sp,
                color: AppColors.authOrange,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          InkWell(
            onTap: () => Get.to(CityViewScreen()),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
              decoration: BoxDecoration(
                color: AppColors.authOrange,
                borderRadius: BorderRadius.circular(30.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.authOrange.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_circle_outline,
                      color: Colors.white, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    "Create Trip",
                    style: globaltextInterTight(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
