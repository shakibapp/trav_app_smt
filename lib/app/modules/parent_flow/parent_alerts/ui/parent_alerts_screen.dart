import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/core/constants/app_images.dart';
import 'package:hamishphipps/app/core/style/global_text_style.dart';
import 'package:hamishphipps/app/core/widgets/app_bg.dart';
import 'package:hamishphipps/app/modules/parent_flow/parent_alerts/model/parent_alets_model.dart';
import 'package:hamishphipps/app/modules/parent_flow/parent_home/controller/parent_home_controller.dart';

class ParentAlertsScreen extends GetView<ParentHomeController> {
  const ParentAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundScreen(
      bgImg: AppImages.tripBgLight,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60.h),
            Text(
              "Alerts & Updates",
              style: globalTextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Stay in the loop with everything.",
              style: globalTextStyle(
                fontSize: 14.sp,
                color: AppColors.greyColor,
              ),
            ),
            SizedBox(height: 20.h),

            // ✅ API data থেকে alerts show
            Obx(() {
              if (controller.isAlertsLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.alerts.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.h),
                    child: Text(
                      "No alerts yet.",
                      style: globalTextStyle(
                        fontSize: 13.sp,
                        color: AppColors.greyColor,
                      ),
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.alerts.length,
                itemBuilder: (context, index) {
                  final alert = controller.alerts[index];
                  // প্রথমটা detailed (reason আছে), বাকিগুলো simple
                  if (index == 0 && alert.detail != null) {
                    return _buildDetailedAlert(alert);
                  }
                  return _buildSimpleAlert(alert);
                },
              );
            }),

            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }

  // icon + color — type অনুযায়ী
  IconData _getIcon(String? type) {
    switch (type) {
      case 'Flight_Delayed':
        return Icons.flight_takeoff;
      case 'Flight_Cancelled':
        return Icons.cancel_outlined;
      case 'CheckIn':
        return Icons.check_circle_outline;
      case 'Hotel':
        return Icons.hotel;
      case 'Not_Arrived':
        return Icons.error_outline;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getColor(String? type) {
    switch (type) {
      case 'Flight_Cancelled':
        return Colors.red;
      case 'CheckIn':
        return Colors.green;
      case 'Hotel':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    final local = dt.toLocal();
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  Widget _buildDetailedAlert(ParentAlertModel alert) {
    final icon = _getIcon(alert.type);
    final color = _getColor(alert.type);

    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.orange.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20.sp),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.summary ?? '',
                      style: globalTextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      alert.type ?? '',
                      style: globalTextStyle(
                        fontSize: 11.sp,
                        color: AppColors.greyColor,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _formatTime(alert.createdAt),
                style: globalTextStyle(
                  fontSize: 11.sp,
                  color: AppColors.greyColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Divider(color: Colors.grey.shade200),
          SizedBox(height: 10.h),
          Text(
            "Detail",
            style: globalTextStyle(
              fontSize: 12.sp,
              color: AppColors.greyColor,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            alert.detail ?? '',
            style: globalTextStyle(
              fontSize: 11.sp,
              color: Colors.orange.shade700,
              lineHeight: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleAlert(ParentAlertModel alert) {
    final icon = _getIcon(alert.type);
    final color = _getColor(alert.type);

    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20.sp),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.summary ?? '',
                  style: globalTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  alert.detail ?? '',
                  style: globalTextStyle(
                    fontSize: 11.sp,
                    color: AppColors.greyColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            _formatTime(alert.createdAt),
            style: globalTextStyle(
              fontSize: 11.sp,
              color: AppColors.greyColor,
            ),
          ),
        ],
      ),
    );
  }
}
