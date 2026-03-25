import 'package:get/get.dart';

class Entitlements {
  final SubscriptionType plan;

  // Limits
  final int maxCaregivers;
  final int maxChildren;

  // Feature toggles
  final bool canUseAnalytics;
  final bool canExportData;
  final bool canExportSummaryPdf;
  final bool canGenerateActivities;
  final bool canCreateCustomActivities;

  const Entitlements({
    required this.plan,
    required this.maxCaregivers,
    required this.maxChildren,
    required this.canUseAnalytics,
    required this.canExportData,
    required this.canExportSummaryPdf,
    required this.canGenerateActivities,
    required this.canCreateCustomActivities,
  });

  bool get isPremium => plan == SubscriptionType.premium;

  /// Helper: Free defaults
  factory Entitlements.free() => const Entitlements(
    plan: SubscriptionType.free,
    maxCaregivers: 1,
    maxChildren: 1,
    canUseAnalytics: false,
    canExportData: false,
    canExportSummaryPdf: false,
    canGenerateActivities: false,
    canCreateCustomActivities: false,
  );

  /// Helper: Premium defaults (adjust if needed)
  factory Entitlements.premium() => const Entitlements(
    plan: SubscriptionType.premium,
    maxCaregivers: 4,
    maxChildren: 4,
    canUseAnalytics: true,
    canExportData: true,
    canExportSummaryPdf: true,
    canGenerateActivities: true,
    canCreateCustomActivities: true,
  );
}

class SubscriptionStatus {
  final SubscriptionType plan;
  final bool isActive;
  final DateTime? expiryDate; // optional
  final String? activeProductId;

  const SubscriptionStatus({
    required this.plan,
    required this.isActive,
    this.expiryDate,
    this.activeProductId,
  });

  factory SubscriptionStatus.free() => const SubscriptionStatus(
    plan: SubscriptionType.free,
    isActive: false,
    expiryDate: null,
    activeProductId: null,
  );
}

class SubscriptionService extends GetxController {
  /// Use `SubscriptionService.to` after registering the service with Get
  static SubscriptionService get to => Get.find<SubscriptionService>();

  final Rx<SubscriptionStatus> _status = SubscriptionStatus.free().obs;
  final RxString _region = ''.obs;

  SubscriptionStatus get status => _status.value;
  SubscriptionType get plan => status.plan;
  bool get isActive => status.isActive;
  String get region => _region.value;

  /// Effective entitlements - takes region overrides into account
  Entitlements get entitlements {
    if (_isRegionFreeForPremium(region)) return Entitlements.premium();
    return plan == SubscriptionType.premium
        ? Entitlements.premium()
        : Entitlements.free();
  }

  SubscriptionType get effectivePlan =>
      _isRegionFreeForPremium(region) ? SubscriptionType.premium : plan;

  /// Set the user-visible region (e.g., country). Some regions may grant premium access.
  void setRegion(String newRegion) {
    _region.value = newRegion;
    update();
  }

  /// Update the subscription plan/status locally (no API calls).
  void setPlan(
    SubscriptionType newPlan, {
    bool active = true,
    DateTime? expiryDate,
    String? productId,
  }) {
    _status.value = SubscriptionStatus(
      plan: newPlan,
      isActive: active,
      expiryDate: expiryDate,
      activeProductId: productId,
    );
    update();
  }

  void activatePremium({String? productId, DateTime? expiryDate}) => setPlan(
    SubscriptionType.premium,
    active: true,
    expiryDate: expiryDate,
    productId: productId,
  );
  void deactivateToFree() => setPlan(SubscriptionType.free, active: false);

  /// Whether the current context has premium access (considers region overrides).
  bool get hasPremiumAccess => entitlements.isPremium;

  bool _isRegionFreeForPremium(String region) {
    final r = region.trim().toLowerCase();
    return r == 'barbados';
  }
}

enum SubscriptionType { free, premium }
