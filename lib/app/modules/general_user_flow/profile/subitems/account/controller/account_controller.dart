import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/common_file_picket.dart';
import 'package:hamishphipps/app/core/services/local_data.dart';

class AccountController extends GetxController {
  final fullName = ''.obs;
  final userName = ''.obs;
  final email = ''.obs;
  final location = ''.obs;
  final imageFile = Rxn<File>();
  final imageUrl = ''.obs;
  final isLoading = false.obs;

  late TextEditingController fullNameController;
  late TextEditingController userNameController;

  @override
  void onInit() {
    super.onInit();
    fullNameController = TextEditingController();
    userNameController = TextEditingController();
    loadAccountData();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    userNameController.dispose();
    super.onClose();
  }

  void loadAccountData() {
    final name = LocalService.localService.getName() ?? '';
    final userEmail = LocalService.localService.getEmail() ?? '';

    fullName.value = name;
    fullNameController.text = name;

    email.value = userEmail;
    location.value = '';
    // userName and imageUrl can come from API
  }

  Future<void> pickProfileImage() async {
    try {
      final pickedFile = await CommonFilePicker.pick(
        isFile: false,
        useCamera: false,
      );

      if (pickedFile != null) {
        imageFile.value = pickedFile;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveChanges() async {
    try {
      isLoading.value = true;

      // Save to local storage
      if (fullName.value.isNotEmpty) {
        await LocalService.localService.setName(fullName.value);
      }
      if (location.value.isNotEmpty) {
        await LocalService.localService.setCountry(location.value);
      }

      // TODO: Send image to API if imageFile.value != null
      // TODO: Send other changes to API

      isLoading.value = false;
      Get.back();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }
}
