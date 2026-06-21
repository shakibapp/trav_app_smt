// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:hamishphipps/app/core/style/global_text_style.dart';

// import '../constants/app_colors.dart';

// class AppSnackBar {
//   AppSnackBar._(); // no instances

//   static void show({
//     required String message,
//     required bool isSuccessful,
//     String? title,
//     Duration? duration,
//   }) {
//     // If there is no context yet, just skip to avoid crashes
//     if (Get.context == null) return;

//     final context = Get.context!;

//     final Color bg = isSuccessful
//         ? AppColors.successColor
//         : AppColors.errorColor;

//     final IconData icon = isSuccessful
//         ? Icons.check_circle_rounded
//         : Icons.error_rounded;

//     final content = Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(icon, size: 22.sp, color: Colors.white),
//         SizedBox(width: 10.w),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               if (title != null && title.trim().isNotEmpty)
//                 Text(
//                   title,
//                   style: globalTextStyle(
//                     fontSize: 13.sp,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.white,
//                   ),
//                 ),
//               Text(
//                 message,
//                 style: globalTextStyle(
//                   fontSize: 12.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         GestureDetector(
//           onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
//           child: const Icon(Icons.close, color: Colors.white),
//         ),
//       ],
//     );

//     final snackBar = SnackBar(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
//       behavior: SnackBarBehavior.floating,
//       backgroundColor: bg,
//       margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 20.h),
//       padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
//       duration: duration ?? const Duration(seconds: 2),
//       content: content,
//     );

//     final messenger = ScaffoldMessenger.of(context);
//     messenger.hideCurrentSnackBar(); // close old one (optional)
//     messenger.showSnackBar(snackBar); // show new one
//   }

//   static void success(String message, {String? title, Duration? duration}) =>
//       show(
//         message: message,
//         isSuccessful: true,
//         title: title,
//         duration: duration,
//       );

//   static void error(String message, {String? title, Duration? duration}) =>
//       show(
//         message: message,
//         isSuccessful: false,
//         title: title,
//         duration: duration,
//       );
// }
