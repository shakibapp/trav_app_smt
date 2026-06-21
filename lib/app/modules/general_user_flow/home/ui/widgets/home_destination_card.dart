import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/style/global_text_style.dart';

class HomeDestinationCard extends StatelessWidget {
  final String imagePath;
  final String? title;
  final String? subtitle;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const HomeDestinationCard({
    super.key,
    required this.imagePath,
    this.title,
    this.subtitle,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = width ?? 260.w;
    final cardHeight = height ?? 220.h;

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.r),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(imagePath, fit: BoxFit.cover),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.04),
                            Colors.black.withValues(alpha: 0.08),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Bottom blur panel
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14.r),
                        topRight: Radius.circular(14.r),
                        bottomLeft: Radius.circular(20.r),
                        bottomRight: Radius.circular(20.r),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 14.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.90),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.55),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (title != null && title!.trim().isNotEmpty)
                                Text(
                                  title!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: globaltextInterTight(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.blackColor,
                                    lineHeight: 1.1,
                                  ),
                                ),
                              if (subtitle != null &&
                                  subtitle!.trim().isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(top: 4.h),
                                  child: Text(
                                    subtitle!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: globaltextInterTight(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.blackColor.withAlpha(
                                        150,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
