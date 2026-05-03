// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hamishphipps/app/core/constants/app_colors.dart';
// import 'package:hamishphipps/app/core/constants/app_icons.dart';
//
// import '../../model/create_plan_country_model.dart';
// import '../controller/city_controller.dart';
//
//
// class RegionSelectionView extends StatelessWidget {
//    RegionSelectionView({super.key});
//    final controller = Get.put(CityController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bgColor,
//       body: SafeArea(
//         child: Obx(() {
//           if (controller.isLoading.value) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           return RefreshIndicator(
//             onRefresh: controller.refreshData,
//             child: SingleChildScrollView(
//               physics: const AlwaysScrollableScrollPhysics(),
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _backButton(),
//                   const SizedBox(height: 16),
//                   const Divider(),
//                   const SizedBox(height: 16),
//
//                   _buildHelpCard(),
//                   const SizedBox(height: 24),
//
//                   const Text(
//                     'Where to next?',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//
//                   const SizedBox(height: 12),
//
//                   _searchBar(),
//
//                   const SizedBox(height: 12),
//
//                   _tipMessage(),
//
//                   const SizedBox(height: 24),
//
//                   // ---------------- REGIONS ----------------
//                   _sectionTitle("Browse by Region"),
//                   const SizedBox(height: 12),
//                   _regionSection(),
//
//                   const SizedBox(height: 24),
//
//                   // ---------------- POPULAR CITIES ----------------
//                   _sectionTitle("Popular Cities"),
//                   const SizedBox(height: 12),
//                   _citySection(controller.popularCities),
//
//                   const SizedBox(height: 24),
//
//                   // ---------------- SEARCH RESULTS ----------------
//                   if (controller.searchQuery.value.isNotEmpty)
//                     _citySection(controller.searchResults),
//
//                   const SizedBox(height: 24),
//
//                   // ---------------- SELECTED ----------------
//                   _selectedCities(),
//
//                   const SizedBox(height: 30),
//
//                   _nextButton(),
//                 ],
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
//
//   // ---------------- HELP CARD ----------------
//   Widget _buildHelpCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFfef9f5),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.orange.shade200),
//       ),
//       child: Row(
//         children: [
//           Image.asset(AppIcons.robot, height: 50, width: 50),
//           const SizedBox(width: 12),
//           const Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "I don't know, help me!",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   "I'll suggest perfect travel routes for you.",
//                   style: TextStyle(fontSize: 12),
//                 ),
//               ],
//             ),
//           ),
//           const Icon(Icons.chevron_right),
//         ],
//       ),
//     );
//   }
//
//   // ---------------- SEARCH ----------------
//   Widget _searchBar() {
//     return TextField(
//       onChanged: controller.searchRegions,
//       decoration: InputDecoration(
//         hintText: "Search city...",
//         prefixIcon: const Icon(Icons.search),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//     );
//   }
//
//   // ---------------- TIP ----------------
//   Widget _tipMessage() {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFFffe7d8), Colors.white, Color(0xFFf3f5c3)],
//         ),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: const Text(
//         'Tip: Select a region first, then choose cities for your trip!',
//         style: TextStyle(fontSize: 13),
//       ),
//     );
//   }
//
//   // ---------------- REGION SECTION ----------------
//   Widget _regionSection() {
//     return Wrap(
//       spacing: 10,
//       runSpacing: 10,
//       children: controller.getRegionsByType('region').map((region) {
//         final selected =
//             controller.selectedRegion.value?.id == region.id;
//
//         return ElevatedButton(
//           onPressed: () => controller.selectRegion(region),
//           style: ElevatedButton.styleFrom(
//             backgroundColor:
//             selected ? AppColors.authOrange : Colors.grey.shade200,
//             foregroundColor: selected ? Colors.white : Colors.black,
//           ),
//           child: Text(region.name),
//         );
//       }).toList(),
//     );
//   }
//
//   // ---------------- CITY SECTION ----------------
//   Widget _citySection(List<Region> cities) {
//     return Wrap(
//       spacing: 10,
//       runSpacing: 10,
//       children: cities.map((city) {
//         final selected = controller.isSelected(city);
//
//         return FilterChip(
//           label: Text(city.name),
//           selected: selected,
//           onSelected: (_) => controller.toggleCity(city),
//         );
//       }).toList(),
//     );
//   }
//
//   // ---------------- SELECTED ----------------
//   Widget _selectedCities() {
//     return Obx(() {
//       if (controller.selectedCities.isEmpty) {
//         return const SizedBox();
//       }
//
//       return Wrap(
//         spacing: 8,
//         children: controller.selectedCities
//             .map((e) => Chip(label: Text(e.name)))
//             .toList(),
//       );
//     });
//   }
//
//   // ---------------- NEXT ----------------
//   Widget _nextButton() {
//     return Obx(() {
//       return SizedBox(
//         width: double.infinity,
//         height: 52,
//         child: ElevatedButton(
//           onPressed: controller.canProceed
//               ? controller.proceedNext
//               : null,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppColors.authOrange,
//             disabledBackgroundColor: Colors.grey,
//           ),
//           child: const Text(
//             "Next",
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//       );
//     });
//   }
//
//   // ---------------- BACK ----------------
//   Widget _backButton() {
//     return Row(
//       children: [
//         IconButton(
//           onPressed: () => Get.back(),
//           icon: const Icon(Icons.arrow_back),
//         ),
//       ],
//     );
//   }
//
//   // ---------------- TITLE ----------------
//   Widget _sectionTitle(String title) {
//     return Text(
//       title,
//       style: const TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/core/constants/app_icons.dart';

