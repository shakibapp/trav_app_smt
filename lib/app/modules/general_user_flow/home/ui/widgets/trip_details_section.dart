// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hamishphipps/app/modules/general_user_flow/home/models/trip_detail_model.dart';

// import '../../../../../core/constants/app_colors.dart';
// import '../../../../../core/style/global_text_style.dart';

// class TripDetailsSection extends StatelessWidget {
//   final TripDetailData? tripDetail;
//   final bool isLoading;

//   const TripDetailsSection({
//     super.key,
//     this.tripDetail,
//     this.isLoading = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
//         child: const CircularProgressIndicator(),
//       );
//     }

//     if (tripDetail == null) {
//       return SizedBox.shrink();
//     }

//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20.w),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 20.h),
//           // Trip header info
//           Container(
//             padding: EdgeInsets.all(16.w),
//             decoration: BoxDecoration(
//               color: AppColors.authFieldFill,
//               borderRadius: BorderRadius.circular(16.r),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             tripDetail!.city.join(', '),
//                             style: globaltextInterTight(
//                               fontSize: 18.sp,
//                               fontWeight: FontWeight.w800,
//                               color: AppColors.blackColor,
//                             ),
//                           ),
//                           SizedBox(height: 4.h),
//                           Text(
//                             tripDetail!.region.join(', '),
//                             style: globaltextInterTight(
//                               fontSize: 13.sp,
//                               fontWeight: FontWeight.w500,
//                               color: AppColors.secondaryColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 12.w,
//                         vertical: 6.h,
//                       ),
//                       decoration: BoxDecoration(
//                         color: AppColors.authOrange.withValues(alpha: 0.1),
//                         borderRadius: BorderRadius.circular(20.r),
//                       ),
//                       child: Text(
//                         tripDetail!.status,
//                         style: globaltextInterTight(
//                           fontSize: 12.sp,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.authOrange,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 12.h),
//                 // Trip dates and days
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _buildInfoItem(
//                         'Start',
//                         _formatDate(tripDetail!.startDate),
//                       ),
//                     ),
//                     Expanded(
//                       child: _buildInfoItem(
//                         'End',
//                         _formatDate(tripDetail!.endDate),
//                       ),
//                     ),
//                     Expanded(
//                       child: _buildInfoItem('Days', '${tripDetail!.totalDays}'),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 12.h),
//                 // Budget and interests
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Budget: \$${tripDetail!.budget}',
//                       style: globaltextInterTight(
//                         fontSize: 13.sp,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.blackColor,
//                       ),
//                     ),
//                   ],
//                 ),
//                 if (tripDetail!.interests.isNotEmpty) ...[
//                   SizedBox(height: 8.h),
//                   Text(
//                     'Interests: ${tripDetail!.interests.join(', ')}',
//                     style: globaltextInterTight(
//                       fontSize: 12.sp,
//                       fontWeight: FontWeight.w500,
//                       color: AppColors.secondaryColor,
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoItem(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: globaltextInterTight(
//             fontSize: 11.sp,
//             fontWeight: FontWeight.w500,
//             color: AppColors.secondaryColor,
//           ),
//         ),
//         SizedBox(height: 4.h),
//         Text(
//           value,
//           style: globaltextInterTight(
//             fontSize: 13.sp,
//             fontWeight: FontWeight.w700,
//             color: AppColors.blackColor,
//           ),
//         ),
//       ],
//     );
//   }

//   String _formatDate(String dateString) {
//     try {
//       final date = DateTime.parse(dateString);
//       final months = [
//         'Jan',
//         'Feb',
//         'Mar',
//         'Apr',
//         'May',
//         'Jun',
//         'Jul',
//         'Aug',
//         'Sep',
//         'Oct',
//         'Nov',
//         'Dec',
//       ];
//       return '${date.day} ${months[date.month - 1]}';
//     } catch (e) {
//       return dateString;
//     }
//   }
// }
