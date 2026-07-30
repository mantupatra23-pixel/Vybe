import 'package:flutter/material.dart';

class CreatorChannelScreen extends StatefulWidget {
  const CreatorChannelScreen({super.key});

  @override
  State<CreatorChannelScreen> createState() => _CreatorChannelScreenState();
}

class _CreatorChannelScreenState extends State<CreatorChannelScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isSubscribed = false;

  final Map<String, dynamic> _channelData = {
    "channel_name": "Vybe AI Labs 🚀",
    "handle": "@vybe_ailabs",
    "subscribers": "45.8K",
    "videos_count": "128",
    "description": "Official AI Video Generation & Automation Studio. Daily short reels & tutorials!",
    "banner_url": "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800",
    "avatar_url": "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500"
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                _channelData["banner_url"],
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Channel Avatar + Subscribe Row
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.amber,
                        child: CircleAvatar(
                          radius: 33,
                          backgroundImage: NetworkImage(_channelData["avatar_url"]),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _channelData["channel_name"],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "${_channelData["handle"]} • ${_channelData["subscribers"]} subscribers • ${_channelData["videos_count"]} videos",
                              style: const TextStyle(color: Colors.white60, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Text(
                    _channelData["description"],
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 16),

                  // Subscribe & Join Membership Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSubscribed ? Colors.grey[800] : Colors.amber,
                            foregroundColor: isSubscribed ? Colors.white : Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () {
                            setState(() {
                              isSubscribed = !isSubscribed;
                            });
                          },
                          child: Text(
                            isSubscribed ? "Subscribed ✔" : "Subscribe",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[900],
                          foregroundColor: Colors.amber,
                          side: const BorderSide(color: Colors.amber),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.star, size: 16),
                        label: const Text("Join \$2/mo"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                indicatorColor: Colors.amber,
                labelColor: Colors.amber,
                unselectedLabelColor: Colors.white54,
                isScrollable: true,
                tabs: const [
                  Tab(text: "Vybe Reels"),
                  Tab(text: "Playlists / Series"),
                  Tab(text: "Community"),
                  Tab(text: "Channel Analytics"),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            // Reels Grid
            GridView.builder(
              padding: const EdgeInsets.all(2),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.grey[900],
                  child: Stack(
                    children: [
                      const Center(child: Icon(Icons.play_circle_fill, color: Colors.amber, size: 30)),
                      Positioned(
                        bottom: 6,
                        left: 6,
                        child: Row(
                          children: [
                            const Icon(Icons.play_arrow, size: 12, color: Colors.white),
                            Text(' ${(index + 1) * 2.4}k', style: const TextStyle(color: Colors.white, fontSize: 10)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Playlists Tab
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 3,
              itemBuilder: (context, index) {
                final titles = ["AI Automation Series ⚡", "Flutter Mobile Mastery 📱", "Groq LLM Tutorials 🤖"];
                return Card(
                  color: Colors.grey[900],
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.video_collection, color: Colors.amber, size: 32),
                    title: Text(titles[index], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: const Text("12 Videos • Updated yesterday", style: TextStyle(color: Colors.white54, fontSize: 12)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 14),
                  ),
                );
              },
            ),

            // Community Tab
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(12)),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(backgroundColor: Colors.amber, radius: 16, child: Icon(Icons.person, color: Colors.black, size: 18)),
                          SizedBox(width: 10),
                          Text("@vybe_ailabs", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text("Which new AI model should we integrate in Vybe next?", style: TextStyle(color: Colors.white)),
                      SizedBox(height: 10),
                      Text("🗳️ Poll: Llama 3.3 vs Falcon TTS vs Claude 3.5", style: TextStyle(color: Colors.amber)),
                    ],
                  ),
                ),
              ],
            ),

            // Analytics Dashboard Tab
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildAnalyticsTile("Total Views (This Month)", "184,200", Icons.show_chart, Colors.greenAccent),
                  _buildAnalyticsTile("Channel Revenue / Tips", "\$1,420.50", Icons.attach_money, Colors.amber),
                  _buildAnalyticsTile("Watch Time (Hours)", "3,210 hrs", Icons.timer, Colors.blueAccent),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsTile(String title, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              const SizedBox(height: 4),
              Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.black,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
