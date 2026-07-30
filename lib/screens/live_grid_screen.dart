import 'package:flutter/material.dart';

class LiveGridScreen extends StatefulWidget {
  const LiveGridScreen({super.key});

  @override
  State<LiveGridScreen> createState() => _LiveGridScreenState();
}

class _LiveGridScreenState extends State<LiveGridScreen> {
  String _selectedCategory = "For You";

  final List<String> _categories = ["For You", "AI Series", "Popular", "Top Tippers"];

  final List<Map<String, dynamic>> _liveCreators = [
    {
      "name": "Mantu Patra",
      "tag": "LIVE",
      "views": "1.2k",
      "likes": "450",
      "avatar": "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500"
    },
    {
      "name": "AI Academy",
      "tag": "AI BOT",
      "views": "3.4k",
      "likes": "1.1k",
      "avatar": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500"
    },
    {
      "name": "Vybe Official",
      "tag": "LIVE",
      "views": "890",
      "likes": "210",
      "avatar": "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500"
    },
    {
      "name": "Tech Master",
      "tag": "BATTLE",
      "views": "5.6k",
      "likes": "2.3k",
      "avatar": "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Vybe Live Hub ⚡',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Top Category Pills
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = cat;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.amber : Colors.grey[900],
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: isSelected ? Colors.amber : Colors.white12),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Live Grid (2 Columns like Moj/Tango)
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _liveCreators.length,
              itemBuilder: (context, index) {
                final item = _liveCreators[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      // Background Image
                      Image.network(
                        item["avatar"],
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      // Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.8),
                            ],
                          ),
                        ),
                      ),
                      // Top LIVE Tag
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: item["tag"] == "LIVE" ? Colors.red : Colors.amber,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item["tag"],
                            style: TextStyle(
                              color: item["tag"] == "LIVE" ? Colors.white : Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // Views and Likes Info
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Row(
                          children: [
                            const Icon(Icons.remove_red_eye, size: 12, color: Colors.white70),
                            const SizedBox(width: 4),
                            Text(
                              item["views"],
                              style: const TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      // Creator Name
                      Positioned(
                        bottom: 12,
                        left: 12,
                        right: 12,
                        child: Text(
                          item["name"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
