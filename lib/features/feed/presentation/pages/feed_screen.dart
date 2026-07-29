import 'package:flutter/material.dart';
import '../../../../features/quiz/presentation/widgets/quiz_dialog.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final Map<int, bool> likedStatus = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 5,
        itemBuilder: (context, index) {
          final isLiked = likedStatus[index] ?? false;

          return Stack(
            fit: StackFit.expand,
            children: [
              Container(
                color: const Color(0xFF121218),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_circle_outline, size: 80, color: Colors.deepPurpleAccent.withOpacity(0.8)),
                      const SizedBox(height: 12),
                      Text("Short Video #$index", style: const TextStyle(color: Colors.white54, fontSize: 16)),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 30,
                left: 15,
                right: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.deepPurpleAccent,
                          child: Text("${index + 1}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "@creator_${index + 1}",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Learn Python in 30 Seconds! 🚀 #coding #vybe #tech",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 15,
                bottom: 40,
                child: Column(
                  children: [
                    _buildActionButton(
                      icon: isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.redAccent : Colors.white,
                      label: "1.2k",
                      onTap: () {
                        setState(() {
                          likedStatus[index] = !isLiked;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildActionButton(
                      icon: Icons.quiz,
                      color: Colors.amberAccent,
                      label: "Quiz",
                      onTap: () => QuizDialog.show(context),
                    ),
                    const SizedBox(height: 20),
                    _buildActionButton(
                      icon: Icons.share,
                      color: Colors.white,
                      label: "Share",
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Link copied to clipboard! 🚀")),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
