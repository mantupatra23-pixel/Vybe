import 'package:flutter/material.dart';
import 'screens/upload_screen.dart';
import 'screens/ranks_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/live_grid_screen.dart';
import 'widgets/real_video_card.dart';

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
        scaffoldBackgroundColor: Colors.black,
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
    const VerticalFeedScreen(),
    const LiveGridScreen(),
    const UploadScreen(),
    const RanksScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.black,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow_rounded),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sensors),
            label: 'Live',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Ranks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class VerticalFeedScreen extends StatelessWidget {
  const VerticalFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> feedItems = [
      {
        "creator": "@Vybe Creator",
        "title": "Autonomous AI Video Generator Pipeline ⚡",
        "video_url": "https://assets.mixkit.co/videos/preview/mixkit-tree-with-yellow-leaves-low-angle-shot-40033-large.mp4",
        "likes": 248,
        "comments": 34
      },
      {
        "creator": "@AI Academy",
        "title": "What is Artificial Intelligence in 30 Seconds?",
        "video_url": "https://assets.mixkit.co/videos/preview/mixkit-vertical-shot-of-a-neon-lit-street-at-night-41544-large.mp4",
        "likes": 512,
        "comments": 89
      }
    ];

    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: feedItems.length,
      itemBuilder: (context, index) {
        final item = feedItems[index];
        return RealVideoCard(item: item);
      },
    );
  }
}
