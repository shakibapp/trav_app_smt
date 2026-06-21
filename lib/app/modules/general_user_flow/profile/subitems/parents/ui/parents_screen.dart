import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/core/style/global_text_style.dart';
import 'package:hamishphipps/app/core/widgets/custom_button_widget.dart';
import 'package:hamishphipps/app/core/widgets/custom_textfield_widget.dart';

import '../controller/parents_controller.dart';

class ParentsScreen extends GetWidget<ParentsController> {
  const ParentsScreen({super.key});

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
          'Parents',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildConnectedParent()],
        ),
      ),
    );
  }

  Widget _buildConnectedParent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Connected Parent',
          style: globaltextInterTight(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
        ),
        SizedBox(height: 12.h),
        _buildParentEmail(),
        SizedBox(height: 16.h),
        _buildRelationDropdown(),
        SizedBox(height: 24.h),
        _buildInviteButtonSmall(),
      ],
    );
  }

  Widget _buildParentEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ENTER PARENT EMAIL',
          style: globaltextInterTight(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.greyColor,
            lineHeight: 1.1,
          ),
        ),
        SizedBox(height: 8.h),
        CustomTextFormWidget(
          sectionTitle: '',
          needSectionTitle: false,
          textEditingController: controller.emailTEC,
          hintText: 'parent email',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          
        ),
      ],
    );
  }

  Widget _buildRelationDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RELATION',
          style: globaltextInterTight(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.greyColor,
            lineHeight: 1.1,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(
          () => Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.authFieldBorder, width: 1.5),
              borderRadius: BorderRadius.circular(12.r),
              color: AppColors.whiteColor,
            ),
            child: DropdownButton<String>(
              value: controller.selectedRelation.value,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.setRelation(newValue);
                }
              },
              isExpanded: true,
              underline: SizedBox.shrink(),
              borderRadius: BorderRadius.circular(12.r),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
              items: controller.relationOptions.map<DropdownMenuItem<String>>((
                String value,
              ) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: globaltextInterTight(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blackColor,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInviteButtonSmall() {
    return Obx((){
        return CustomButtonWidget(
          label: 'Invite',
          onPressed: ()=>controller.inviteParent(),
          fullWidth: true,
          bgColor: AppColors.authOrange,
          fgColor: AppColors.whiteColor,
          loading: controller.isParentLoading.value,
          textStyle: globaltextInterTight(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.whiteColor,
            lineHeight: 1.1,
          ),
        );
      }
    );
  }
}
