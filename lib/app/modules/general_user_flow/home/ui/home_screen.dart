import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_images.dart';
import 'package:hamishphipps/app/core/widgets/custom_button_widget.dart';
import 'package:hamishphipps/app/core/widgets/network_image.dart';
import 'package:hamishphipps/app/modules/general_user_flow/home/ui/widgets/trip_priority_reminders_section.dart';
import 'package:hamishphipps/app/modules/general_user_flow/home/ui/widgets/trip_reminders_section.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/style/global_text_style.dart';
import '../controller/home_controller.dart';

class HomeScreen extends GetWidget<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          // Background Image with opacity
          Positioned(
            // top: -20.h,
            // right: -30.w,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.1,
                child: Image.asset(
                  AppImages.tripBg,
                  // 'assets/images/28.png',
                  // 'assets/images/27.png',
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
                // Greeting Section
                _buildGreetingSection(),

                SizedBox(height: 10.h),
                Text(
                  "Upcoming Trips",
                  style: globaltextInterTight(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.blackColor,
                  ),
                ),

                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Obx(() {
                    return controller.isLoadingTrips.value
                        ? _buildTripsLoadingShimmer()
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,

                            itemCount: controller.upcomingTripsFromApi.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (_, index) {
                              final trip =
                                  controller.upcomingTripsFromApi[index];
                              return Obx(() {
                                return InkWell(
                                  onTap: () =>
                                      controller.getTripDetailById(trip.id),
                                  borderRadius: BorderRadius.circular(20.r),
                                  child: Container(
                                    margin: EdgeInsets.only(right: 5.h),
                                    width: 220,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.r),
                                      border: Border.all(
                                        color:
                                            controller.selectedTripId.value ==
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
                                        // Background Image
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            20.r,
                                          ),
                                          child: Image.asset(
                                            'assets/images/rome.png',
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),

                                        // Status badge (always top-left)
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              top: 12.h,
                                              left: 12.w,
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12.w,
                                                vertical: 6.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.whiteColor,
                                                borderRadius:
                                                    BorderRadius.circular(20.r),
                                              ),
                                              child: Text(
                                                trip.status,
                                                style: globaltextInterTight(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.authOrange,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Blurred info panel (matches design)
                                        Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(16.r),
                                              topRight: Radius.circular(16.r),
                                              bottomLeft: Radius.circular(20.r),
                                              bottomRight: Radius.circular(
                                                20.r,
                                              ),
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 16.w,
                                                vertical: 14.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.black54,
                                                border: Border.all(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.18),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          trip.city.join(', '),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              globaltextInterTight(
                                                                fontSize: 15.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color: AppColors
                                                                    .whiteColor,
                                                                lineHeight: 1.1,
                                                              ),
                                                        ),
                                                        SizedBox(height: 4.h),
                                                        Text(
                                                          '${DateFormat('MMM d').format(DateTime.parse(trip.startDate))} – '
                                                          '${DateFormat('MMM d').format(DateTime.parse(trip.endDate))} '
                                                          '· ${DateTime.parse(trip.endDate).difference(DateTime.parse(trip.startDate)).inDays} days '
                                                          '\$${trip.budget}',
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              globaltextInterTight(
                                                                fontSize: 11.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: AppColors
                                                                    .whiteColor,
                                                                lineHeight: 1.2,
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
                          );
                  }),
                ),

                SizedBox(height: 10.h),
                Text(
                  "Your Destinations",
                  style: globaltextInterTight(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.blackColor,
                  ),
                ),

                SizedBox(
                  height: 120.h,
                  width: double.infinity,
                  child: Obx(() {
                    return controller.isLoadingTripDetail.value
                        ? _buildDestinationsLoadingShimmer()
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,

                            itemCount:
                                controller
                                    .tripDetail
                                    .value
                                    .itineraries
                                    ?.length ??
                                0,
                            padding: EdgeInsets.zero,
                            itemBuilder: (_, index) {
                              final itinerary = controller
                                  .tripDetail
                                  .value
                                  .itineraries?[index];
                              if (itinerary == null) {
                                return const SizedBox.shrink();
                              }
                              return Obx(() {
                                return InkWell(
                                  onTap: itinerary.id == null
                                      ? null
                                      : () => controller.getItineraryDetailById(
                                          itinerary.id!,
                                        ),
                                  borderRadius: BorderRadius.circular(20.r),
                                  child: Container(
                                    height: 120.h,
                                    margin: EdgeInsets.only(right: 5.h),

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.r),
                                      border: Border.all(
                                        color:
                                            controller
                                                    .selectedItineraryId
                                                    .value ==
                                                itinerary.id
                                            ? AppColors.authOrange
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 5.h),
                                          child: Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.r),
                                            ),
                                            child: AppNetworkImage(
                                              imageUrl: itinerary.image,

                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "${itinerary.name}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                        Text(
                                          "Days:${itinerary.days}",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                            },
                          );
                  }),
                ),
                SizedBox(height: 10.h),
                Obx(() {
                  if (controller.isLoadingItineraryDetail.value) {
                    return _buildItineraryDetailLoadingShimmer();
                  }

                  final itinerary = controller.itineraryDetail.value;
                  if (itinerary.id == null || itinerary.id!.isEmpty) {
                    return SizedBox.shrink();
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

                      if (itinerary.priorityRemainders != null &&
                          itinerary.priorityRemainders!.isNotEmpty)
                        ...itinerary.priorityRemainders!.map(
                          (reminder) => Column(
                            children: [
                              SizedBox(height: 10.h),
                              priorityRemainder(
                                context: context,
                                title: 'Passport',
                                onUpdate: () {},
                                buttonText: reminder.isVisaConfirmed == true
                                    ? 'Update'
                                    : 'Add',
                                icon: Icons.abc,
                              ),

                              SizedBox(height: 10.h),
                              priorityRemainder(
                                context: context,
                                title: 'Visa',
                                onUpdate: () {},
                                buttonText: reminder.isVisaConfirmed == true
                                    ? 'Update'
                                    : 'Add',
                                icon: Icons.abc,
                              ),

                              SizedBox(height: 10.h),
                              priorityRemainder(
                                context: context,
                                title: 'Travel Insurance',
                                onUpdate: () {},
                                buttonText: reminder.isVisaConfirmed == true
                                    ? 'Update'
                                    : 'Add',
                                icon: Icons.abc,
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                }),

                SizedBox(height: 20.h),
                Text(
                  'Reminders',
                  style: globaltextInterTight(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.blackColor,
                  ),
                ),
                Obx(() {
                  if (controller.isLoadingItineraryDetail.value) {
                    return _buildItineraryDetailLoadingShimmer();
                  } else {
                    final itinerary = controller.itineraryDetail.value;
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itinerary.remainders?.length ?? 0,
                      itemBuilder: (_, index) {
                        final remainder = itinerary.remainders?[index];
                        return TripRemindersSection(
                          title: '${remainder?.title ?? 'Reminder'}',
                          arrivingDate:
                              "${remainder!.description ?? ''} · ${remainder.daysLeft ?? 0} days left",
                          onBook: () {},
                        );
                      },
                    );
                  }
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

  Widget _buildGreetingSection() {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE9E9EF),
                ),
                child: Center(
                  child: Text(
                    'H',
                    style: globaltextInterTight(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, Hamish!',
                    style: globaltextInterTight(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                  Text(
                    'Good Morning!',
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
      ),
    );
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
    return ListView.separated(
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
                    child: CustomButtonWidget(
                      label: 'Yes, interested.',
                      onPressed: () {
                        Get.back();
                        controller.parentEmailController.clear();
                        Future.microtask(
                          () => _showInviteParentEmailDialog(controller),
                        );
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
                    ),
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

  Future<void> _showInviteParentEmailDialog(HomeController controller) async {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'ENTER PARENT EMAIL',
                      style: globaltextInterTight(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: Get.back,
                    icon: const Icon(Icons.close),
                    splashRadius: 18.r,
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: AppColors.authOrange.withValues(alpha: 0.25),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: TextField(
                  controller: controller.parentEmailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: 'parent email',
                    border: InputBorder.none,
                    hintStyle: globaltextInterTight(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.blackColor.withAlpha(120),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              // CustomButtonWidget(
              //   label: 'Invite',
              //   onPressed: controller.inviteParent,
              //   bgColor: AppColors.authOrange,
              //   fgColor: AppColors.whiteColor,
              //   fullWidth: true,
              //   height: 54.h,
              //   radius: 999.r,
              //   elevation: 2,
              //   textStyle: globaltextInterTight(
              //     fontSize: 16.sp,
              //     fontWeight: FontWeight.w700,
              //     color: AppColors.whiteColor,
              //   ),
              // ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
