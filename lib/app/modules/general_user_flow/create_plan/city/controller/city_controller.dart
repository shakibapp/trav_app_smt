import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/modules/general_user_flow/create_plan/view/create_plan_calender_screen.dart';
import '../model/city_model.dart';

class CityController extends GetxController {
  final isLoading = false.obs;

  final selectedRegions = <LocationModel>[].obs;
  final selectedCities = <LocationModel>[].obs;
  final useAiHelp = false.obs;

  final searchQuery = ''.obs;
  final searchResults = <LocationModel>[].obs;

  final allLocations = <LocationModel>[].obs;

  List<String> get selectedRegionIds =>
      selectedRegions.map((region) => region.id).toList();

  @override
  void onInit() {
    super.onInit();

    debounce(
      searchQuery,
      (_) => _search(),
      time: const Duration(milliseconds: 300),
    );

    loadData();
  }

  // ---------------- LOAD DATA ----------------
  Future<void> loadData() async {
    try {
      isLoading(true);

      final data = await rootBundle.loadString('assets/jsons/locations.json');
      final List decoded = jsonDecode(data);

      allLocations.assignAll(
        decoded.map((e) => LocationModel.fromJson(e)).toList(),
      );
    } finally {
      isLoading(false);
    }
  }

  // ---------------- REGION LIST ----------------
  List<LocationModel> getRegionsByType(String type) {
    return allLocations.where((e) => e.type == type).toList();
  }

  // ---------------- POPULAR CITIES ----------------
  List<LocationModel> get popularCities {
    final regionIds = selectedRegionIds;

    return allLocations.where((e) {
      if (e.type != 'city' || !e.isPopular) return false;

      if (regionIds.isEmpty) return true;

      return regionIds.contains(e.regionId);
    }).toList();
  }

  // ---------------- REGION SELECT ----------------
  void toggleRegion(LocationModel region) {
    final exists = selectedRegions.any((e) => e.id == region.id);

    if (exists) {
      selectedRegions.removeWhere((e) => e.id == region.id);
      selectedCities.removeWhere((city) => city.regionId == region.id);
    } else {
      selectedRegions.add(region);
    }

    if (searchQuery.value.isNotEmpty) {
      _search();
    }
  }

  bool isRegionSelected(LocationModel region) {
    return selectedRegions.any((e) => e.id == region.id);
  }

  // ---------------- CITY MULTI SELECT ----------------
  void toggleCity(LocationModel city) {
    final exists = selectedCities.any((e) => e.id == city.id);

    if (exists) {
      selectedCities.removeWhere((e) => e.id == city.id);
    } else {
      selectedCities.add(city);
    }
  }

  bool isSelected(LocationModel city) {
    return selectedCities.any((e) => e.id == city.id);
  }

  bool get canProceed => selectedCities.isNotEmpty;

  void toggleHelpMe() => useAiHelp.value = !useAiHelp.value;

  // ---------------- SEARCH ----------------
  void searchRegions(String value) {
    searchQuery.value = value;

    if (value.trim().isEmpty) {
      searchResults.clear();
      return;
    }

    final regionIds = selectedRegionIds;

    searchResults.assignAll(
      allLocations.where((e) {
        if (e.type != 'city') return false;

        final matchesName = e.name.toLowerCase().contains(value.toLowerCase());

        if (!matchesName) return false;

        if (regionIds.isEmpty) return true;

        return regionIds.contains(e.regionId);
      }).toList(),
    );
  }

  void _search() {
    searchRegions(searchQuery.value);
  }

  // ---------------- NEXT ----------------
  void proceedNext() {
    final payload = {
      "region": selectedRegions.map((e) => e.name).toList(),
      "city": selectedCities.map((e) => e.name).toList(),
    };
    Get.to(() => DatePickerView());

    debugPrint(payload.toString());
  }

  // ---------------- CLEAR ----------------
  void clearSelection() {
    selectedRegions.clear();
    selectedCities.clear();
    searchQuery.value = '';
    searchResults.clear();
  }

  // ---------------- REFRESH ----------------
  Future<void> refreshData() async {
    await loadData();

    if (searchQuery.value.isNotEmpty) {
      _search();
    }
  }
}
