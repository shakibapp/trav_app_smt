import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/widgets/app_input_textfield.dart';
import 'package:hamishphipps/app/modules/general_user_flow/create_plan/widget/back_button_widget.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/style/global_text_style.dart';
import '../../../../core/widgets/custom_button_widget.dart';
import '../controller/1_preferences_controller.dart';
import '4_your_interests.dart';

class PreferencesTravelDetailsScreen extends GetView<PreferencesController> {
  const PreferencesTravelDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: backButton(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4.h),
              Text(
                'Step 3 of 4',
                style: globaltextInterTight(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryColor,
                  lineHeight: 1.2,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Travel Details',
                style: globaltextInterTight(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.blackColor,
                  lineHeight: 1.05,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Where is home?\nThis helps us tailor visa and entry guidance for your trips.',
                style: globaltextInterTight(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryColor,
                  lineHeight: 1.4,
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                'HOME COUNTRY',
                style: globaltextInterTight(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryColor,
                  lineHeight: 1.2,
                ),
              ),
              SizedBox(height: 8.h),
              Obx(() {
                final value = controller.homeCountry.value;
                return _countryField(
                  value: value,
                  hintText: 'Select Country',
                  onTap: () => _openCountryPicker(
                    context: context,
                    title: 'Select Home Country',
                    currentValue: value,
                    onSelected: controller.setHomeCountry,
                  ),
                );
              }),
              SizedBox(height: 14.h),
              Text(
                'PASSPORT ISSUING COUNTRY',
                style: globaltextInterTight(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryColor,
                  lineHeight: 1.2,
                ),
              ),
              SizedBox(height: 8.h),
              Obx(() {
                final value = controller.passportIssuingCountry.value;
                return _countryField(
                  value: value,
                  hintText: 'Select Country',
                  onTap: () => _openCountryPicker(
                    context: context,
                    title: 'Select Passport Issuing Country',
                    currentValue: value,
                    onSelected: controller.setPassportIssuingCountry,
                  ),
                );
              }),
              SizedBox(height: 10.h),
              Text(
                'PASSPORT EXPIRY',
                style: globaltextInterTight(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryColor,
                  lineHeight: 1.2,
                ),
              ),
              SizedBox(height: 8.h),
              AppInputTextField(
                readOnly: true,
                hintText: "Expiry Date",
                controller: controller.passportExpiryTEC,
                onTap: () => controller.pickPassportExpiryDate(context), // এটা যোগ করো
                suffixIcon: Icon(Icons.calendar_month, color: Colors.grey),
              ),
              Text(
                'Visa requirements are based on your passport',
                style: globaltextInterTight(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryColor,
                  lineHeight: 1.3,
                ),
              ),
              const Spacer(),
              Obx(() {
                final enabled = controller.canContinueStep3;
                return CustomButtonWidget(
                  label: 'Next',
                  onPressed: enabled ? () => controller.updateProfile() : null,
                 loading: controller.isUpdateLoading.value,
                  fullWidth: true,
                  height: 54.h,
                  radius: 30.r,
                  bgColor: enabled
                      ? AppColors.authOrange
                      : AppColors.authOrange.withValues(alpha: 0.45),
                  fgColor: AppColors.whiteColor,
                  textStyle: globaltextInterTight(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.whiteColor,
                    lineHeight: 1.1,
                  ),
                );
              }),
              SizedBox(height: 18.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _countryField({
    required String value,
    required String hintText,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.authFieldBorder, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value.isEmpty ? hintText : value,
                style: globaltextInterTight(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: value.isEmpty
                      ? AppColors.secondaryColor
                      : AppColors.blackColor,
                  lineHeight: 1.1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 22.sp,
              color: AppColors.secondaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openCountryPicker({
    required BuildContext context,
    required String title,
    required String currentValue,
    required ValueChanged<String> onSelected,
  }) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      builder: (context) {
        String query = '';
        return StatefulBuilder(
          builder: (context, setState) {
            final filtered = controller.countries
                .where(
                  (c) => c.toLowerCase().contains(query.trim().toLowerCase()),
                )
                .toList();

            return SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 14.h,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: globaltextInterTight(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.blackColor,
                              lineHeight: 1.1,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.authFieldBorder,
                                width: 1.2,
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.close,
                              size: 18.sp,
                              color: AppColors.blackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    TextField(
                      onChanged: (v) => setState(() => query = v),
                      decoration: InputDecoration(
                        hintText: 'Search country',
                        prefixIcon: Icon(
                          Icons.search,
                          size: 20.sp,
                          color: AppColors.secondaryColor,
                        ),
                        filled: true,
                        fillColor: AppColors.whiteColor,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 14.h,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.r),
                          borderSide: const BorderSide(
                            color: AppColors.authFieldBorder,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.r),
                          borderSide: const BorderSide(
                            color: AppColors.authOrange,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 420.h),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 1,
                          color: AppColors.authFieldBorder.withValues(
                            alpha: 0.6,
                          ),
                        ),
                        itemBuilder: (context, index) {
                          final country = filtered[index];
                          final isSelected =
                              country.trim() == currentValue.trim();
                          return ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              country,
                              style: globaltextInterTight(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor,
                                lineHeight: 1.1,
                              ),
                            ),
                            trailing: isSelected
                                ? Icon(
                                    Icons.check_circle,
                                    color: AppColors.authOrange,
                                    size: 20.sp,
                                  )
                                : null,
                            onTap: () => Navigator.pop(context, country),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (selected != null && selected.trim().isNotEmpty) {
      onSelected(selected);
    }
  }
}
