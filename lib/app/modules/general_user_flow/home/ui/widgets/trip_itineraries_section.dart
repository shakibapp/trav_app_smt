// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hamishphipps/app/modules/general_user_flow/home/models/trip_detail_model.dart';

// import '../../../../../core/constants/app_colors.dart';
// import '../../../../../core/style/global_text_style.dart';

// class TripItinerariesSection extends StatelessWidget {
//   final List<Itinerary> itineraries;

//   const TripItinerariesSection({super.key, required this.itineraries});

//   @override
//   Widget build(BuildContext context) {
//     if (itineraries.isEmpty) {
//       return SizedBox.shrink();
//     }

//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20.w),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 24.h),
//           Text(
//             'Itinerary',
//             style: globaltextInterTight(
//               fontSize: 18.sp,
//               fontWeight: FontWeight.w800,
//               color: AppColors.blackColor,
//             ),
//           ),
//           SizedBox(height: 12.h),
//           SizedBox(
//             height: 120.h,
//             child: ListView.separated(
//               scrollDirection: Axis.horizontal,
//               itemCount: itineraries.length,
//               separatorBuilder: (_, __) => SizedBox(width: 12.w),
//               itemBuilder: (_, index) =>
//                   _buildItineraryCard(itineraries[index]),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildItineraryCard(Itinerary itinerary) {
//     return Container(
//       width: 140.w,
//       padding: EdgeInsets.all(14.w),
//       decoration: BoxDecoration(
//         color: AppColors.authFieldFill,
//         borderRadius: BorderRadius.circular(14.r),
//         border: Border.all(
//           color: AppColors.authOrange.withValues(alpha: 0.2),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             itinerary.name,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//             style: globaltextInterTight(
//               fontSize: 14.sp,
//               fontWeight: FontWeight.w700,
//               color: AppColors.blackColor,
//             ),
//           ),
//           SizedBox(height: 8.h),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//             decoration: BoxDecoration(
//               color: AppColors.authOrange.withValues(alpha: 0.1),
//               borderRadius: BorderRadius.circular(6.r),
//             ),
//             child: Text(
//               '${itinerary.days} days',
//               style: globaltextInterTight(
//                 fontSize: 11.sp,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.authOrange,
//               ),
//             ),
//           ),
//           SizedBox(height: 8.h),
//           Text(
//             'Accommodation: ${itinerary.accommodation.replaceAll('_', ' ')}',
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: globaltextInterTight(
//               fontSize: 10.sp,
//               fontWeight: FontWeight.w400,
//               color: AppColors.secondaryColor,
//             ),
//           ),
//           SizedBox(height: 4.h),
//           Text(
//             'Transport: ${itinerary.transportation.replaceAll('_', ' ')}',
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: globaltextInterTight(
//               fontSize: 10.sp,
//               fontWeight: FontWeight.w400,
//               color: AppColors.secondaryColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
