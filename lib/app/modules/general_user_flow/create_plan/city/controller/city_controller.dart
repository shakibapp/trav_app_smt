

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../model/city_model.dart';

class CityController extends GetxController {
  final isLoading = false.obs;

  final selectedRegion = Rxn<LocationModel>();
  final selectedCities = <LocationModel>[].obs;

  final searchQuery = ''.obs;
  final searchResults = <LocationModel>[].obs;

  final allLocations = <LocationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    debounce(searchQuery, (_) => _search(),
        time: const Duration(milliseconds: 300));
    loadData();
  }

  // ---------------- LOAD DATA ----------------
  Future<void> loadData() async {
    isLoading(true);

    final data = await rootBundle.loadString('assets/jsons/locations.json');
    final List decoded = jsonDecode(data);

    allLocations.assignAll(
      decoded.map((e) => LocationModel.fromJson(e)).toList(),
    );

    isLoading(false);
  }

  // ---------------- REGION LIST ----------------
  List<LocationModel> getRegionsByType(String type) {
    return allLocations.where((e) => e.type == type).toList();
  }

  List<LocationModel> get popularCities =>
      allLocations.where((e) => e.type == 'city' && e.isPopular).toList();

  // ---------------- REGION SELECT ----------------
  void selectRegion(LocationModel region) {
    selectedRegion.value = region;
    selectedCities.clear();
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

  bool isSelected(LocationModel city) =>
      selectedCities.any((e) => e.id == city.id);

  bool get canProceed => selectedCities.isNotEmpty;

  // ---------------- SEARCH ----------------
  void searchRegions(String value) {
    searchQuery.value = value;

    if (value.isEmpty) {
      searchResults.clear();
      return;
    }

    searchResults.assignAll(
      allLocations.where((e) {
        return e.type == 'city' &&
            e.name.toLowerCase().contains(value.toLowerCase());
      }).toList(),
    );
  }

  // private method used by debounce
  void _search() {
    searchRegions(searchQuery.value);
  }

  // ---------------- NEXT ----------------
  void proceedNext() {
    final payload = {
      "region": selectedRegion.value != null
          ? [selectedRegion.value!.name]
          : [],
      "city": selectedCities.map((e) => e.name).toList(),
    };

    print(payload);
  }

  // ---------------- CLEAR ----------------
  void clearSelection() {
    selectedRegion.value = null;
    selectedCities.clear();
    searchQuery.value = '';
    searchResults.clear();
  }

  // ---------------- REFRESH ----------------
  Future<void> refreshData() async {
    await loadData();
  }
}