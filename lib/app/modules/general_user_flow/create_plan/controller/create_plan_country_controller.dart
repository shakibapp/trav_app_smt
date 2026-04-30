import 'package:get/get.dart';
import '../model/create_plan_country_model.dart';
import '../view/create_plan_calender_screen.dart';

class RegionController extends GetxController {
  // Observable variables
  final selectedRegion = Rxn<Region>();
  final searchQuery = ''.obs;
  final isLoading = false.obs;

  // Lists of regions
  final allRegions = <Region>[].obs;
  final filteredRegions = <Region>[].obs;

  // Categorized data
  final regionCategories = <String, List<Region>>{}.obs;
  final popularCities = <Region>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadRegions();
  }

  // Load all regions from API or local data
  void loadRegions() {
    isLoading(true);
    try {
      // Mock data - replace with your API call
      final regions = [
        // Browse by Region
        Region(id: '1', name: 'Europe', type: 'region'),
        Region(id: '2', name: 'Asia', type: 'region'),
        Region(id: '3', name: 'South Asia', type: 'region'),
        Region(id: '4', name: 'North America', type: 'region'),
        Region(id: '5', name: 'South America', type: 'region'),
        Region(id: '6', name: 'Africa', type: 'region'),
        Region(id: '7', name: 'Middle East', type: 'region'),
        Region(id: '8', name: 'Oceania', type: 'region'),

        // Popular Cities
        Region(id: '101', name: 'Rome', type: 'city'),
        Region(id: '102', name: 'Milan', type: 'city'),
        Region(id: '103', name: 'Napoli', type: 'city'),
        Region(id: '104', name: 'Venice', type: 'city'),
        Region(id: '105', name: 'Bologna', type: 'city'),
        Region(id: '106', name: 'Turin', type: 'city'),
      ];

      allRegions.assignAll(regions);
      filteredRegions.assignAll(regions);

      // Categorize regions
      categorizeRegions(regions);

      isLoading(false);
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', 'Failed to load regions: $e');
    }
  }

  // Categorize regions for display
  void categorizeRegions(List<Region> regions) {
    final categories = <String, List<Region>>{};

    for (var region in regions) {
      if (region.type == 'region') {
        if (!categories.containsKey('Regions')) {
          categories['Regions'] = [];
        }
        categories['Regions']!.add(region);
      } else if (region.type == 'city') {
        if (!categories.containsKey('Popular Cities')) {
          categories['Popular Cities'] = [];
        }
        categories['Popular Cities']!.add(region);
      }
    }

    regionCategories.assignAll(categories);

    // Set popular cities
    if (categories.containsKey('Popular Cities')) {
      popularCities.assignAll(categories['Popular Cities']!);
    }
  }

  // Search functionality
  void searchRegions(String query) {
    searchQuery(query);

    if (query.isEmpty) {
      filteredRegions.assignAll(allRegions);
    } else {
      final filtered = allRegions
          .where(
            (region) => region.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
      filteredRegions.assignAll(filtered);
    }
  }

  // Select a region
  void selectRegion(Region region) {
    selectedRegion(region);
  }

  // Get regions by category
  List<Region> getRegionsByType(String type) {
    return allRegions.where((r) => r.type == type).toList();
  }

  // Proceed to next screen
  void proceedNext() {
    if (selectedRegion.value == null) {
      return;
    }

    // Navigate to next screen
    Get.to(() => DatePickerView());
  }

  // Clear selection
  void clearSelection() {
    selectedRegion(null);
    searchQuery('');
    filteredRegions.assignAll(allRegions);
  }
}
