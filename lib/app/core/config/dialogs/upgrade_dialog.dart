import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../style/global_text_style.dart';
import '../../widgets/custom_button_widget.dart';

class UpgradeDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<String> features;
  final VoidCallback? onUpgrade;
  final VoidCallback? onCancel;

  const UpgradeDialog({
    Key? key,
    this.title = "Upgrade to Premium",
    this.subtitle = "You need a premium subscription to access this feature.",
    required this.features,
    this.onUpgrade,
    this.onCancel,
  }) : super(key: key);

  static void show({
    String? title,
    String? subtitle,
    required List<String> features,
    VoidCallback? onUpgrade,
    VoidCallback? onCancel,
  }) {
    Get.dialog(
      UpgradeDialog(
        title: title ?? "Upgrade to Premium",
        subtitle:
            subtitle ??
            "You need a premium subscription to access this feature.",
        features: features,
        onUpgrade: onUpgrade,

        onCancel: onCancel,
      ),
      barrierDismissible: true,
    );
  }

  static void showChildLimitReached({VoidCallback? onUpgrade}) {
    show(
      title: "Add More Children",
      subtitle:
          "You've reached the limit for free accounts. Upgrade to add up to 4 children!",
      features: [
        "Up to 4 children profiles",
        "Up to 4 caregivers",
        "Advanced analytics & insights",
        "Export data to PDF",
        "Generated activities",
        "Weekly recap dashboard",
        "Monthly summaries",
      ],
      onUpgrade: onUpgrade,
    );
  }

  static void showCaregiverLimitReached({VoidCallback? onUpgrade}) {
    show(
      title: "Add More Caregivers",
      subtitle:
          "You've reached the limit for free accounts. Upgrade to add up to 4 caregivers!",
      features: [
        "Up to 4 children profiles",
        "Up to 4 caregivers",
        "Advanced analytics & insights",
        "Export data to PDF",
        "Generated activities",
        "Weekly recap dashboard",
        "Monthly summaries",
      ],
      onUpgrade: onUpgrade,
    );
  }

  @override
  State<UpgradeDialog> createState() => _UpgradeDialogState();
}

class _UpgradeDialogState extends State<UpgradeDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _scale = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut, // bouncy
      reverseCurve: Curves.easeInBack,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _close() {
    // nice exit animation
    _controller.reverse().then((_) => Get.back());
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    // Make it wider on big screens but not huge
    final maxWidth = 520.0; // tweak as you like
    final minWidth = 320.0;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: SafeArea(
        // prevents bottom pixel/overflow near system gestures
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: minWidth,
              maxWidth: maxWidth,
              // keep it from becoming too tall; scroll handles extra
              maxHeight: media.size.height * 0.85,
            ),
            child: ScaleTransition(
              scale: _scale,
              child: Material(
                color: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Container(
                    color: AppColors.whiteColor,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Close button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: widget.onCancel ?? _close,
                                child: Container(
                                  padding: EdgeInsets.all(8.r),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightSilverColor
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 20.r,
                                    color: AppColors.lightSilverColor,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 10.h),

                          // Premium icon
                          Container(
                            width: 60.w,
                            height: 60.h,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.workspace_premium,
                              size: 30.r,
                              color: AppColors.primaryColor,
                            ),
                          ),

                          SizedBox(height: 16.h),

                          Text(
                            widget.title,
                            style: globalTextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkMulberry,
                              textAlign: TextAlign.center,
                            ),
                          ),

                          SizedBox(height: 10.h),

                          Text(
                            widget.subtitle,
                            style: globalTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.lightSilverColor,
                              textAlign: TextAlign.center,
                            ),
                          ),

                          SizedBox(height: 18.h),

                          // Features list
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: AppColors.bgColor,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "With Premium you get:",
                                  style: globalTextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.darkMulberry,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                ...widget.features.map((feature) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 8.h),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          size: 18.r,
                                          color: AppColors.primaryColor,
                                        ),
                                        SizedBox(width: 8.w),
                                        Expanded(
                                          child: Text(
                                            feature,
                                            style: globalTextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.darkMulberry,
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),

                          SizedBox(height: 18.h),

                          // Buttons
                          Row(
                            children: [
                              Expanded(
                                child: CustomButtonWidget.primary(
                                  label: 'Maybe Later',
                                  onPressed: widget.onCancel ?? _close,
                                  fullWidth: true,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: CustomButtonWidget.primary(
                                  label: 'Upgrade Now',
                                  onPressed:
                                      widget.onUpgrade ??
                                      () {
                                        _close();
                                        Get.snackbar(
                                          'Coming Soon',
                                          'Subscription upgrade will be available soon!',
                                          backgroundColor:
                                              AppColors.primaryColor,
                                          colorText: AppColors.whiteColor,
                                        );
                                      },
                                  fullWidth: true,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h), // small bottom breathing space
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
