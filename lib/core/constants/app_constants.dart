class AppConstants {
  static const String baseUrl = "https://vybe-backend-fbsi.onrender.com";
  static const String wsUrl = "wss://vybe-backend-fbsi.onrender.com/ws/notifications";

  // API Endpoints
  static const String feedUrl = "$baseUrl/api/v1/videos/feed";
  static const String uploadUrl = "$baseUrl/api/v1/videos/generate-upload-url";
  static const String audioLibraryUrl = "$baseUrl/api/v1/audio/library";
  static const String leaderboardUrl = "$baseUrl/api/v1/leaderboard";
  static const String updateScoreUrl = "$baseUrl/api/v1/user/score";
  static const String versionCheckUrl = "$baseUrl/api/v1/app/latest-version";

  static String getQuizzesUrl(int videoId) => "$baseUrl/api/v1/quizzes/$videoId";
  static String getLikeUrl(int videoId) => "$baseUrl/api/v1/videos/$videoId/like";
  static String getViewUrl(int videoId) => "$baseUrl/api/v1/videos/$videoId/view";
  static String getCommentsUrl(int videoId) => "$baseUrl/api/v1/videos/$videoId/comments";
  static const String addCommentUrl = "$baseUrl/api/v1/videos/comments/add";
  static String getCreatorProfileUrl(String name) => "$baseUrl/api/v1/creator/$name";
}
