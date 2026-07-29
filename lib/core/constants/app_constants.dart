class AppConstants {
  static const String baseUrl = "https://vybe-backend-fbsi.onrender.com";

  static const String feedUrl = "$baseUrl/api/v1/videos/feed";
  static const String uploadUrl = "$baseUrl/api/v1/videos/generate-upload-url";
  static const String audioLibraryUrl = "$baseUrl/api/v1/audio/library";
  static const String leaderboardUrl = "$baseUrl/api/v1/leaderboard";
  static const String versionCheckUrl = "$baseUrl/api/v1/app/latest-version";
  static const String walletUpdateUrl = "$baseUrl/api/v1/creator/wallet/update";
  static const String tipCreatorUrl = "$baseUrl/api/v1/creator/tip";

  static String getCreatorWalletUrl(String name) => "$baseUrl/api/v1/creator/wallet/$name";
  static String getQuizzesUrl(int videoId) => "$baseUrl/api/v1/quizzes/$videoId";
  static String getLikeUrl(int videoId) => "$baseUrl/api/v1/videos/$videoId/like";
  static String getViewUrl(int videoId) => "$baseUrl/api/v1/videos/$videoId/view";
  static String getCommentsUrl(int videoId) => "$baseUrl/api/v1/videos/$videoId/comments";
  static const String addCommentUrl = "$baseUrl/api/v1/videos/comments/add";
}
