import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_snackbar.dart';
import 'package:hamishphipps/app/core/data/network/endpoints.dart';
import 'package:hamishphipps/app/core/data/network/netconfig.dart';

class ParentsController extends GetxController {
  final _networkConfig = NetworkConfigV1.instance;

  final selectedRelation = 'Father'.obs;
  final isLoading = false.obs;



  final relationOptions = ['Father', 'Mother', 'Others'];
  final emailTEC = TextEditingController();

  

  void setRelation(String relation) {
    selectedRelation.value = relation;
  }



  final RxBool isParentLoading = false.obs;
  Future<void> inviteParent() async {
    if(emailTEC.text.isEmpty){
      AppSnackbar.failed("Email is required");
      return;
    }
    try {
      isParentLoading.value = true;
      final response = await _networkConfig.ApiRequestHandler(
          RequestMethod.POST,
          "${Urls.baseUrl}/users/invite-parent",
          jsonEncode({
            "email":emailTEC.text,
            
          }),
          is_auth: true
          );
      if (response != null && response["success"] == true) {
        AppSnackbar.success("${response["message"]}");
      } else {
        AppSnackbar.failed("${response["message"]}");
      }
    } catch (e) {
      log("Parent invite failed ${e.toString()}  ");
    } finally {
      isParentLoading.value = false;
    }
  }
}
