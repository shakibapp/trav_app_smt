import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/core/constants/app_icons.dart';
import 'package:hamishphipps/app/modules/general_user_flow/create_plan/widget/back_button_widget.dart';
import '../controller/create_plan_country_controller.dart';
import '../model/create_plan_country_model.dart';

class RegionSelectionView extends GetView<RegionController> {
  const RegionSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              backButton(),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              Obx(
                () => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Help section
                          _buildHelpCard(context),
                          const SizedBox(height: 24),

                          // "Where to next?" heading
                          const Text(
                            'Where to next?',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Search bar
                          _buildSearchBar(),
                          const SizedBox(height: 12),

                          // Tip message
                          _buildTipMessage(),
                          const SizedBox(height: 24),

                          // Browse by Region section
                          _buildCategorySection(
                            title: 'Browse by Region',
                            regions: controller.getRegionsByType('region'),
                          ),
                          const SizedBox(height: 24),

                          // Popular Cities section
                          _buildCategorySection(
                            title: 'Popular Cities',
                            regions: controller.popularCities,
                          ),
                          const SizedBox(height: 24),

                          // // Selected region display
                          // _buildSelectedRegionDisplay(),
                          // const SizedBox(height: 24),

                          // Next button
                          _buildNextButton(),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Help Card Widget
  Widget _buildHelpCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFfef9f5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xFFfcdcc9)),
              color: Color(0xFFfdf3ec),
            ),
            child: Image.asset(AppIcons.robot, height: 50, width: 50),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "I don't know, help me!",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Answer a few questions and I\'ll recommend the perfect route.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, size: 25),
        ],
      ),
    );
  }

  // Search Bar Widget
  Widget _buildSearchBar() {
    return TextField(
      onChanged: controller.searchRegions,
      decoration: InputDecoration(
        hintText: 'Search by region...',
        hintStyle: TextStyle(color: Colors.grey),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(AppIcons.maps, height: 20, width: 20),
        ),
        suffixIcon: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.authOrange,
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Icon(Icons.search, color: Colors.white),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  // Tip Message Widget
  Widget _buildTipMessage() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFffe7d8), Color(0xFFFFFFFF), Color(0xFFf3f5c3)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),

        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Tip: Enter a country like "Australia" and I\'ll help you plan stops within it!',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      ),
    );
  }

  // Category Section Widget
  Widget _buildCategorySection({
    required String title,
    required List<Region> regions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: regions
              .map((region) => _buildRegionButton(region))
              .toList(),
        ),
      ],
    );
  }

  // Region Button Widget
  Widget _buildRegionButton(Region region) {
    return Obx(
      () => ElevatedButton(
        onPressed: () => controller.selectRegion(region),
        style: ElevatedButton.styleFrom(
          backgroundColor: controller.selectedRegion.value?.id == region.id
              ? AppColors.authOrange
              : Colors.grey.shade100,
          foregroundColor: controller.selectedRegion.value?.id == region.id
              ? Colors.white
              : Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        child: Text(region.name),
      ),
    );
  }

  // Selected Region Display
  Widget _buildSelectedRegionDisplay() {
    return Obx(
      () => controller.selectedRegion.value != null
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selected:',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          controller.selectedRegion.value!.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: controller.clearSelection,
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  // Next Button Widget
  Widget _buildNextButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: controller.selectedRegion.value != null
              ? controller.proceedNext
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.authOrange,
            disabledBackgroundColor: Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Next',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
