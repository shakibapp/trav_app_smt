class Urls {
  static const String baseUrl =
      'https://imanidacosta-backend.vercel.app/api/v1';

  static const String websocketUrl = 'ws://206.162.244.145:5025';

  /// AUTH
  static const String register = '$baseUrl/auth/register'; // POST
  static const String verifyEmailWithOtp =
      '$baseUrl/auth/verify-email-with-otp'; // POST
  static const String login = '$baseUrl/auth/login'; // POST
  static const String forgotPassword = '$baseUrl/auth/forget-password'; // POST
  static const String resetPassword = '$baseUrl/auth/reset-password'; // POST

  static const String changePassword = '$baseUrl/auth/change-password'; // PUT

  /// CHILD
  static const String createChild = '$baseUrl/child'; // POST
  static const String getChildren = '$baseUrl/child'; // GET
  static String deleteChildren(String id) => "$baseUrl/child/$id";
  static String getChildrenDetails(String id) => "$baseUrl/child/$id";
  static String editChildrenDetails(String id) => "$baseUrl/child/$id";

  /// USER
  static const String updateProfile = '$baseUrl/user/update-profile'; // PUT
  static const String getUserInfo = '$baseUrl/user/me'; // GET

  /// CHILD DOCUMENTS
  static const String createChildDocument = '$baseUrl/child-document'; // POST
  static String getChildDocuments(String childId) =>
      '$baseUrl/child-document/all/$childId'; // GET
  static String deleteChildDocument(String documentId) =>
      '$baseUrl/child-document/$documentId'; // DELETE
  static String fileNameChange(String fileId) =>
      '$baseUrl/child-document/$fileId'; // PUT

  /// CHILD PROVIDERS
  static const String createChildProvider = '$baseUrl/child-provider'; // POST
  static String getChildProviders(String childId) =>
      '$baseUrl/child-provider/all/$childId'; // GET
  static String getChildProvidersByStatus(String childId, String status) =>
      '$baseUrl/child-provider/all/$childId?status=$status'; // GET
  static String deleteChildProvider(String providerId) =>
      '$baseUrl/child-provider/$providerId'; // DELETE

  /// CHILD HEALTHCARE
  static const String createChildHealthcare =
      '$baseUrl/child-healthcare'; // POST
  static String getChildHealthcare(String childId) =>
      '$baseUrl/child-healthcare/all/$childId'; // GET
  static String deleteChildHealthcare(String id) =>
      '$baseUrl/child-healthcare/$id'; // DELETE
  static String updateChildHealthcare(String id) =>
      '$baseUrl/child-healthcare/$id'; // PUT/PATCH

  /// CHILD SENSORY
  static const String createChildSensory = '$baseUrl/child-sensory'; // POST
  static String getChildSensory(String childId) =>
      '$baseUrl/child-sensory/all/$childId'; // GET
  static String deleteChildSensory(String id) =>
      '$baseUrl/child-sensory/$id'; // DELETE
  static String updateChildSensory(String id) =>
      '$baseUrl/child-sensory/$id'; // PUT/PATCH

  /// CHILD BEHAVIOR
  static const String sendLogBehavior = '$baseUrl/child-behavior'; // POST
  static const String saveNoteBehaviour = '$baseUrl/log-note'; // POST
  static String getBehaviourNote(String childId, String date) =>
      '$baseUrl/log-note/all/$childId?createdAt=$date'; // GET
  static String getBehaviourNote2(String childId) =>
      '$baseUrl/log-note/all/$childId'; // GET
  static String deleteBehaviourNote(String id) =>
      '$baseUrl/log-note/$id'; // DELETE

  /// CAREGIVER
  static const String createCaregiver = '$baseUrl/auth/care-giver'; // POST
  static const String getCaregivers = '$baseUrl/user/my-care-givers'; // GET
  static String deleteCaregivers(String id) =>
      '$baseUrl/user/soft-delete/$id'; // DELETE

  /// Activity
  static const String createActivity = '$baseUrl/activity-blog'; // POST
  static const String getActivity = '$baseUrl/activity-blog'; // GET
  static String getActivityDetails(String id) =>
      '$baseUrl/activity-blog/$id'; // GET
  static const generateWeeklyPlan = '$baseUrl/weekly-plan/generate-plan'; // POST
  static const activityGenerate = '$baseUrl/activity-blog/generate'; // POST

  static const generatedActivityPlan =
      '$baseUrl/weekly-plan/get-generate-plan'; // GET
  static String keepGeneratedActivity(String id) =>
      '$baseUrl/weekly-plan/toggle-keep/$id'; // POST
  static String swapGeneratedActivity(String id) =>
      '$baseUrl/weekly-plan/swap-activity/$id'; // POST
  static const regeneratedActivity =
      '$baseUrl/weekly-plan/regenerate-plan'; // POST
  static String activityMarkComplete(String id) =>
      '$baseUrl/activity-blog/$id'; // POST
  static String activityAddCalender(String id) =>
      '$baseUrl/activity-blog/$id'; // PUT
  static const generatedActivityAddCalender =
      '$baseUrl/weekly-plan/save-to-calendar'; // POST
  // Custom Activity
  static const String customActivity = '$baseUrl/activity-blog/my'; // GET
  static String customActivityDelete(String id) =>
      '$baseUrl/activity-blog/$id'; // GET

  /// Events - Monthly Calender Event
  static String monthlyCalenderEvent(String month) =>
      '$baseUrl/events/monthly-event?month=$month'; // GET
  static String dailyEvent(String day, childId) =>
      '$baseUrl/events?date=$day&childId=$childId'; // GET
  static String eventDetails(String eventId) =>
      '$baseUrl/events/$eventId'; // GET

  /// DAILY INSPIRATION
  static const String getDailyInspiration = '$baseUrl/inspiration/today'; // GET

  /// Analytics
  static String getAnalytics(String id) => '$baseUrl/analytics/$id'; // GET

  static const String getAnalyticsOverall = '$baseUrl/analytics'; // GET

  /// EVENTS
  static const String createEvent = '$baseUrl/events'; // POST
  static const String events = '$baseUrl/events'; // GET, PATCH
  static String deleteEvent(String eventId) =>
      '$baseUrl/events/$eventId'; // DELETE

  /// Learning Library
  static const String learningLibrary = '$baseUrl/article';
  static String articleDetails(String articleId) =>
      '$baseUrl/article/$articleId'; // GET
  static String favoriteToggle(String id) => '$baseUrl/favorite/$id'; // GET

  /// SUPPORT
  static const String getSupportAdmin = '$baseUrl/user/support-to-admin'; // GET
}
