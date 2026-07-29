import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../../features/quiz/presentation/widgets/quiz_dialog.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  // 3 Demo Cloud Videos for testing
  final List<String> videoUrls = [
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: videoUrls.length,
        itemBuilder: (context, index) {
          return VideoFeedItem(
            videoUrl: videoUrls[index],
            index: index,
          );
        },
      ),
    );
  }
}

class VideoFeedItem extends StatefulWidget {
  final String videoUrl;
  final int index;
  const VideoFeedItem({super.key, required this.videoUrl, required this.index});

  @override
  State<VideoFeedItem> createState() => _VideoFeedItemState();
}

class _VideoFeedItemState extends State<VideoFeedItem> {
  late VideoPlayerController _controller;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    // Initialize Real Video
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Real Video Player with Tap to Pause/Play
        GestureDetector(
          onTap: () {
            setState(() {
              _controller.value.isPlaying ? _controller.pause() : _controller.play();
            });
          },
          child: Container(
            color: Colors.black,
            child: _controller.value.isInitialized
                ? SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  )
                : const Center(child: CircularProgressIndicator(color: Colors.deepPurpleAccent)),
          ),
        ),

        // Pause Icon Overlay
        if (!_controller.value.isPlaying && _controller.value.isInitialized)
          const Center(
            child: Icon(Icons.play_arrow, size: 80, color: Colors.white54),
          ),

        // 2. Bottom Info (Number removed, Person Icon added!)
        Positioned(
          bottom: 30,
          left: 15,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.deepPurpleAccent,
                    child: Icon(Icons.person, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "@creator_${widget.index + 1}",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "Learn Python in 30 Seconds! 🚀 #coding #vybe",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),

        // 3. Side Action Buttons
        Positioned(
          right: 15,
          bottom: 40,
          child: Column(
            children: [
              _buildActionButton(
                icon: isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.redAccent : Colors.white,
                label: "1.2k",
                onTap: () => setState(() => isLiked = !isLiked),
              ),
              const SizedBox(height: 20),
              _buildActionButton(
                icon: Icons.quiz,
                color: Colors.amberAccent,
                label: "Quiz",
                onTap: () {
                  _controller.pause(); // Pause video when opening Quiz
                  QuizDialog.show(context);
                },
              ),
              const SizedBox(height: 20),
              _buildActionButton(
                icon: Icons.share,
                color: Colors.white,
                label: "Share",
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({required IconData icon, required Color color, required String label, required VoidCallback onTap}) {
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