import '../model/city_model.dart';
import '../controller/city_controller.dart';

class RegionSelectionView extends StatelessWidget {
  RegionSelectionView({super.key});
  final controller = Get.put(CityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: controller.refreshData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _backButton(),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  _buildHelpCard(),
                  const SizedBox(height: 24),

                  const Text(
                    'Where to next?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _searchBar(),

                  const SizedBox(height: 12),

                  _tipMessage(),

                  const SizedBox(height: 24),

                  // ---------------- REGIONS ----------------
                  _sectionTitle("Browse by Region"),
                  const SizedBox(height: 12),
                  _regionSection(),

                  const SizedBox(height: 24),

                  // ---------------- POPULAR CITIES ----------------
                  _sectionTitle("Popular Cities"),
                  const SizedBox(height: 12),
                  _citySection(controller.popularCities),

                  const SizedBox(height: 24),

                  // ---------------- SEARCH RESULTS ----------------
                  Obx(() {
                    if (controller.searchQuery.value.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle("Search Results"),
                          const SizedBox(height: 12),
                          _citySection(controller.searchResults),
                          const SizedBox(height: 24),
                        ],
                      );
                    }
                    return const SizedBox();
                  }),

                  // ---------------- SELECTED ----------------
                  _selectedCities(),

                  const SizedBox(height: 30),

                  _nextButton(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // ---------------- HELP CARD ----------------
  Widget _buildHelpCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFfef9f5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Image.asset(AppIcons.robot, height: 50, width: 50),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "I don't know, help me!",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "I'll suggest perfect travel routes for you.",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }

  // ---------------- SEARCH ----------------
  Widget _searchBar() {
    return TextField(
      onChanged: controller.searchRegions,
      decoration: InputDecoration(
        hintText: "Search city...",
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ---------------- TIP ----------------
  Widget _tipMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFffe7d8), Colors.white, Color(0xFFf3f5c3)],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'Tip: Select a region first, then choose cities for your trip!',
        style: TextStyle(fontSize: 13),
      ),
    );
  }

  // ---------------- REGION SECTION ----------------
  Widget _regionSection() {
    return Obx(() {
      final regions = controller.getRegionsByType('region');

      if (regions.isEmpty) {
        return const Text(
          'No regions available.',
          style: TextStyle(color: Colors.grey),
        );
      }

      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: regions.map((region) {
          final selected = controller.selectedRegion.value?.id == region.id;

          return ElevatedButton(
            onPressed: () => controller.selectRegion(region),
            style: ElevatedButton.styleFrom(
              backgroundColor:
              selected ? AppColors.authOrange : Colors.grey.shade200,
              foregroundColor: selected ? Colors.white : Colors.black,
            ),
            child: Text(region.name),
          );
        }).toList(),
      );
    });
  }

  // ---------------- CITY SECTION ----------------
  Widget _citySection(List<LocationModel> cities) {
    if (cities.isEmpty) {
      return const Text(
        'No cities available.',
        style: TextStyle(color: Colors.grey),
      );
    }

    return Obx(() {
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: cities.map((city) {
          final selected = controller.isSelected(city);

          return FilterChip(
            label: Text(city.name),
            selected: selected,
            onSelected: (_) => controller.toggleCity(city),
          );
        }).toList(),
      );
    });
  }

  // ---------------- SELECTED ----------------
  Widget _selectedCities() {
    return Obx(() {
      if (controller.selectedCities.isEmpty) {
        return const SizedBox();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Selected Cities"),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.selectedCities
                .map(
                  (e) => Chip(
                label: Text(e.name),
                onDeleted: () => controller.toggleCity(e),
                deleteIcon: const Icon(Icons.close, size: 16),
              ),
            )
                .toList(),
          ),
        ],
      );
    });
  }

  // ---------------- NEXT ----------------
  Widget _nextButton() {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: controller.canProceed ? controller.proceedNext : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.authOrange,
            disabledBackgroundColor: Colors.grey,
          ),
          child: const Text(
            "Next",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    });
  }

  // ---------------- BACK ----------------
  Widget _backButton() {
    return Row(
      children: [
        IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
      ],
    );
  }

  // ---------------- TITLE ----------------
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}