// import 'dart:convert';

// import 'package:get/get.dart';
// import 'package:thecaribbeannote/app/core/data/network/endpoints.dart';
// import 'package:thecaribbeannote/app/core/data/network/netconfig.dart';
// import 'package:thecaribbeannote/app/core/data/profile_info/profile_info_model.dart';
// import 'package:thecaribbeannote/app/core/services/local_data.dart';
// import 'package:thecaribbeannote/app/core/services/logger.dart';

// class ProfileInfoController extends GetxController {
//   final Rxn<ProfileInfoModel> userInfo = Rxn<ProfileInfoModel>();

//   @override
//   void onInit() {
//     super.onInit();
//     getUserInfo();
//   }

//   Future<void> getUserInfo() async {
//     try {
//       final response = await NetworkConfigV1.instance.ApiRequestHandler(
//         RequestMethod.GET,
//         Urls.getUserInfo,
//         jsonEncode({}),
//         is_auth: true,
//       );

//       final success = response != null && response['success'] == true;
//       final data = response['data'] ?? {};

//       if (success) {
//         userInfo.value = ProfileInfoModel.fromJson(data);

//         // Save role to local storage
//         final role = userInfo.value?.role;
//         if (role != null && role.isNotEmpty) {
//           await LocalService.localService.setRole(role);
//           logger.d('Role saved to LocalService: $role');
//         }

//         logger.d(response['message']);
//       } else {
//         logger.e(response['message']);
//       }
//     } catch (e) {
//       logger.e(e.toString());
//     }
//   }
// }
