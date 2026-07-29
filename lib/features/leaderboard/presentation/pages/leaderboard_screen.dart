import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vybe/core/constants/app_constants.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<dynamic> _ranks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLeaderboard();
  }

  Future<void> _fetchLeaderboard() async {
    try {
      final res = await Dio().get(AppConstants.leaderboardUrl);
      if (res.data["success"] == true) {
        setState(() {
          _ranks = res.data["leaderboard"];
          _isLoading = false;
        });
      }
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121218),
      appBar: AppBar(title: const Text("🏆 Leaderboard"), backgroundColor: Colors.transparent),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amberAccent))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _ranks.length,
              itemBuilder: (context, index) {
                final user = _ranks[index];
                return ListTile(
                  leading: CircleAvatar(child: Text("${index + 1}")),
                  title: Text(user["user_name"], style: const TextStyle(color: Colors.white)),
                  trailing: Text("${user['xp']} XP ⚡", style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold)),
                );
              },
            ),
    );
  }
}
