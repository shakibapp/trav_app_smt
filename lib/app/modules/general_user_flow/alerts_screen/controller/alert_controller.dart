// controllers/alert_controller.dart
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/data/network/endpoints.dart';
import 'package:hamishphipps/app/core/data/network/netconfig.dart';
import 'package:hamishphipps/app/core/services/local_data.dart';
import 'package:hamishphipps/app/modules/general_user_flow/alerts_screen/model/alerts_model.dart';

class AlertController extends GetxController {
  final NetworkConfigV1 _networkConfig = NetworkConfigV1.instance;
  final localStorage = LocalService.localService;

  final RxList<NotificationModel> alerts = <NotificationModel>[].obs;
  final RxBool isNotificationLoading = false.obs;
  final RxBool isPaginationLoading = false.obs;
  final RxBool isNotificationReadLoading = false.obs;
  final RxBool hasMore = true.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalAlerts = 0.obs;
  final RxInt limit = 15.obs;

  late final ScrollController scrollController;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
    getNotification(reset: true);
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (!scrollController.hasClients ||
        isNotificationLoading.value ||
        isPaginationLoading.value ||
        !hasMore.value) {
      return;
    }

    const threshold = 120.0;
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - threshold) {
      getNotification();
    }
  }

  Future<void> getNotification({bool reset = false}) async {
    try {
      if (reset) {
        isNotificationLoading.value = true;
        currentPage.value = 1;
        hasMore.value = true;
      } else {
        isPaginationLoading.value = true;
      }

      final page = reset ? 1 : currentPage.value;
      final uri = '${Urls.getNotificatios}?page=$page&limit=${limit.value}';

      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.GET,
        uri,
        {},
        is_auth: true,
      );

      if (response != null &&
          response['success'] == true &&
          response['data'] != null) {
        final data = response['data'];
        final fetched = List<NotificationModel>.from(
          (data['data'] as List<dynamic>).map(
            (x) => NotificationModel.fromJson(x as Map<String, dynamic>),
          ),
        );

        if (reset) {
          alerts.value = fetched;
        } else {
          alerts.addAll(fetched);
        }

        totalAlerts.value = data['total'] ?? alerts.length;
        final responsePage = data['page'] ?? page;
        final responseLimit = data['limit'] ?? limit.value;
        limit.value = responseLimit;

        hasMore.value = alerts.length < totalAlerts.value;
        if (hasMore.value) {
          currentPage.value = responsePage + 1;
        }

        log('get notification response: ${response['message']}');
      } else {
        log(
          'get notification failed: ${response?['message'] ?? 'no response'}',
        );
      }
    } catch (e) {
      log('Error occurred while fetching notifications: $e');
    } finally {
      isNotificationLoading.value = false;
      isPaginationLoading.value = false;
    }
  }

  Future<void> readNotification() async {
    try {
      isNotificationReadLoading.value = true;

      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.PATCH,
        Urls.readNotification,
        jsonEncode({'read': true}),
        is_auth: true,
      );

      if (response != null && response['success'] == true) {
        for (var i = 0; i < alerts.length; i++) {
          alerts[i] = alerts[i].copyWith(read: true);
        }
        log('read notification response: ${response['message']}');
      } else {
        log(
          'read notification response: ${response?['message'] ?? 'no response'}',
        );
      }
    } catch (e) {
      log('Error occurred while marking notifications read: $e');
    } finally {
      isNotificationReadLoading.value = false;
    }
  }

  void markNotificationAsRead(int index) {
    if (index < 0 || index >= alerts.length) return;
    final notification = alerts[index];
    if (notification.read == true) return;
    alerts[index] = notification.copyWith(read: true);
    readNotification();
  }
}
