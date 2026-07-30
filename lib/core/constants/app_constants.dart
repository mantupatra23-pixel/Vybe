class AppConstants {
  static const String baseUrl = "https://vybe-backend-fbsi.onrender.com";
  static const String wsUrl = "wss://vybe-backend-fbsi.onrender.com/ws/notifications";

  // Core Feed & Upload Endpoints
  static const String feedUrl = "$baseUrl/api/v1/videos/feed";
  static const String uploadUrl = "$baseUrl/api/v1/videos/generate-upload-url";
  static const String versionCheckUrl = "$baseUrl/api/v1/app/latest-version";
  static const String audioLibraryUrl = "$baseUrl/api/v1/audio/library";
  static const String leaderboardUrl = "$baseUrl/api/v1/leaderboard";
  static const String updateScoreUrl = "$baseUrl/api/v1/user/score";

  // Creator Monetization & Wallet Endpoints
  static const String walletUpdateUrl = "$baseUrl/api/v1/creator/wallet/update";
  static const String tipCreatorUrl = "$baseUrl/api/v1/creator/tip";

  // TikTok Recommendation Engine Endpoints
  static const String smartFeedUrl = "$baseUrl/api/v1/recommendation/smart-feed";
  static const String trackEngagementUrl = "$baseUrl/api/v1/recommendation/track-engagement";

  // Smart AI Features Endpoints
  static const String generateScriptUrl = "$baseUrl/api/v1/smart/generate-script";
  static const String autoSubtitlesUrl = "$baseUrl/api/v1/smart/auto-subtitles";
  static const String votePollUrl = "$baseUrl/api/v1/smart/poll/vote";

  // Dynamic Helper Methods
  static String getCreatorWalletUrl(String name) => "$baseUrl/api/v1/creator/wallet/$name";
  static String getQuizzesUrl(int videoId) => "$baseUrl/api/v1/quizzes/$videoId";
  static String getLikeUrl(int videoId) => "$baseUrl/api/v1/videos/$videoId/like";
  static String getViewUrl(int videoId) => "$baseUrl/api/v1/videos/$videoId/view";
  static String getCommentsUrl(int videoId) => "$baseUrl/api/v1/videos/$videoId/comments";
  static const String addCommentUrl = "$baseUrl/api/v1/videos/comments/add";
  static String getCreatorProfileUrl(String name) => "$baseUrl/api/v1/creator/$name";
}
