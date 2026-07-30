import 'package:flutter/material.dart';

class RanksScreen extends StatelessWidget {
  const RanksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> leaders = [
      {"rank": 1, "name": "@AI Academy", "tips": "\$1,250", "badge": "🥇"},
      {"rank": 2, "name": "@Vybe Creator", "tips": "\$980", "badge": "🥈"},
      {"rank": 3, "name": "@Tech Master", "tips": "\$740", "badge": "🥉"},
      {"rank": 4, "name": "@Code Craft", "tips": "\$510", "badge": "4"},
      {"rank": 5, "name": "@Future AI", "tips": "\$420", "badge": "5"},
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Top Creator Leaderboard', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: leaders.length,
        itemBuilder: (context, index) {
          final item = leaders[index];
          return Card(
            color: Colors.grey[900],
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Text(
                item["badge"],
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.amber),
              ),
              title: Text(
                item["name"],
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                item["tips"],
                style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}
