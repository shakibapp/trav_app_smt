class Urls {
  static const String baseUrl = 'https://hamishhipps.vercel.app/api/v1';

  //----------------------------Auth Endpoints------------------//
  static const String login = '$baseUrl/auth/login'; //POST
  static const String register = '$baseUrl/users'; //POST
  static const String forgotPassword = '$baseUrl/auth/forgot-password'; //POST
  static const String verifyOtp = '$baseUrl/auth/verify-otp'; //POST
  static const String resetPassword = '$baseUrl/auth/reset-password'; //POST
  static const String resendOtp = '$baseUrl/auth/resend-otp'; //POST
  static const String changePassword = '$baseUrl/auth/change-password'; //PUT
  static const String logout = '$baseUrl/auth/logout'; //POST
  static const String userProfile = '$baseUrl/auth/profile'; //GET
  static const String deleteAccount = '$baseUrl/users/delete/';

  ///DELETE
  static const String getNotificatios = '$baseUrl/notifications/all-noti'; //GET
  static const String readNotification =
      '$baseUrl/notifications/read-noti'; //PATCH
  static const String trips = '$baseUrl/trips'; //GET
  static const String createTripByAI = '$baseUrl/ai/generate-trip'; //POST
  static const String createTrip = '$baseUrl/trips'; //POST
  static const String tripDetail = '$baseUrl/trips'; //GET
}
