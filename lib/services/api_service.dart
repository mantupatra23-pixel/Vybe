import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://vybe-backend-fbsi.onrender.com";

  static Future<List<Map<String, dynamic>>> fetchSmartFeed() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/v1/recommendation/smart-feed'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["success"] == true && data["videos"] != null && (data["videos"] as List).isNotEmpty) {
          return List<Map<String, dynamic>>.from(data["videos"].map((v) => {
            "id": v["id"],
            "creator": v["creator_name"] ?? "@Vybe Creator",
            "title": v["title"] ?? "",
            "video_url": v["cdn_url"] ?? v["video_url"],
            "likes": v["likes"] ?? 0,
            "comments": 12,
          }));
        }
      }
    } catch (e) {
      print("API Fetch Error: $e");
    }

    return [
      {
        "id": 1,
        "creator": "@Vybe Creator",
        "title": "Autonomous AI Video Generator Pipeline ⚡",
        "video_url": "https://assets.mixkit.co/videos/preview/mixkit-tree-with-yellow-leaves-low-angle-shot-40033-large.mp4",
        "likes": 248,
        "comments": 34
      }
    ];
  }

  static Future<int?> likeVideo(int videoId) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/api/v1/videos/$videoId/like'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data["likes"];
      }
    } catch (e) {
      print("Like Error: $e");
    }
    return null;
  }

  static Future<bool> addComment(int videoId, String comment) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/videos/comments/add'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "video_id": videoId,
          "user_name": "@MantuPatra",
          "comment_text": comment
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
