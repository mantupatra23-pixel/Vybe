import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Placeholder Video Background
              Container(
                color: Colors.blueGrey[900],
                child: Center(
                  child: Icon(Icons.play_circle_outline, size: 80, color: Colors.white70),
                ),
              ),

              // Overlay Information & Actions
              Positioned(
                bottom: 30,
                left: 15,
                right: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "@creator_$index",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Learn Python in 30 Seconds! 🚀 #coding #vybe #tech",
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),

              // Side Action Buttons (Like, Quiz, Share)
              Positioned(
                right: 15,
                bottom: 40,
                child: Column(
                  children: [
                    _buildActionButton(Icons.favorite, "1.2k"),
                    const SizedBox(height: 20),
                    _buildActionButton(Icons.quiz, "Quiz"),
                    const SizedBox(height: 20),
                    _buildActionButton(Icons.share, "Share"),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}
