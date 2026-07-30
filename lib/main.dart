import 'package:flutter/material.dart';
import 'screens/upload_screen.dart';
import 'screens/ranks_screen.dart';
import 'screens/profile_screen.dart';
import 'widgets/video_action_bar.dart';
import 'widgets/tip_modal.dart';

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
        "likes": 248,
        "comments": 34
      },
      {
        "creator": "@AI Academy",
        "title": "What is Artificial Intelligence in 30 Seconds?",
        "likes": 512,
        "comments": 89
      },
      {
        "creator": "@Code Craft",
        "title": "Flutter 3.19 + FastAPI Fullstack Setup",
        "likes": 189,
        "comments": 12
      }
    ];

    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: feedItems.length,
      itemBuilder: (context, index) {
        final item = feedItems[index];
        return FeedItemCard(item: item);
      },
    );
  }
}

class FeedItemCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const FeedItemCard({super.key, required this.item});

  void _openTipSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: TipModal(creatorName: item["creator"]),
      ),
    );
  }

  void _showCommentsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Comments',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const Divider(color: Colors.white24),
              Expanded(
                child: ListView(
                  children: const [
                    ListTile(
                      leading: CircleAvatar(backgroundColor: Colors.amber, child: Text('A')),
                      title: Text('Alex', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      subtitle: Text('Insane smooth reel transitions! 🔥', style: TextStyle(color: Colors.white)),
                    ),
                    ListTile(
                      leading: CircleAvatar(backgroundColor: Colors.blue, child: Text('M')),
                      title: Text('Mantu', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      subtitle: Text('Fullstack Flutter + Termux setup ready 🚀', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  suffixIcon: const Icon(Icons.send, color: Colors.amber),
                  filled: true,
                  fillColor: Colors.black,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Reel Video Card Placeholder
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.play_circle_fill, size: 70, color: Colors.amber),
                const SizedBox(height: 12),
                Text(
                  'Swipe Up for Next Reel 👆',
                  style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
                ),
              ],
            ),
          ),
        ),

        // Bottom Creator Info Overlay
        Positioned(
          left: 16,
          bottom: 20,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item["creator"],
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(
                item["title"],
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () => _openTipSheet(context),
                icon: const Icon(Icons.flash_on, size: 18),
                label: const Text('Tip \$', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),

        // Right Overlay Action Bar
        Positioned(
          right: 16,
          bottom: 30,
          child: VideoActionBar(
            initialLikes: item["likes"],
            commentsCount: item["comments"],
            onCommentPressed: () => _showCommentsSheet(context),
          ),
        ),
      ],
    );
  }
}
