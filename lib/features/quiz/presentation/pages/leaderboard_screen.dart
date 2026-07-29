import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121218),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Leaderboard 🏆", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber, width: 1),
            ),
            child: const Row(
              children: [
                Icon(Icons.bolt, color: Colors.amber, size: 18),
                SizedBox(width: 4),
                Text("240 XP", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Streak Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.deepPurple, Colors.purpleAccent]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("5 Day Learning Streak! 🔥", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text("Keep learning daily to earn badges", style: TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
                Icon(Icons.local_fire_department, color: Colors.orangeAccent, size: 40),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text("Top Learners Today", style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildLeaderItem(1, "Rahul Sharma", "1,420 XP", Colors.amber),
          _buildLeaderItem(2, "Priya Verma", "1,250 XP", Colors.grey[300]!),
          _buildLeaderItem(3, "Mantu Patra", "980 XP", Colors.brown[300]!),
          _buildLeaderItem(4, "Aman Gupta", "850 XP", Colors.transparent),
          _buildLeaderItem(5, "Neha Singh", "720 XP", Colors.transparent),
        ],
      ),
    );
  }

  Widget _buildLeaderItem(int rank, String name, String xp, Color badgeColor) {
    return Card(
      color: const Color(0xFF1E1E2C),
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: badgeColor == Colors.transparent ? Colors.deepPurpleAccent : badgeColor,
          child: Text("$rank", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        title: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        trailing: Text(xp, style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 15)),
      ),
    );
  }
}
