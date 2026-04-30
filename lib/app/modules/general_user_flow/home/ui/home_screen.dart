import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_icons.dart';
import 'package:hamishphipps/app/core/constants/app_images.dart';
import 'package:hamishphipps/app/core/widgets/custom_button_widget.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/style/global_text_style.dart';
import '../controller/home_controller.dart';
import 'widgets/home_plan_trip_section.dart';
import 'widgets/home_destination_card.dart';
import 'widgets/home_horizontal_card_section.dart';
import 'widgets/home_upcoming_trip_card.dart';

class HomeScreen extends GetView<HomeController> {
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
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                AppImages.tripBg,
                // 'assets/images/28.png',
                // 'assets/images/27.png',
                width: double.infinity,
                height: 400.h,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          // Main Content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50.h),
                // Greeting Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: _buildGreetingSection(),
                ),
                // Plan Trip Section or Trips List
                Obx(() {
                  if (controller.showPlanTripSection.value) {
                    return HomePlanTripSection(
                      onCreateTrip: controller.onCreateTripPressed,
                    );
                  }
                  return _buildTripsSection();
                }),

                SizedBox(height: 15.h),
                _buildDestinationsSection(),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    'Priority Reminders',
                    style: globalTextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,
                    ),
                  ),
                ),

                // SizedBox(height: 10.h),
                _priorityReminderWidget(
                  title: "Passport",
                  iconPath: AppIcons.passport,
                  onPressed: () {},
                  buttonText: 'Update',
                ),
                _priorityReminderWidget(
                  title: "Visa",
                  iconPath: AppIcons.visa,
                  onPressed: () {},
                  buttonText: 'Check',
                ),
                _priorityReminderWidget(
                  title: "Travel Insurance",
                  iconPath: AppIcons.agreement,
                  onPressed: () {},
                  buttonText: 'Add',
                ),

                // prioriry reminder
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    'Priority Reminders',
                    style: globalTextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,
                    ),
                  ),
                ),
                _priorityReminderWidget(
                  title: "Book flight to Barcelona",
                  iconPath: AppIcons.airplane,
                  onPressed: () {},
                  buttonText: 'Book',
                  subtitle: 'Arrving 20 Mar, 2026',
                ),

                SizedBox(height: 20.h),

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

  Widget _buildTripsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),

          Row(
            children: [
              Expanded(
                child: Text(
                  'Upcoming Trip',
                  style: globaltextInterTight(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.blackColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Horizontal Trips Carousel
          Obx(() {
            final trips = controller.upcomingTrips;
            if (trips.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 40.h),
                child: Center(
                  child: Text(
                    'No trips yet',
                    style: globaltextInterTight(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ),
              );
            }

            return SizedBox(
              height: 200.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(right: 18.w),
                itemCount: trips.length,
                separatorBuilder: (_, __) => SizedBox(width: 14.w),
                itemBuilder: (_, index) => HomeUpcomingTripCard(
                  trip: trips[index],
                  width: 300.w,
                  height: 190.h,
                ),
              ),
            );
          }),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildDestinationsSection() {
    return HomeHorizontalCardSection(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      title: 'Your Destinations',
      subtitle: '2 stops (Total)',
      listHeight: 230.h,
      cards: const [
        HomeDestinationCard(
          imagePath: 'assets/images/rome.png',
          title: 'Rome, Italy',
          subtitle: 'Europe',
        ),
        HomeDestinationCard(
          imagePath: 'assets/images/27.png',
          title: 'Venice, Italy',
          subtitle: 'Europe',
        ),
      ],
    );
  }
}

Widget _shareTripWithParents({required VoidCallback onTap}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20.w),
    child: Material(
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
    ),
  );
}

Widget _priorityReminderWidget({
  required VoidCallback onPressed,
  required String title,
  String? subtitle,
  required String buttonText,
  required String iconPath,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.authFieldFill,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.authOrange.withValues(alpha: 0.1),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              iconPath,
              width: 22.w,
              height: 22.w,
              colorFilter: const ColorFilter.mode(
                AppColors.authOrange,
                BlendMode.srcIn,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: globalTextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
                if (subtitle != null && subtitle.trim().isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: globalTextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                      color: AppColors.blackColor.withAlpha(150),
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 12.w),
          CustomButtonWidget(
            label: buttonText,
            onPressed: onPressed,
            bgColor: AppColors.authOrange,
            fgColor: AppColors.whiteColor,
            fullWidth: false,
            height: 34.h,
            width: 84.w,
            radius: 999.r,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
            textStyle: globalTextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13.sp,
              color: AppColors.whiteColor,
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> _showShareTripConfirmDialog(HomeController controller) async {
  await Get.dialog(
    Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
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
            CustomButtonWidget(
              label: 'Invite',
              onPressed: controller.inviteParent,
              bgColor: AppColors.authOrange,
              fgColor: AppColors.whiteColor,
              fullWidth: true,
              height: 54.h,
              radius: 999.r,
              elevation: 2,
              textStyle: globaltextInterTight(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
