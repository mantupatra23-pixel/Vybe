import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class UpdateService {
  static const String currentAppVersion = "1.0.1";
  static const int currentBuildNumber = 1;
  static const String updateApiUrl = "https://vybe-backend-fbsl.onrender.com/api/v1/app/latest-version";

  static Future<void> checkForUpdates(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      final response = await http.get(Uri.parse(updateApiUrl)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final String latestVersion = data["latest_version"] ?? "1.0.1";
        final int latestBuild = data["build_number"] ?? 1;
        final String releaseNotes = data["release_notes"] ?? "New UI layout, camera tools, and performance bug fixes!";
        final String downloadUrl = data["download_url"] ?? "https://github.com/mantu-patra/Vybe/releases";

        if (latestBuild > currentBuildNumber || latestVersion != currentAppVersion) {
          if (context.mounted) {
            _showUpdateDialog(context, latestVersion, releaseNotes, downloadUrl);
          }
        }
      }
    } catch (e) {
      print("Update Check Error: $e");
    }
  }

  static void _showUpdateDialog(
    BuildContext context,
    String version,
    String notes,
    String downloadUrl,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF181818),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            children: [
              const Icon(Icons.system_update_rounded, color: Colors.amber, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Update Available ($version) ⚡',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'A new version of Vybe is ready! What\'s new:',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white12),
                ),
                child: Text(
                  notes,
                  style: const TextStyle(color: Colors.amber, fontSize: 12, height: 1.3),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Later', style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                final Uri url = Uri.parse(downloadUrl);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              child: const Text('Update Now', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}
