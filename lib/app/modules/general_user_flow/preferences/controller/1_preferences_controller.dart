import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../data/countries.dart';

class PreferencesController extends GetxController {
  // Step 1
  final selectedFeature = ''.obs;

  // Step 2
  final selectedAgeRange = ''.obs;

  // Step 3
  final homeCountry = ''.obs;
  final passportIssuingCountry = ''.obs;

  // Step 4
  final selectedInterests = <String>[].obs;

  // Options
  final ageRanges = const ['Under 18', '18-24', '25-34', '35-44', 'Over 45'];

  final List<String> countries = kCountries;

  final interests = const [
    'Food & Drink',
    'Nature',
    'Nightlife',
    'Adventure',
    'Shopping',
    'Relaxation',
    'Photography',
    'History & Culture',
    'Art & Music',
  ];

  bool get canContinueStep1 => selectedFeature.value.trim().isNotEmpty;

  bool get canContinueStep2 => selectedAgeRange.value.trim().isNotEmpty;

  bool get canContinueStep3 =>
      homeCountry.value.trim().isNotEmpty &&
      passportIssuingCountry.value.trim().isNotEmpty;

  bool get canContinueStep4 => selectedInterests.isNotEmpty;

  void setFeature(String v) => selectedFeature.value = v;

  void setAgeRange(String v) => selectedAgeRange.value = v;

  void setHomeCountry(String v) => homeCountry.value = v;

  void setPassportIssuingCountry(String v) => passportIssuingCountry.value = v;

  void toggleInterest(String v) {
    if (selectedInterests.contains(v)) {
      selectedInterests.remove(v);
    } else {
      selectedInterests.add(v);
    }
  }

  void onFinish() {
    // TODO: Persist preferences to API/local if needed.
    Get.offAllNamed(AppRoutes.NAVBAR);
  }
}
