import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/core/constants/country_list.dart';
import 'package:hamishphipps/app/core/constants/image_selete_option.dart';
import 'package:hamishphipps/app/core/style/global_text_style.dart';
import 'package:hamishphipps/app/core/widgets/custom_button_widget.dart';
import 'package:hamishphipps/app/core/widgets/custom_textfield_widget.dart';
import 'package:hamishphipps/app/modules/general_user_flow/profile/widget/account_shimmer.dart';

import '../controller/account_controller.dart';

class AccountScreen extends GetView<AccountController> {
  AccountScreen({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Account',
          style: globaltextInterTight(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.blackColor,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        child: Form(
          key: formKey,
          child: Obx(() {
            return controller.isUserProfileLoading.value
                ? Center(child: AccountShimmer())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileImage(context),
                      SizedBox(height: 24.h),
                      _buildEmailField(),
                      SizedBox(height: 16.h),
                      _buildLocationField(),
                      SizedBox(height: 16.h),
                      _buildFullNameField(),
                      SizedBox(height: 16.h),
                      _buildUserNameField(),
                      SizedBox(height: 32.h),
                      _buildSaveButton(),
                      SizedBox(height: 24.h),
                    ],
                  );
          }),
        ),
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Obx(() {
            final hasSelectedImage = controller.profileImage.value != null;
            final hasProfileImageUrl =
                controller.profileImageUrl.value.isNotEmpty;
            final container = Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE9E9EF),
                image: hasSelectedImage
                    ? DecorationImage(
                        image: FileImage(controller.profileImage.value!),
                        fit: BoxFit.cover,
                      )
                    : hasProfileImageUrl
                    ? DecorationImage(
                        image: NetworkImage(controller.profileImageUrl.value),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) {
                          // Handle image loading error
                          debugPrint('Image loading error: $exception');
                        },
                      )
                    : null,
              ),
              child: (hasSelectedImage || hasProfileImageUrl)
                  ? null
                  : Icon(
                      Icons.person,
                      size: 48.sp,
                      color: AppColors.secondaryColor,
                    ),
            );
            return Stack(
              alignment: Alignment.bottomRight,
              children: [
                container,
                GestureDetector(
                  onTap: () => showImageOptions(
                    context: context,
                    onCamera: () {
                      Get.back();
                      controller.pickImage(
                        target: controller.profileImage,
                        fromCamera: true,
                      );
                    },
                    onGallery: () {
                      Get.back();
                      controller.pickImage(
                        target: controller.profileImage,
                        fromCamera: false,
                      );
                    },
                  ),
                  child: Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.secondaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 18.sp,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: globaltextInterTight(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6F8),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Icon(
                Icons.email_outlined,
                size: 18.sp,
                color: AppColors.secondaryColor,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  controller.emailTEC.text.isEmpty
                      ? 'Enter your email'
                      : controller.emailTEC.text,
                  style: globaltextInterTight(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blackColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: globaltextInterTight(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(
          () => GestureDetector(
            onTap: _showCountryPicker,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F8),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.language,
                    size: 18.sp,
                    color: AppColors.secondaryColor,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      controller.location.value.isEmpty
                          ? 'Select country'
                          : controller.location.value,
                      style: globaltextInterTight(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: controller.location.value.isEmpty
                            ? AppColors.secondaryColor
                            : AppColors.blackColor,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 20.sp,
                    color: AppColors.secondaryColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFullNameField() {
    return CustomTextFormWidget(
      sectionTitle: 'FULL NAME',
      textEditingController: controller.fullNameController,
      hintText: 'Enter your full name',
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Full name is required';
        }
        if (value.length < 3) {
          return 'Full name must be at least 3 characters';
        }
        return null;
      },
    );
  }

  Widget _buildUserNameField() {
    return CustomTextFormWidget(
      sectionTitle: 'USER NAME',
      textEditingController: controller.userNameController,
      hintText: 'Enter your user name',
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'User name is required';
        }
        if (value.length < 3) {
          return 'User name must be at least 3 characters';
        }
        return null;
      },
    );
  }

  Widget _buildSaveButton() {
    return Obx(
      () => CustomButtonWidget.primary(
        label: 'Save Changes',
        loading: controller.isUpdateLoading.value,
        onPressed: () {
          if (formKey.currentState!.validate()) {
            controller.updateProfile();
          }
        },
      ),
    );
  }

  void _showCountryPicker() {
    final searchQuery = ''.obs;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          height: 500.h,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Text(
                  'Select Country',
                  style: globaltextInterTight(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.blackColor,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: TextField(
                  onChanged: (value) => searchQuery.value = value,
                  decoration: InputDecoration(
                    hintText: 'Search country...',
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.secondaryColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: AppColors.secondaryColor.withValues(alpha: 0.3),
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                  ),
                  style: globaltextInterTight(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blackColor,
                  ),
                ),
              ),
              Expanded(
                child: Obx(() {
                  final filtered = countryList
                      .where(
                        (country) =>
                            (country['name'] ?? '').toLowerCase().contains(
                              searchQuery.value.toLowerCase(),
                            ) ||
                            (country['icon'] ?? '').contains(searchQuery.value),
                      )
                      .toList();

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final country = filtered[index];
                      return GestureDetector(
                        onTap: () {
                          controller.location.value = country['name'] ?? '';
                          Get.back();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          child: Row(
                            children: [
                              Text(
                                country['icon'] ?? '🌍',
                                style: TextStyle(fontSize: 24.sp),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  country['name'] ?? '',
                                  style: globaltextInterTight(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blackColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
