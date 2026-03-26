import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../widgets/custom_button_widget.dart';

class LogoutDialog {
  static showLogoutDialog(BuildContext context) {
    return Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.whiteColor,
        title: Icon(Icons.logout, size: 80.r, color: AppColors.errorColor),
        content: Text(
          'logout_confirm'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        actions: [
          Row(
            spacing: 10.w,
            children: [
              Expanded(
                child: CustomButtonWidget.outline(
                  label: 'logout_button'.tr,
                  onPressed: () async {
                    // // Clear local storage
                    // LocalService.localService.clearUserData();

                    // // Disconnect WebSocket if connected
                    // if (Get.isRegistered<WebSocketService>()) {
                    //   final ws = Get.find<WebSocketService>();
                    //   await ws.disconnect();
                    // }

                    // // Delete all permanent controllers and clear their data
                    // if (Get.isRegistered<ProfileInfoController>()) {
                    //   final profileController =
                    //       Get.find<ProfileInfoController>();
                    //   profileController.userInfo.value = null;
                    //   Get.delete<ProfileInfoController>(force: true);
                    // }

                    // if (Get.isRegistered<ChildrenService>()) {
                    //   final childrenService = Get.find<ChildrenService>();
                    //   childrenService.childrenList.clear();
                    //   childrenService.selectedChild.value = '';
                    //   Get.delete<ChildrenService>(force: true);
                    // }

                    // if (Get.isRegistered<ChatController>()) {
                    //   final chatController = Get.find<ChatController>();
                    //   chatController.messages.clear();
                    //   chatController.adminUser.value = null;
                    //   Get.delete<ChatController>(force: true);
                    // }

                    // // Navigate to login and clear all routes
                    // Get.offAllNamed(AppRoutes.LOGIN);
                  },

                  color: AppColors.errorColor,
                ),
              ),
              Expanded(
                child: CustomButtonWidget.primary(
                  label: 'cancel'.tr,
                  onPressed: () => Get.back(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static deleteAccountDialog(BuildContext context) {
    return Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.whiteColor,
        title: Icon(Icons.logout, size: 80.r, color: AppColors.errorColor),
        content: Text(
          'delete_account_confirm'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        actions: [
          Row(
            spacing: 10.w,
            children: [
              Expanded(
                child: Obx(() {
                  return CustomButtonWidget.outline(
                    label: 'delete'.tr,
                    onPressed: () {
                      // Get.find<ProfileController>().deleteUserAccoount();
                    },
                    color: AppColors.errorColor,
                    // loading: Get.find<ProfileController>().isLoading.value,
                  );
                }),
              ),
              Expanded(
                child: CustomButtonWidget.primary(
                  label: 'cancel'.tr,
                  onPressed: () => Get.back(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static showDeletePostDialog(BuildContext context, VoidCallback onDelete) {
    return Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.whiteColor,
        title: Icon(
          Icons.delete_outline,
          size: 80.r,
          color: AppColors.errorColor,
        ),
        content: Text(
          'delete_post_confirm'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        actions: [
          Row(
            spacing: 10.w,
            children: [
              Expanded(
                child: CustomButtonWidget.outline(
                  label: 'delete'.tr,
                  onPressed: () {
                    Get.back(); // Close dialog
                    onDelete(); // Execute delete callback
                  },
                  color: AppColors.errorColor,
                ),
              ),
              Expanded(
                child: CustomButtonWidget.primary(
                  label: 'cancel'.tr,
                  onPressed: () => Get.back(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
