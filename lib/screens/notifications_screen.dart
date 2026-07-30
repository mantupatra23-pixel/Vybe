import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> activities = [
      {
        "title": "Super Tip Received! ⚡",
        "desc": "@Alex tipped you \$10 on 'AI Automation Workflow'.",
        "time": "2 min ago",
        "type": "tip"
      },
      {
        "title": "New Subscriber 🎉",
        "desc": "@TechMaster subscribed to your YouTube-Style Channel.",
        "time": "15 min ago",
        "type": "sub"
      },
      {
        "title": "Reel Going Viral! 🔥",
        "desc": "Your video hit 10,000 views on Vybe Feed.",
        "time": "2 hours ago",
        "type": "alert"
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Activity Center', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final item = activities[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: item["type"] == "tip" ? Colors.amber : Colors.blueAccent,
                  child: Icon(
                    item["type"] == "tip" ? Icons.flash_on : Icons.notifications,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item["title"]!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(item["desc"]!, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      const SizedBox(height: 6),
                      Text(item["time"]!, style: const TextStyle(color: Colors.white38, fontSize: 10)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
