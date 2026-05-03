import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_toast.dart';
import 'package:hamishphipps/app/core/data/network/endpoints.dart';
import 'package:hamishphipps/app/modules/general_user_flow/profile/model/user_profile_model.dart';
import 'package:http/http.dart' as http;
import 'package:hamishphipps/app/core/constants/common_file_picket.dart';
import 'package:hamishphipps/app/core/data/network/netconfig.dart';
import 'package:hamishphipps/app/core/services/local_data.dart';
import 'package:image_picker/image_picker.dart';

class AccountController extends GetxController {
  final networkConfig = NetworkConfigV1.instance;
  final localService = LocalService.localService;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailTEC = TextEditingController();
  final RxString email = "".obs;

  final location = "".obs;
  final ImagePicker _imagePicker = ImagePicker();
  //Rx is used to handel non null values
  final RxBool isUpdateLoading = false.obs;
  //Rxn is used to handle null values
  //profileImage use for selected image in ui screen
  final Rxn<File> profileImage = Rxn<File>();
  //profileImageUrl use for prefilled image in ui screen
  final RxString profileImageUrl = "".obs;

  @override
  void onInit() {
    super.onInit();
    getUserProfile();
  }

  final Rx<UserProfileModel> userProfile = UserProfileModel().obs;
  void loadAccountData() {
    fullNameController.text = userProfile.value.fullName ?? "";
    userNameController.text = userProfile.value.userName ?? "";
    profileImageUrl.value = userProfile.value.profileImage ?? "";
    email.value = userProfile.value.email ?? "";
    emailTEC.text = email.value;
    if (userProfile.value.homeCountry != null &&
        userProfile.value.passportCountry != null) {
      location.value =
          "${userProfile.value.homeCountry} / ${userProfile.value.passportCountry}";
    } else if (userProfile.value.homeCountry != null) {
      location.value = userProfile.value.homeCountry!;
    } else if (userProfile.value.passportCountry != null) {
      location.value = userProfile.value.passportCountry!;
    } else {
      location.value = "Not set";
    }
  }

  // get user profile
  final RxBool isUserProfileLoading = false.obs;
  Future<void> getUserProfile() async {
    try {
      isUserProfileLoading.value = true;
      final response = await networkConfig.ApiRequestHandler(
        RequestMethod.GET,
        Urls.userProfile,
        {},
        is_auth: true,
      );
      if (response != null && response["success"] == true) {
        userProfile.value = UserProfileModel.fromJson(response["data"]);
        loadAccountData();
        log("get user profile success: ${response["message"]}");
        isUpdateLoading.value = false;
      } else {
        log(
          "get user profile failed: ${response?["message"] ?? "Unknown error"}",
        );
      }
    } catch (e) {
      log("get user profile error: $e");
    } finally {
      isUserProfileLoading.value = false;
    }
  }

  Future<void> pickProfileImage() async {
    try {
      final pickedFile = await CommonFilePicker.pick(
        isFile: false,
        useCamera: false,
      );

      if (pickedFile != null) {
        profileImage.value = pickedFile;
      }
    } catch (e) {
      rethrow;
    }
  }

  //multipart request with multiple image
  //image picker use for image selection from gallery or camera

  //image selection method for multiple image selection from gallery or camera
  //target using for image file and fromCamera using for camera or gallery
  Future<void> pickImage({
    required Rxn<File> target,
    required bool fromCamera,
  }) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        target.value = File(pickedFile.path);
        log("Picked file: ${pickedFile.path}");
      } else {
        log("No file selected");
      }
    } catch (e) {
      log("Error picking image: $e");
    }
  }

  //update profile method use for update profile
  Future<bool> updateProfile() async {
    try {
      isUpdateLoading.value = true;
      //MultipartRequest use for multipart request this method required Method and Urls
      final request = http.MultipartRequest(
        "PUT",
        Uri.parse("${Urls.baseUrl}/users/profile"),
      );
      String? token = localService.getToken();
      if (token != null) {
        request.headers.addAll({
          'Content-Type': 'multipart/form-data',
          'Authorization': token,
        });
      } else {
        AppToast.showError("Please login again");
      }
      // Create the JSON data for the data field
      Map<String, dynamic> updateData = {
        "fullName": fullNameController.text.trim(),
        "userName": userNameController.text.trim(),
      };
      // Add the data field as JSON string to the request
      request.fields["data"] = jsonEncode(updateData);
      //addFile method use for add image to request on Multiple request
      Future<void> addFile({
        required String fieldName,
        required Rxn<File> file,
      }) async {
        if (file.value != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              fieldName,
              file.value!.path,
              filename: file.value!.path.split("/").last,
            ),
          );
          log("Added file for $fieldName: ${file.value!.path}");
        }
      }

      //await addFile method use for add image to request on Multiple request
      await addFile(fieldName: "image", file: profileImage);

      log("Updating profile with data: ${jsonEncode(updateData)}");

      //send request to server and get response from server and return response to controller
      final streamedRequest = await request.send();
      //response use for get response from server and return response to controller
      final response = await http.Response.fromStream(streamedRequest);
      final decodeResponse = jsonDecode(response.body);
      log("Profile update response: $decodeResponse");
      log("Status code: ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        AppToast.showSuccess("Profile updated successfully!");
        isUpdateLoading.value = false;
        return true;
      } else {
        AppToast.showError(decodeResponse["message"]);
        isUpdateLoading.value = false;
        return false;
      }
    } catch (e) {
      log("Profile update error: $e");
      return false;
    } finally {
      isUpdateLoading.value = false;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    userNameController.dispose();
    emailTEC.dispose();
    super.onClose();
  }
}
