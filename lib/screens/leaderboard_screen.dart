import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  bool _isLoading = true;
  List<dynamic> _ranks = [];

  @override
  void initState() {
    super.initState();
    _fetchLeaderboard();
  }

  Future<void> _fetchLeaderboard() async {
    try {
      final res = await http.get(Uri.parse('https://vybe-backend.onrender.com/api/v1/leaderboard'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        setState(() {
          _ranks = data['leaderboard'] ?? [];
        });
      }
    } catch (e) {
      print('Leaderboard Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Creator Leaderboard 🏆', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : _ranks.isEmpty
              ? const Center(child: Text('No leaderboard data yet!', style: TextStyle(color: Colors.white54)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _ranks.length,
                  itemBuilder: (context, index) {
                    final item = _ranks[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141414),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: index == 0 ? Colors.amber : Colors.white12),
                      ),
                      child: Row(
                        children: [
                          Text('#${index + 1}', style: TextStyle(color: index == 0 ? Colors.amber : Colors.white70, fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(item['user_name'] ?? '@Creator', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                          Text('${item['xp'] ?? 0} XP', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
