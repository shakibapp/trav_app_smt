import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../style/global_text_style.dart';

class CustomTextFormWidget extends StatelessWidget {
  const CustomTextFormWidget({
    super.key,
    required this.sectionTitle,
    this.needSectionTitle = true,
    required this.textEditingController,
    this.hintText = '',
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onTogglePasswordVisibility,
    this.keyboardType = TextInputType.text,
    this.prefixWidget,
    this.length,
    this.readOnly = false,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  final String sectionTitle;
  final bool needSectionTitle;
  final TextEditingController textEditingController;
  final String hintText;
  final bool isPassword;
  final bool isPasswordVisible;
  final VoidCallback? onTogglePasswordVisibility;
  final TextInputType keyboardType;
  final Widget? prefixWidget;
  final int? length;
  final bool readOnly;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (needSectionTitle)
          Text(
            sectionTitle,
            style: globaltextInterTight(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.greyColor,
              lineHeight: 1.1,
            ),
          ),
        SizedBox(height: 8.h),
        TextFormField(
          readOnly: readOnly,
          maxLength: length,
          controller: textEditingController,
          keyboardType: keyboardType,
          validator: validator,
          obscureText: isPassword ? !isPasswordVisible : false,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          style: globaltextInterTight(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.blackColor,
            lineHeight: 1.2,
          ),
          decoration: InputDecoration(
            counterText: '',
            hintText: hintText,
            hintStyle: globaltextInterTight(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.secondaryColor,
              lineHeight: 1.2,
            ),
            filled: true,
            fillColor: AppColors.whiteColor,
            prefixIcon: prefixWidget != null
                ? Padding(
                    padding: EdgeInsets.only(left: 14.w, right: 10.w),
                    child: prefixWidget,
                  )
                : null,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            suffixIcon: isPassword
                ? IconButton(
                    onPressed: onTogglePasswordVisibility,
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20.sp,
                      color: AppColors.secondaryColor,
                    ),
                  )
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: const BorderSide(color: AppColors.authFieldBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: const BorderSide(color: AppColors.errorColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: const BorderSide(color: AppColors.errorColor),
            ),
          ),
        ),
      ],
    );
  }
}
