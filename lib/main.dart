import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vybe/core/constants/app_constants.dart';
import 'package:vybe/features/feed/presentation/pages/feed_screen.dart';
import 'package:vybe/features/upload/presentation/pages/upload_screen.dart';
import 'package:vybe/features/leaderboard/presentation/pages/leaderboard_screen.dart';
import 'package:vybe/features/profile/presentation/pages/profile_screen.dart';

void main() {
  runApp(const VybeApp());
}

class VybeApp extends StatelessWidget {
  const VybeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vybe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121218),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const FeedScreen(),
    const UploadScreen(),
    const LeaderboardScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkForUpdates();
  }

  Future<void> _checkForUpdates() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      final res = await Dio().get(AppConstants.versionCheckUrl);
      if (res.data["success"] == true) {
        String latestVersion = res.data["latest_version"];
        String downloadUrl = res.data["download_url"];
        String releaseNotes = res.data["release_notes"] ?? "New performance updates available!";

        if (latestVersion != currentVersion && mounted) {
          _showUpdateDialog(latestVersion, releaseNotes, downloadUrl);
        }
      }
    } catch (_) {}
  }

  void _showUpdateDialog(String version, String notes, String downloadUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E2C),
          title: Text("🚀 New Update (v$version)", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Text(notes, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Later", style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
              onPressed: () async {
                final Uri url = Uri.parse(downloadUrl);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              child: const Text("Download Update", style: TextStyle(color: Colors.white)),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF121218),
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.play_arrow_rounded), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Upload'),
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard_rounded), label: 'Ranks'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
