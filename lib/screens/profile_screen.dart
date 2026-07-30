import 'package:flutter/material.dart';
import 'profile_settings_screen.dart';
import 'creator_channel_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Map<String, dynamic> _userData = {
    "username": "@MantuPatra",
    "name": "Mantu Patra",
    "bio": "AI Automation & Backend Developer ⚡",
    "followers": "12.4k",
    "following": "240",
    "likes": "145k",
    "tips_earned": "\$1,280",
    "avatar": "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(_userData["username"], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileSettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.amber,
              child: CircleAvatar(
                radius: 42,
                backgroundImage: NetworkImage(_userData["avatar"]),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _userData["name"],
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              _userData["bio"],
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
            const SizedBox(height: 20),

            // Open YouTube-Style Creator Channel Box
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreatorChannelScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.amber, Colors.deepOrange],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.video_library_rounded, color: Colors.black, size: 36),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('My Creator Channel 📺', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 2),
                          Text('Manage Banners, Playlists, Analytics & Subscriptions', style: TextStyle(color: Colors.black87, fontSize: 11)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('Followers', _userData["followers"]),
                _buildStatItem('Following', _userData["following"]),
                _buildStatItem('Likes', _userData["likes"]),
                _buildStatItem('Tips', _userData["tips_earned"]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11)),
      ],
    );
  }
}
